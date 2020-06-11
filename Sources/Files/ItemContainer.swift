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
     case custom((ItemCommon) -> Bool)
     case compound(Filter, Filter)
     
     func passes(_ item: ItemCommon) -> Bool {
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
    typealias FileType = Manager.FileType
    typealias FolderType = Manager.FolderType
    var up: FolderType { get }
    func file(_ name: ItemName) -> FileType
    func folder(_ name: ItemName) -> FolderType
    func file(_ name: String) -> FileType
    func folder(_ name: String) -> FolderType
    func item(_ name: ItemName) -> ItemCommon?
    func item(_ name: String) -> ItemCommon?
//    func forEach(inParallelWith parallel: Self?, order: Order, filter: Filter, recursive: Bool, do block: (ItemType, Self?) -> Void) throws
}

public extension ItemContainer {
    var up: FolderType {
        ref.manager.folder(for: ref.url.deletingLastPathComponent())
    }
    
    func file(_ name: ItemName) -> FileType {
        return ref.manager.file(for: ref.url.appending(name))
    }
    
     func file(_ name: String) -> FileType {
         file(ItemName(name))
     }

    func folder(_ name: ItemName) -> FolderType {
        return ref.manager.folder(for: ref.url.appending(name))
    }
    
    func folder(_ name: String) -> FolderType {
        folder(ItemName(name))
    }
    
    func folder(_ components: [String]) -> FolderType {
        return ref.manager.folder(for: ref.url.appendingPathComponents(components))
    }

    func item(_ name: ItemName) -> ItemCommon? {
        let url = ref.url.appending(name)
        var isDirectory: ObjCBool = false
        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
    }

    func item(_ name: String) -> ItemCommon? {
        item(ItemName(name))
    }
 }
