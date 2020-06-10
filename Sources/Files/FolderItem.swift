// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public protocol FolderItem {
    var ref: FolderManager.Ref { get }
    var path: String { get }
    var isFile: Bool { get }
    var isHidden: Bool { get }
    var name: ItemName { get }
    func copy(to: Folder, as: ItemName?, replacing: Bool)
    func delete()
    func rename(as: ItemName, replacing: Bool)
}

public extension FolderItem {
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

    func copy(to folder: Folder, as newName: ItemName? = nil, replacing: Bool = false) {
        _ = rawCopy(to: folder, as: newName, replacing: replacing)
    }
    
    internal func rawCopy(to folder: Folder, as newName: ItemName? = nil, replacing: Bool = false) -> URL {
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

        return dest
    }
    
    func delete() {
        do {
            try ref.manager.manager.removeItem(at: ref.url)
        } catch {
            print(error)
        }
    }
    
    func rename(as newName: ItemName, replacing: Bool = false) {
        let source = ref.url
        let dest = ref.url.deletingLastPathComponent().appending(newName)
        do {
            if replacing {
                try? ref.manager.manager.removeItem(at: dest)
            }
            
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
