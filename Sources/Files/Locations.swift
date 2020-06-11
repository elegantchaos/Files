// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

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


protocol ThrowingNuContainer: NuItemContainer, ThrowingNuItem {
    func create() throws
    @discardableResult func copy(to folder: Folder, as newName: ItemName?, replacing: Bool) throws -> Self
}

struct NuFolder: ThrowingNuContainer {
    typealias Manager = ThrowingLocations
    let ref: ThrowingRef
    var isFile: Bool { false }

    public func create() throws {
        try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
    }
    
    @discardableResult func copy(to folder: Folder, as newName: ItemName?, replacing: Bool = false) throws -> Self {
        let source = ref.url
        var dest = folder.ref.url
        if let name = newName {
            dest = dest.appending(name)
        } else {
            dest = dest.appendingPathComponent(source.lastPathComponent)
        }

        if replacing {
            try? ref.manager.manager.removeItem(at: dest)
        }

        try ref.manager.manager.copyItem(at: source, to: dest)

        return sameType(with: dest)
    }

    @discardableResult func copy(to folder: Folder, as newName: String? = nil, replacing: Bool = false) throws -> Self {
        let name = newName == nil ? nil : ItemName(newName!)
        return try copy(to: folder, as: name, replacing: replacing)
    }
    
    @discardableResult func rename(as newName: String, replacing: Bool = false) throws -> Self {
        return try rename(as: ItemName(newName), replacing: replacing)
    }
    
    @discardableResult func rename(as newName: ItemName, replacing: Bool = false) throws -> Self {
        let source = ref.url
        let dest = ref.url.deletingLastPathComponent().appending(newName)
        if replacing {
            try? ref.manager.manager.removeItem(at: dest)
        }
        
        try ref.manager.manager.moveItem(at: source, to: dest)
        return sameType(with: dest)
    }
}

extension FileManager {
    var locations: ThrowingLocations { ThrowingLocations(manager: self) }
}
