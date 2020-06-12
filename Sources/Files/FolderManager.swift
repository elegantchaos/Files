// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation


/// Manager of file/folder items.
///
/// Objects that implement this protocol can vend file and folder objects for urls.
///
/// They also know about certain standard locations, such as the home directory, library directory
/// and so on.
///
/// The object is associated with a system FileManager object, which it uses to perform file handling
/// operations.
///
/// By default we supply two implementations of the protocol: ThrowingManager and NonThrowingManager.
/// As the names suggest, the difference between them is in how they treat errors.
///
/// The throwing manager throws the underlying file system errors.
/// The non-throwing manager catches them, and calls a user-supplied callback to process them.
///
/// You can obtain an instance of one of these implementations by calling `locations` or `nothrow`
/// on a FileManager instance. Each call returns a new instance, so you should cache them internally
/// if you just want to use one.

public protocol FolderManager where FileType: Item, FolderType: ItemContainer, ReferenceType: ItemLocation, ReferenceType.Manager == Self, FileType.Manager == Self, FolderType.Manager == Self {
    var manager: FileManager { get }
    associatedtype FileType
    associatedtype FolderType
    associatedtype ReferenceType
    associatedtype ItemType
    
    func folder(for url: URL) -> FolderType
    func file(for url: URL) -> FileType
    func item(for url: URL) -> ItemType
}

public extension FolderManager {
    func ref(for url: URL) -> ReferenceType {
        ReferenceType(for: url, manager: self)
    }
    
    func folder(for url: URL) -> FolderType {
        return FolderType(ref: ref(for: url))
    }

    func file(for url: URL) -> FileType {
        return FileType(ref: ref(for: url))
    }

    func item(for url: URL) -> ItemType {
        var isDirectory: ObjCBool = false
        if manager.fileExists(atPath: url.path, isDirectory: &isDirectory), isDirectory.boolValue {
            return folder(for: url) as! ItemType
        } else {
            return file(for: url) as! ItemType
        }
    }
    
    var desktop: FolderType { return folder(for: manager.desktopDirectory()) }
    var current: FolderType { return folder(for: manager.workingDirectory()) }
    var home: FolderType { return folder(for: manager.homeDirectory()) }
    var temporary: FolderType { return folder(for: manager.temporaryDirectory()) }
}

/// The throwing variant is expected to be used most of the time.
/// For the sake of clarity, we define some aliases for it to supply simpler names.

public typealias Folder = ThrowingFolder
public typealias File = ThrowingFile
public typealias Item = ThrowingCommon
