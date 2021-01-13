// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct NonThrowingFile: NonThrowingItem {
    public let ref: NonThrowingReference
    public var isFile: Bool { true }
    public typealias Manager = NonThrowingManager

    public var asText: String? { try? String(contentsOf: ref.url, encoding: .utf8) }
    public var asData: Data? { try? Data(contentsOf: ref.url) }

    public init(ref: NonThrowingReference) {
        self.ref = ref
    }

    public func write(asText text: String) { try? text.write(to: ref.url, atomically: true, encoding: .utf8) }
    public func write(asData data: Data) { try? data.write(to: ref.url) }

}
