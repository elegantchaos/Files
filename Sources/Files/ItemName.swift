// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 09/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ItemName {
    public let name: String
    public let pathExtension: String?
    
    public var fullName: String {
        if let ext = pathExtension {
            return "\(name).\(ext)"
        } else {
            return "\(name)"
        }
    }
    
    public init(_ name: String, pathExtension: String? = nil) {
        self.name = name
        self.pathExtension = pathExtension
    }
    
    public func renamed(as newName: String) -> ItemName {
        ItemName(newName, pathExtension: pathExtension)
    }
}

extension ItemName: Equatable {
}

extension ItemName: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        let items = value.split(separator: ".", omittingEmptySubsequences: false)
        if items.count > 1, let ext = items.last {
            pathExtension = String(ext)
            name = String(value[..<value.index(value.endIndex, offsetBy: -(ext.count + 1))])
        } else {
            pathExtension = nil
            name = value
        }
    }
}

extension ItemName: CustomStringConvertible {
    public var description: String { fullName }
}
