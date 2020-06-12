// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol NonThrowingCommon: ItemCommon {
    func delete()
    func rename(as newName: ItemName, replacing: Bool) -> Self?
    @discardableResult func copy(to folder: NonThrowingFolder, as newName: ItemName?, replacing: Bool) -> Self?
}

public protocol NonThrowingItem: Item, NonThrowingCommon {
}

public extension NonThrowingItem where Manager == NonThrowingManager {
    func rename(as newName: ItemName, replacing: Bool = false) -> Self? {
        let renamed = ref.manager.attemptReturning {
            return try ref.rename(as: newName, replacing: replacing)
        }
    
        return Self(ref: renamed)
    }
    
    func delete() {
        ref.manager.attempt {
            try ref.manager.manager.removeItem(at: ref.url)
        }
    }

    @discardableResult func copy(to folder: NonThrowingFolder, as newName: ItemName?, replacing: Bool = false) -> Self? {
        let copied = ref.manager.attemptReturning() {
            return try ref.copy(to: folder.ref, as: newName, replacing: replacing)
        }
        return Self(ref: copied)
    }

    @discardableResult func copy(to folder: NonThrowingFolder, as newName: String? = nil, replacing: Bool = false) -> Self? {
        let name = newName == nil ? nil : ItemName(newName!)
        return copy(to: folder, as: name, replacing: replacing)
    }

}
