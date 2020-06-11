// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol QuietItem: Item {
    associatedtype T
    init(wrapped: T)
    var wrapped: T { get }
}

public extension QuietItem where T: ThrowingItem {
    var ref: FolderManager.Ref { wrapped.ref }
    var isFile: Bool { wrapped.isFile }
    func sameType(with url: URL) -> Self {
        Self(wrapped: wrapped.sameType(with: url))
    }
 
    func rename(as name: ItemName, replacing: Bool = false) -> Self {
        return attemptReturning() {
            let renamed = try wrapped.rename(as: name, replacing: replacing)
            return Self(wrapped: renamed)
        } ?? self
    }
    
    func delete() {
        attempt {
            try wrapped.delete()
        }
    }

    func attempt(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            wrapped.ref.manager.log(error)
        }
    }

    func attemptReturning<T>(_ action: () throws -> T?) -> T? {
        do {
            return try action()
        } catch {
            wrapped.ref.manager.log(error)
            return nil
        }
    }

}

public struct QuietFile: QuietItem {
    public init(wrapped: File) {
        self.wrapped = wrapped
    }
    
    public var wrapped: File
    public typealias T = File
}

public struct QuietFolder: QuietItem, ItemContainer {
    public func item(_ name: ItemName) -> Item? {
        let item = wrapped.item(name)
        if let file = item as? File {
            return QuietFile(wrapped: file)
        } else if let folder = item as? Folder {
            return QuietFolder(wrapped: folder)
        } else {
            fatalError("Unknown item type")
        }
    }
    
    public func file(for url: URL) -> QuietFile {
        QuietFile(wrapped: wrapped.file(for: url))
    }
    
    public func folder(for url: URL) -> QuietFolder {
        QuietFolder(wrapped: wrapped.folder(for: url))
    }
    
    public typealias FileType = QuietFile
    public typealias FolderType = QuietFolder
    
    public init(wrapped: Folder) {
        self.wrapped = wrapped
    }
    
    public var wrapped: Folder
    public typealias T = Folder
    
    func create() {
        do {
            try wrapped.create()
        } catch {
            wrapped.ref.manager.errorHandler(error)
        }
    }

}
