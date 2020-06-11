// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct Folder: ThrowingItem {
 
    
    public let ref: FolderManager.Ref
    public var isFile: Bool { false }
    
    public var quiet: QuietFolder { QuietFolder(wrapped: self) }

    public func create() throws {
        try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
    }

    public func sameType(with url: URL) -> Folder {
        return ref.manager.folder(for: url)
    }
}

extension Folder: ItemContainer {
    public typealias FileType = File
    public typealias FolderType = Folder
    
    public func file(for url: URL) -> File {
        return ref.manager.file(for: url)
    }

    public func folder(for url: URL) -> Folder {
        return ref.manager.folder(for: url)
    }

    public func item(_ name: ItemName) -> Item? {
        let url = ref.url.appending(name)
        var isDirectory: ObjCBool = false
        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
    }
}

extension Folder: CustomStringConvertible {
    public var description: String { "📁: \"\(name.fullName)\" (\(ref.url.path))" }
}
