// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

protocol QuietItem: Item {
}

extension QuietItem where Manager == QuietLocations {
    func rename(as newName: ItemName, replacing: Bool = false) -> Self {
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
            return self
        }
    }
    
    func delete() {
        ref.manager.attempt {
            try ref.manager.manager.removeItem(at: ref.url)
        }
    }
}
