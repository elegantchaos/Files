// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol NuItem where Manager: LocationsManager {
    associatedtype Manager
    
    var ref: Manager.ReferenceType { get }
    init(ref: Manager.ReferenceType)
}

public extension NuItem {
    
}
public protocol NuItemContainer: NuItem {
    typealias FileType = Manager.FileType
    typealias FolderType = Manager.FolderType
    var ref: FolderManager.Ref { get }
//    var up: FolderType { get }
//    func file(_ name: ItemName) -> FileType
//    func folder(_ name: ItemName) -> FolderType
//    func item(_ name: ItemName) -> NuItem?
//    func item(_ name: String) -> ItemType?
//    func file(_ name: String) -> FileType
//    func folder(_ name: String) -> FolderType
//    func folder(for url: URL) -> FolderType
//    func file(for url: URL) -> FileType
//    func forEach(inParallelWith parallel: Self?, order: Order, filter: Filter, recursive: Bool, do block: (ItemType, Self?) -> Void) throws
}
public protocol LocationsManager where FileType: NuItem, FolderType: NuItemContainer, ReferenceType: LocationRef, ReferenceType.Manager == Self, FileType.Manager == Self, FolderType.Manager == Self {
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

public extension LocationsManager {
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

struct ThrowingRef: LocationRef {
    typealias Manager = ThrowingLocations

    let url: URL
    let manager: ThrowingLocations
    init(for url: URL, manager: Manager) {
        self.url = url
        self.manager = manager
    }
}

struct ThrowingLocations: LocationsManager {
    let manager: FileManager
    typealias FileType = NuFile
    typealias FolderType = NuFolder
    typealias ReferenceType = ThrowingRef
}

struct NuFile: NuItem {
    typealias Manager = ThrowingLocations
    let ref: ThrowingRef
}

struct NuFolder: NuItemContainer {
    typealias Manager = ThrowingLocations
    let ref: ThrowingRef
}
