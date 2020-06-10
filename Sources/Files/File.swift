// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct File: FolderItem {
    public let ref: FolderManager.Ref
    public var isFile: Bool { true }
    
    public var asText: String? { try? String(contentsOf: ref.url, encoding: .utf8) }
    public func write(as text: String) { try? text.write(to: ref.url, atomically: true, encoding: .utf8) }

    public func copy(to folder: Folder, as newName: ItemName? = nil, replacing: Bool = false) -> File {
        let url = rawCopy(to: folder, as: newName, replacing: replacing)
        return ref.manager.file(for: url)
    }
}

extension File: CustomStringConvertible {
    public var description: String { "File(\"\(name.fullName)\")" }
}
