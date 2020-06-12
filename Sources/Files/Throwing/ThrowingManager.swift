// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
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

public struct ThrowingManager: FolderManager {
    public let manager: FileManager
    public typealias FileType = ThrowingFile
    public typealias FolderType = ThrowingFolder
    public typealias ReferenceType = ThrowingReference
    public typealias ItemType = ThrowingCommon
}

public extension FileManager {
    var locations: ThrowingManager { ThrowingManager(manager: self) }
}
