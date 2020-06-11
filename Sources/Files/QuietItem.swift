// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation


protocol QuietCommon: ItemCommon {
    func delete()
    func rename(as newName: ItemName, replacing: Bool) -> Self?
    @discardableResult func copy(to folder: QuietFolder, as newName: ItemName?, replacing: Bool) -> Self?
}

protocol QuietItem: Item, QuietCommon {
}

extension QuietItem where Manager == QuietLocationManager {
    func rename(as newName: ItemName, replacing: Bool = false) -> Self? {
        do {
            let source = ref.url
            let dest = ref.url.deletingLastPathComponent().appending(newName)
            if replacing {
                try? ref.manager.manager.removeItem(at: dest)
            }

            try ref.manager.manager.moveItem(at: source, to: dest)
            return sameType(with: dest)
        } catch {
            ref.manager.log(error)
            return nil
        }
    }
    
    func delete() {
        ref.manager.attempt {
            try ref.manager.manager.removeItem(at: ref.url)
        }
    }

    @discardableResult func copy(to folder: QuietFolder, as newName: ItemName?, replacing: Bool = false) -> Self? {
        do {
            let copiedRef = try ref.copy(to: folder.ref, as: newName)
            return Self(ref: copiedRef)
        } catch {
            ref.manager.log(error)
            return nil
        }
    }

    @discardableResult func copy(to folder: QuietFolder, as newName: String? = nil, replacing: Bool = false) -> Self? {
        let name = newName == nil ? nil : ItemName(newName!)
        return copy(to: folder, as: name, replacing: replacing)
    }

}
