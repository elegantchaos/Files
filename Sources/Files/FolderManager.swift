// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol FolderManager where FileType: Item, FolderType: ItemContainer, ReferenceType: LocationRef, ReferenceType.Manager == Self, FileType.Manager == Self, FolderType.Manager == Self {
    var manager: FileManager { get }
    associatedtype FileType
    associatedtype FolderType
    associatedtype ReferenceType
    typealias ItemType = ItemCommon
    
    func folder(for url: URL) -> FolderType
    func file(for url: URL) -> FileType
    func item(for url: URL) -> ItemType
}

public protocol LocationRef where Manager: FolderManager {
    associatedtype Manager
    var url: URL { get }
    var manager: Manager { get }
    init(for url: URL, manager: Manager)
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

public extension LocationRef {
    @discardableResult func copy(to folder: Self, as newName: ItemName?, replacing: Bool = false) throws -> Self {
        let source = url
        var dest = folder.url
        if let name = newName {
            dest = dest.appending(name)
        } else {
            dest = dest.appendingPathComponent(source.lastPathComponent)
        }

        if replacing {
            try? manager.manager.removeItem(at: dest)
        }

        try manager.manager.copyItem(at: source, to: dest)

        return Self(for: dest, manager: manager)
    }

    func rename(as newName: ItemName, replacing: Bool = false) throws -> Self {
        let dest = url.deletingLastPathComponent().appending(newName)
        if replacing {
            try? manager.manager.removeItem(at: dest)
        }

        try manager.manager.moveItem(at: url, to: dest)
        return Self(for: dest, manager: manager)
    }

}
