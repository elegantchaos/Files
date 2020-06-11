// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

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

public protocol ItemContainer: Item {
    associatedtype FileType
    associatedtype FolderType
    
    var ref: FolderManager.Ref { get }
    var up: FolderType { get }
    func file(_ name: ItemName) -> FileType
    func folder(_ name: ItemName) -> FolderType
    func item(_ name: ItemName) -> Item?
    func item(_ name: String) -> Item?
    func file(_ name: String) -> FileType
    func folder(_ name: String) -> FolderType
    func folder(for url: URL) -> FolderType
    func file(for url: URL) -> FileType
    func forEach(inParallelWith parallel: Self?, order: Order, filter: Filter, recursive: Bool, do block: (Item, Self?) -> Void) throws
}

public extension ItemContainer where FolderType: ItemContainer, FileType: Item, FolderType == Self {
    var up: FolderType {
        return folder(for: ref.url.deletingLastPathComponent())
    }
    
    func file(_ name: ItemName) -> FileType {
        return file(for: ref.url.appending(name))
    }

    func folder(_ name: ItemName) -> FolderType {
        return folder(for: ref.url)
    }

    func item(_ name: ItemName) -> Item? {
        let url = ref.url.appending(name)
        var isDirectory: ObjCBool = false
        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
    }

    func item(_ name: String) -> Item? {
        item(ItemName(name))
    }
    
    func file(_ name: String) -> FileType {
        file(ItemName(name))
    }
    
    func folder(_ name: String) -> FolderType {
        folder(ItemName(name))
    }
    
    func folder(_ components: [String]) -> FolderType {
        return folder(for: ref.url.appendingPathComponents(components))
    }

    func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (Item) -> Void) throws {
        try forEach(inParallelWith: nil, order: order, filter: filter, recursive: recursive) { item, _ in block(item) }
    }

    func forEach(inParallelWith parallel: Self?, order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (Item, Self?) -> Void) throws {
         var files: [FileType] = []
         var folders: [FolderType] = []
         let manager = ref.manager
         let contents = try manager.manager.contentsOfDirectory(at: ref.url, includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey], options: [])
         for item in contents {
             let values = try item.resourceValues(forKeys: [.isDirectoryKey])
             if values.isDirectory ?? false {
                 let item = folder(for: item)
                 folders.append(item)
             } else {
                 let item = file(for: item)
                 if filter.passes(item) { files.append(item) }
             }
         }

         func processFolders() throws {
             if recursive {
                 try folders.forEach { folder in
                    let nested: Optional<FolderType>
                    if let parallel = parallel {
                        let nestedURL = parallel.ref.url.appendingPathComponent(ref.url.lastPathComponent)
                        try? ref.manager.manager.createDirectory(at: nestedURL, withIntermediateDirectories: true, attributes: nil)
                        nested = self.folder(for: nestedURL)
                    } else {
                        nested = nil
                    }
                    
                    try folder.forEach(inParallelWith: nested, order: order, filter: filter, recursive: recursive, do: block)
                 }
             }
             
             let filtered = folders.filter({ return filter.passes($0) })
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
