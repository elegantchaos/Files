// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ThrowingFolder: ItemContainer, ThrowingItem {
    public typealias Manager = ThrowingManager
    public let ref: ThrowingReference
    public var isFile: Bool { false }

    public init(ref: ThrowingReference) {
        self.ref = ref
    }
    
    public func create() throws {
        try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
    }
    
//    func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (ThrowingCommon) throws -> Void) throws {
//        try forEach(inParallelWith: nil, order: order, filter: filter, recursive: recursive) {
//            item, _ in try block(item)
//        }
//    }
//    
//    func forEach(inParallelWith parallel: FolderType?, order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (ThrowingCommon, FolderType?) throws -> Void) throws {
//        try _forEach(inParallelWith: parallel, order: order, filter: filter, recursive: recursive) {
//            item, _ in try block(item as! ThrowingCommon, parallel)
//        }
//    }


}
