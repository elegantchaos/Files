// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol Item {
    var ref: FolderManager.Ref { get }
    var path: String { get }
    var isFile: Bool { get }
    var isHidden: Bool { get }
    var exists: Bool { get }
    var name: ItemName { get }
    func delete()
    @discardableResult func copy(to: Folder, as: ItemName?, replacing: Bool) -> Self
    @discardableResult func rename(as: ItemName, replacing: Bool) -> Self
    func sameType(with url: URL) -> Self
}

public extension Item {
    var isHidden: Bool {
        let values = try? ref.url.resourceValues(forKeys: [.isHiddenKey])
        return values?.isHidden ?? false
    }
    
    var path: String {
        ref.url.path
    }
    
    var url: URL {
        ref.url
    }
    
    var name: ItemName {
        let ext = ref.url.pathExtension
        return ItemName(ref.url.deletingPathExtension().lastPathComponent, pathExtension: ext.isEmpty ? nil : ext)
    }
    
    var exists: Bool {
        return ref.manager.manager.fileExists(atURL: ref.url)
    }
    
    @discardableResult func copy(to folder: Folder, as newName: ItemName?, replacing: Bool = false) -> Self {
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

        return sameType(with: dest)
    }
    
    func delete() {
        do {
            try ref.manager.manager.removeItem(at: ref.url)
        } catch {
            print(error)
        }
    }
    
    @discardableResult func rename(as newName: ItemName, replacing: Bool = false) -> Self {
        let source = ref.url
        let dest = ref.url.deletingLastPathComponent().appending(newName)
        do {
            if replacing {
                try? ref.manager.manager.removeItem(at: dest)
            }
            
            try ref.manager.manager.moveItem(at: source, to: dest)
            return sameType(with: dest)
        } catch {
            print(error)
            return self
        }
    }

    @discardableResult func copy(to folder: Folder, as newName: String? = nil, replacing: Bool = false) -> Self {
        let name = newName == nil ? nil : ItemName(newName!)
        return copy(to: folder, as: name, replacing: replacing)
    }
    
    @discardableResult func rename(as newName: String, replacing: Bool = false) -> Self {
        return rename(as: ItemName(newName), replacing: replacing)
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
