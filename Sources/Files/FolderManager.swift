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
    
    func folder(for url: URL) -> FolderType
    func file(for url: URL) -> FileType
}

public protocol LocationRef {
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

    var desktop: FolderType { return folder(for: manager.desktopDirectory()) }
    var current: FolderType { return folder(for: manager.workingDirectory()) }
    var home: FolderType { return folder(for: manager.homeDirectory()) }
    var temporary: FolderType { return folder(for: manager.temporaryDirectory()) }
}
