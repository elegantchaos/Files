// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/02/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ThrowingReference: ItemLocation {
    public typealias Manager = ThrowingManager

    public let url: URL
    public let manager: ThrowingManager
    public init(for url: URL, manager: Manager) {
        self.url = url
        self.manager = manager
    }
}

extension ThrowingReference: Equatable {
    
}
