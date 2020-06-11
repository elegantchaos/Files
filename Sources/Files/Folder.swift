// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct Folder: Item {
    public indirect enum Filter {
        case none
        case files
        case folders
        case visible
        case hidden
        case custom((Item) -> Bool)
        case compound(Filter, Filter)
        
        func passes(_ item: Item) -> Bool {
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
    
    public var quiet: QuietFolder { QuietFolder(wrapped: self) }

    public var up: Folder {
        let url = ref.url.deletingLastPathComponent()
        return ref.manager.folder(for: url)
    }

    public func create() throws {
        try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
    }

    public func sameType(with url: URL) -> Folder {
        return ref.manager.folder(for: url)
    }

    public func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (Item) -> Void) throws {
        try forEach(inParallelWith: nil, order: order, filter: filter, recursive: recursive) { item, _ in block(item) }
    }

    public func forEach(inParallelWith parallel: Folder?, order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (Item, Folder?) -> Void) throws {
        var files: [File] = []
        var folders: [Folder] = []
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

        func processFolders() throws {
            if recursive {
                try folders.forEach() { folder in
                    let nested = parallel?.folder(name)
                    try nested?.create()
                    try folder.forEach(inParallelWith: nested, order: order, filter: filter, recursive: recursive, do: block)
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
            try processFolders()
            
        case .foldersFirst:
            try processFolders()
            processFiles()
        }
    }
}

extension Folder: ItemContainer {
    public typealias FileType = File
    public typealias FolderType = Folder
    
    public func file(for url: URL) -> File {
        return ref.manager.file(for: url)
    }

    public func folder(for url: URL) -> Folder {
        return ref.manager.folder(for: url)
    }

    public func item(_ name: ItemName) -> ItemBase? {
        let url = ref.url.appending(name)
        var isDirectory: ObjCBool = false
        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
    }
}

extension Folder: CustomStringConvertible {
    public var description: String { "📁: \"\(name.fullName)\" (\(ref.url.path))" }
}
