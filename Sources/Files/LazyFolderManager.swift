// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol LazyItem: ItemBase {
    associatedtype T
    init(wrapped: T)
    var wrapped: T { get }
}

public extension LazyItem where T: Item {
    var ref: FolderManager.Ref { wrapped.ref }
    var isFile: Bool { wrapped.isFile }
    func sameType(with url: URL) -> Self {
        Self(wrapped: wrapped.sameType(with: url))
    }
 
    func rename(as name: ItemName, replacing: Bool = false) -> Self {
        do {
            let renamed = try wrapped.rename(as: name, replacing: replacing)
            return Self(wrapped: renamed)
        } catch {
            wrapped.ref.manager.errorHandler(error)
            return self
        }
    }
    
    func delete() {
        do {
            try wrapped.delete()
        } catch {
            wrapped.ref.manager.errorHandler(error)
        }
    }
}

public struct LazyFile: LazyItem {
    public init(wrapped: File) {
        self.wrapped = wrapped
    }
    
    public var wrapped: File
    public typealias T = File
}

public struct LazyFolder: LazyItem {
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
