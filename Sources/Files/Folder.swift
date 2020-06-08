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
    
    public func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (FolderItem) -> Void) {
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

        switch order {
        case .filesFirst:
            files.forEach(block)
            folders.forEach(block)
            if recursive {
                folders.forEach() { folder in
                    folder.forEach(order: order, filter: filter, recursive: recursive, do: block)
                }
            }
            
        case .foldersFirst:
            if recursive {
                folders.forEach() { folder in
                    folder.forEach(order: order, filter: filter, recursive: recursive, do: block)
                }
            }
            folders.forEach(block)
            files.forEach(block)
        }
    }
}
