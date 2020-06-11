// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol ItemCommon {
    var isFile: Bool { get }
    var isHidden: Bool { get }
}

public protocol Item: ItemCommon where Manager: FolderManager {
    associatedtype Manager
    typealias ItemType = Self
    var ref: Manager.ReferenceType { get }
    init(ref: Manager.ReferenceType)
    var url: URL { get }
    var path: String { get }
    var exists: Bool { get }
}

public extension Item {
    var url: URL { ref.url }
    var path: String { ref.url.path }

    var isHidden: Bool {
        let values = try? ref.url.resourceValues(forKeys: [.isHiddenKey])
        return values?.isHidden ?? false
    }
    
    
    var name: ItemName {
        let ext = ref.url.pathExtension
        return ItemName(ref.url.deletingPathExtension().lastPathComponent, pathExtension: ext.isEmpty ? nil : ext)
    }
    
    var exists: Bool {
        return ref.manager.manager.fileExists(atURL: ref.url)
    }
    
    func sameType(with url: URL) -> Self {
        return Self(ref: ref.manager.ref(for: url))
    }
}

