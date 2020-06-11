// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct Folder: ItemContainer, ThrowingItem {
    public typealias Manager = ThrowingManager
    public let ref: ThrowingRef
    public var isFile: Bool { false }

    public init(ref: ThrowingRef) {
        self.ref = ref
    }
    
    public func create() throws {
        try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
    }
    
    @discardableResult public func copy(to folder: Folder, as newName: ItemName?, replacing: Bool = false) throws -> Self {
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

    @discardableResult public func copy(to folder: Folder, as newName: String? = nil, replacing: Bool = false) throws -> Self {
        let name = newName == nil ? nil : ItemName(newName!)
        return try copy(to: folder, as: name, replacing: replacing)
    }
    
    @discardableResult public func rename(as newName: String, replacing: Bool = false) throws -> Self {
        return try rename(as: ItemName(newName), replacing: replacing)
    }
    
    @discardableResult public func rename(as newName: ItemName, replacing: Bool = false) throws -> Self {
        let source = ref.url
        let dest = ref.url.deletingLastPathComponent().appending(newName)
        if replacing {
            try? ref.manager.manager.removeItem(at: dest)
        }
        
        try ref.manager.manager.moveItem(at: source, to: dest)
        return sameType(with: dest)
    }
    
    func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (ThrowingCommon) throws -> Void) throws {
        try forEach(inParallelWith: nil, order: order, filter: filter, recursive: recursive) {
            item, _ in try block(item)
        }
    }
    
    func forEach(inParallelWith parallel: FolderType?, order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (ThrowingCommon, FolderType?) throws -> Void) throws {
        try _forEach(inParallelWith: parallel, order: order, filter: filter, recursive: recursive) {
            item, _ in try block(item as! ThrowingCommon, parallel)
        }
    }
    

}
