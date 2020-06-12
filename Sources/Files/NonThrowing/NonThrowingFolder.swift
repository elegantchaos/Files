// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct NonThrowingFolder: ItemContainer, NonThrowingItem {
    public let ref: NonThrowingReference
    public var isFile: Bool { false }
    public typealias Manager = NonThrowingManager

    func create() {
        ref.manager.attempt {
            try ref.createFolder()
        }
    }
    
    public init(ref: NonThrowingReference) {
        self.ref = ref
    }
}
