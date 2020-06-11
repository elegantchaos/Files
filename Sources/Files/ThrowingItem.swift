// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol ThrowingCommon: ItemCommon {
    func delete() throws
    @discardableResult func rename(as: ItemName, replacing: Bool) throws -> Self
    @discardableResult func copy(to: Folder, as: ItemName?, replacing: Bool) throws -> Self
}

public protocol ThrowingItem: Item, ThrowingCommon {
}

public extension ThrowingItem {
    func delete() throws {
        try ref.manager.manager.removeItem(at: ref.url)
    }

    @discardableResult func copy(to folder: Manager.FolderType, as newName: ItemName?, replacing: Bool = false) throws -> Self {
        let source = ref.url
        var dest = folder.ref.url
        if let name = newName {
            dest = dest.appending(name)
        } else {
            dest = dest.appendingPathComponent(source.lastPathComponent)
        }

        if replacing {
            try? ref.manager.manager.removeItem(at: dest)
        }

        try ref.manager.manager.copyItem(at: source, to: dest)

        return sameType(with: dest)
    }
    
    @discardableResult func rename(as newName: ItemName, replacing: Bool = false) throws -> Self {
        let source = ref.url
        let dest = ref.url.deletingLastPathComponent().appending(newName)
        if replacing {
            try? ref.manager.manager.removeItem(at: dest)
        }
        
        try ref.manager.manager.moveItem(at: source, to: dest)
        return sameType(with: dest)
    }

    @discardableResult func copy(to folder: Manager.FolderType, as newName: String? = nil, replacing: Bool = false) throws -> Self {
        let name = newName == nil ? nil : ItemName(newName!)
        return try copy(to: folder, as: name, replacing: replacing)
    }
    
    @discardableResult func rename(as newName: String, replacing: Bool = false) throws -> Self {
        return try rename(as: ItemName(newName), replacing: replacing)
    }

}

