// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct ItemName {
    public let name: String
    public let pathExtension: String?
    
    public func renamed(as newName: String) -> ItemName {
        ItemName(name: newName, pathExtension: pathExtension)
    }
}

extension ItemName: Equatable {
}

extension ItemName: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        let items = value.split(separator: ".")
        if items.count > 1, let ext = items.last {
            pathExtension = String(ext)
//            name = value.substring(to: value.index(value.endIndex, offsetBy: -ext.count)
            name = String(value[..<value.index(value.endIndex, offsetBy: -ext.count)])
        } else {
            pathExtension = nil
            name = value
        }
    }
}
public protocol FolderItem {
    var ref: FolderManager.Ref { get }
    var path: String { get }
    var isFile: Bool { get }
    var isHidden: Bool { get }
    var name: ItemName { get }
    func copy(to: Folder, as: ItemName?, replacing: Bool)
    func delete()
    func rename(as: ItemName)
}

public extension FolderItem {
    var isHidden: Bool {
        let values = try? ref.url.resourceValues(forKeys: [.isHiddenKey])
        return values?.isHidden ?? false
    }
    
    var path: String {
        ref.url.path
    }
    
    var name: ItemName {
        ItemName(name: ref.url.deletingPathExtension().lastPathComponent, pathExtension: ref.url.pathExtension)
    }

    func copy(to folder: Folder, as newName: ItemName? = nil, replacing: Bool = false) {
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

        do {
            try ref.manager.manager.copyItem(at: source, to: dest)
        } catch {
            print(error)
        }
    }
    
    func delete() {
        do {
            try ref.manager.manager.removeItem(at: ref.url)
        } catch {
            print(error)
        }
    }
    
    func rename(as newName: ItemName) {
        let source = ref.url
        let dest = ref.url.deletingLastPathComponent().appending(newName)
        do {
            try ref.manager.manager.moveItem(at: source, to: dest)
        } catch {
            print(error)
        }
    }
}

public extension URL {
    func appending(_ name: ItemName) -> URL {
        var result = self.appendingPathComponent(name.name)
        if let ext = name.pathExtension {
            result = result.appendingPathExtension(ext)
        }
        return result
    }
}
