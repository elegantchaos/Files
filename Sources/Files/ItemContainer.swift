// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol ItemContainer {
    associatedtype FileType
    associatedtype FolderType
    
    var ref: FolderManager.Ref { get }
    func file(_ name: ItemName) -> FileType
    func folder(_ name: ItemName) -> FolderType
    func item(_ name: ItemName) -> ItemBase?
    func item(_ name: String) -> ItemBase?
    func file(_ name: String) -> FileType
    func folder(_ name: String) -> FolderType
    func folder(for url: URL) -> FolderType
    func file(for url: URL) -> FileType
}

public extension ItemContainer {
    func file(_ name: ItemName) -> FileType {
        return file(for: ref.url.appending(name))
    }

    func folder(_ name: ItemName) -> FolderType {
        return folder(for: ref.url)
    }

    func item(_ name: ItemName) -> ItemBase? {
        let url = ref.url.appending(name)
        var isDirectory: ObjCBool = false
        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
    }

    func item(_ name: String) -> ItemBase? {
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

}
