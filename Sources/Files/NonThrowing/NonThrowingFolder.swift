// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct NonThrowingFolder: ItemContainer, NonThrowingItem {
    let ref: NonThrowingReference
    var isFile: Bool { false }
    typealias Manager = NonThrowingManager

    func create() {
        ref.manager.attempt {
            try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
        }
    }
//    
//    func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (NonThrowingCommon) throws -> Void) throws {
//        try _forEach(inParallelWith: nil, order: order, filter: filter, recursive: recursive) {
//            item, _ in try block(item as! NonThrowingCommon)
//        }
//    }
//    
//    func forEach(inParallelWith parallel: FolderType?, order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (NonThrowingCommon, FolderType?) throws -> Void) throws {
//        try _forEach(inParallelWith: parallel, order: order, filter: filter, recursive: recursive) {
//            item, _ in try block(item as! NonThrowingCommon, parallel)
//        }
//    }
}
