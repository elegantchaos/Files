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
    
    public func file(name: String, pathExtension: String) -> File {
        let url = ref.url.appendingPathComponent(name).appendingPathExtension(pathExtension)
        return ref.manager.file(for: url)
    }
    
    public func folder(name: String, pathExtension: String? = nil) -> Folder {
        var url = ref.url.appendingPathComponent(name)
        if let pathExtension = pathExtension {
            url = url.appendingPathExtension(pathExtension)
        }
        return ref.manager.folder(for: url)
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
                    if filter.passes(item) { folders.append(item) }
                } else {
                    let item = manager.file(for: item)
                    if filter.passes(item) { files.append(item) }
                }
            }
        } catch {
            
        }

        func recurseIfNecessary() {
            if recursive {
                folders.forEach() { folder in
                    let nested = parallel?.folder(name: folder.name, pathExtension: folder.pathExtension)
                    folder.forEach(inParallelWith: nested, order: order, filter: filter, recursive: recursive, do: block)
                }
            }
        }
        
        switch order {
        case .filesFirst:
            files.forEach({ block($0, parallel) })
            folders.forEach({ block($0, parallel) })
            recurseIfNecessary()
            
        case .foldersFirst:
            recurseIfNecessary()
            folders.forEach({ block($0, parallel) })
            files.forEach({ block($0, parallel) })
        }
    }
}
