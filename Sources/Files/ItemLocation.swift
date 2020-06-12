// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 12/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol ItemLocation where Manager: FolderManager {
    associatedtype Manager
    var url: URL { get }
    var manager: Manager { get }
    init(for url: URL, manager: Manager)
}

public extension ItemLocation {
    @discardableResult func copy(to folder: Self, as newName: ItemName?, replacing: Bool) throws -> Self {
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

    func rename(as newName: ItemName, replacing: Bool) throws -> Self {
        let dest = url.deletingLastPathComponent().appending(newName)
        if replacing {
            try? manager.manager.removeItem(at: dest)
        }

        try manager.manager.moveItem(at: url, to: dest)
        return Self(for: dest, manager: manager)
    }

    func createFolder() throws {
        if !manager.manager.fileExists(atURL: url) {
            try manager.manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
