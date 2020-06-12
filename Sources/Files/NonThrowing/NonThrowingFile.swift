// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct NonThrowingFile: NonThrowingItem {
    public let ref: NonThrowingReference
    public var isFile: Bool { true }
    public typealias Manager = NonThrowingManager
    
    public init(ref: NonThrowingReference) {
        self.ref = ref
    }
}
