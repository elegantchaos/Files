// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct Folder: FolderItem {
    public indirect enum Filter {
        case none
        case files
        case folders
        case visible
        case hidden
        case custom((FolderItem) -> Bool)
        case compound(Filter, Filter)
        
        func passes(_ item: FolderItem) -> Bool {
            switch self {
            case .none: return true
            case .files: return item.isFile
            case .folders: return !item.isFile
            case .visible: return !item.isHidden
            case .hidden: return item.isHidden
            case .custom(let filter): return filter(item)
            case .compound(let f1, let f2): return f1.passes(item) && f2.passes(item)
            }
        }
    }
    
    public enum Order {
        case filesFirst
        case foldersFirst
    }
    
    public let ref: FolderManager.Ref
    public var isFile: Bool { false }
    
    public func file(_ name: ItemName) -> File {
        let url = ref.url.appending(name)
        return ref.manager.file(for: url)
    }
    
    public func folder(_ name: ItemName) -> Folder {
        let url = ref.url.appending(name)
        return ref.manager.folder(for: url)
    }

    public func item(_ name: ItemName) -> FolderItem? {
        let url = ref.url.appending(name)
        var isDirectory: ObjCBool = false
        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
    }
    public func folder(_ components: [String]) -> Folder {
        let url = ref.url.appendingPathComponents(components)
        return ref.manager.folder(for: url)
    }

    public var up: Folder {
        let url = ref.url.deletingLastPathComponent()
        return ref.manager.folder(for: url)
    }

    public func copy(to folder: Folder, as newName: ItemName? = nil, replacing: Bool = false) -> Folder {
        let url = rawCopy(to: folder, as: newName, replacing: replacing)
        return ref.manager.folder(for: url)
    }

    public func create() {
        do {
            try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error)
        }
    }
    
    public func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (FolderItem) -> Void) {
        forEach(inParallelWith: nil, order: order, filter: filter, recursive: recursive) { item, _ in block(item) }
    }

    public func forEach(inParallelWith parallel: Folder?, order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (FolderItem, Folder?) -> Void) {
        var files: [File] = []
        var folders: [Folder] = []
        do {
            let manager = ref.manager
            let contents = try manager.manager.contentsOfDirectory(at: ref.url, includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey], options: [])
            for item in contents {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                if values.isDirectory ?? false {
                    let item = manager.folder(for: item)
                    folders.append(item)
                } else {
                    let item = manager.file(for: item)
                    if filter.passes(item) { files.append(item) }
                }
            }
        } catch {
            
        }

        func processFolders() {
            if recursive {
                folders.forEach() { folder in
                    let nested = parallel?.folder(name)
                    nested?.create()
                    folder.forEach(inParallelWith: nested, order: order, filter: filter, recursive: recursive, do: block)
                }
            }
            
            let filtered = folders.filter({ filter.passes($0) })
            filtered.forEach({ block($0, parallel) })
        }
        
        func processFiles() {
            files.forEach({ block($0, parallel) })
        }
        
        switch order {
        case .filesFirst:
            processFiles()
            processFolders()
            
        case .foldersFirst:
            processFolders()
            processFiles()
        }
    }
}

extension Folder: CustomStringConvertible {
    public var description: String { "📁: \"\(name.fullName)\" (\(ref.url.path))" }
}
