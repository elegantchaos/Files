// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation


public struct ThrowingFile: ThrowingItem {
    public typealias Manager = ThrowingManager
    public let ref: ThrowingReference
    public var isFile: Bool { true }
    public var asText: String? { try? String(contentsOf: ref.url, encoding: .utf8) }
    public var asData: Data? { try? Data(contentsOf: ref.url) }
    
    public init(ref: ThrowingReference) {
        self.ref = ref
    }
    
    public func write(as text: String) { try? text.write(to: ref.url, atomically: true, encoding: .utf8) } // deprecated
    public func write(asText text: String) { try? text.write(to: ref.url, atomically: true, encoding: .utf8) }
    public func write(asData data: Data) { try? data.write(to: ref.url) }
}

extension ThrowingFile: Equatable {
}
