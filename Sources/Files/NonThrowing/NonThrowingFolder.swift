// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct NonThrowingFolder: ItemContainer, NonThrowingItem {
    let ref: NonThrowingReference
    var isFile: Bool { false }
    typealias Manager = NonThrowingManager

    func create() {
        ref.manager.attempt {
            try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
        }
    }
}