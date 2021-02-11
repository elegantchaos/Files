// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ThrowingManager: FolderManager {
    public let manager: FileManager
    public typealias FileType = ThrowingFile
    public typealias FolderType = ThrowingFolder
    public typealias ReferenceType = ThrowingReference
    public typealias ItemType = ThrowingCommon

    public static var `default` = FileManager.default.locations
    
    public static func folder(for url: URL) -> ThrowingFolder {
        return self.default.folder(for: url)
    }
    
    public static func file(for url: URL) -> ThrowingFile {
        return self.default.file(for: url)
    }
    
    public func asThrowing(_ file: NonThrowingFile) -> ThrowingFile {
        ThrowingFile(ref: ThrowingReference(for: file.url, manager: self))
    }
    
    public func asThrowing(_ folder: NonThrowingFolder) -> ThrowingFolder {
        ThrowingFolder(ref: ThrowingReference(for: folder.url, manager: self))
    }

}

public extension FileManager {
    var locations: ThrowingManager { ThrowingManager(manager: self) }
}

extension ThrowingManager: Equatable {
    
}
