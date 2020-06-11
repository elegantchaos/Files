// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation


public struct File: ThrowingItem {
    public typealias Manager = ThrowingManager
    public let ref: ThrowingRef
    public var isFile: Bool { true }
    public var asText: String? { try? String(contentsOf: ref.url, encoding: .utf8) }
    
    public init(ref: ThrowingRef) {
        self.ref = ref
    }
    
    public func write(as text: String) { try? text.write(to: ref.url, atomically: true, encoding: .utf8) }
}

extension File: CustomStringConvertible {
    public var description: String { "📄: \"\(name.fullName)\" (\(ref.url.path))" }
}
