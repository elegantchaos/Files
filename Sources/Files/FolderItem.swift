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
    func copy(to: Folder, as: ItemName?)
    func delete()
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

    func copy(to folder: Folder, as newName: ItemName? = nil) {
        let source = ref.url
        var dest = folder.ref.url
        if let name = newName {
            dest = dest.appending(name)
        } else {
            dest = dest.appendingPathComponent(source.lastPathComponent)
        }
        
        do {
            print("copy \(source) to \(dest)")
            var isDir: ObjCBool = false
            if ref.manager.manager.fileExists(atPath: source.path, isDirectory: &isDir), isDir.boolValue {
                print("oops")
            }
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
