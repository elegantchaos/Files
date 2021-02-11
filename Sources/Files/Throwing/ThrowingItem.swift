// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol ThrowingCommon: ItemCommon {
    func delete() throws
    @discardableResult func rename(as: ItemName, replacing: Bool) throws -> Self
    @discardableResult func copy(to: ThrowingFolder, as: ItemName?, replacing: Bool) throws -> Self
}

public extension ThrowingCommon {
    @discardableResult func copy(to folder: ThrowingFolder, as newName: String? = nil, replacing: Bool = false) throws -> Self {
        let name = newName == nil ? nil : ItemName(newName!)
        return try copy(to: folder, as: name, replacing: replacing)
    }
}

public protocol ThrowingItem: Item, ThrowingCommon {
}

public extension ThrowingItem {
    func delete() throws {
        try ref.manager.manager.removeItem(at: ref.url)
    }

    @discardableResult func copy(to folder: Manager.FolderType, as newName: ItemName? = nil, replacing: Bool = false) throws -> Self {
        let copiedRef = try ref.copy(to: folder.ref, as: newName, replacing: replacing)
        return Self(ref: copiedRef)
    }

    @discardableResult func rename(as newName: ItemName, replacing: Bool = false) throws -> Self {
        let renamed = try ref.rename(as: newName, replacing: replacing)
        return Self(ref: renamed)
    }

    @discardableResult func rename(as newName: String, replacing: Bool = false) throws -> Self {
        return try rename(as: ItemName(newName), replacing: replacing)
    }

}

