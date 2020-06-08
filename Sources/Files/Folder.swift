// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public struct FolderManager {
    let manager: FileManager
    
    public static var shared = FolderManager(manager: FileManager.default)

    public var desktop: Folder {
        let url = manager.desktopDirectory()
        return Folder(ref: Ref(url: url, manager: self))
    }

    public func ref(for url: URL) -> Ref {
        Ref(url: url, manager: self)
    }
    
    public func file(for url: URL) -> File {
        File(ref: ref(for: url))
    }

    public func folder(for url: URL) -> Folder {
        Folder(ref: ref(for: url))
    }
}

public struct Ref {
    let manager: FolderManager
    let url: URL
    
    init(url: URL, manager: FolderManager = FolderManager.shared) {
        self.url = url
        self.manager = manager
    }
    
}

public protocol FolderItem {
    var ref: Ref { get }
    var isFile: Bool { get }
}

public struct Folder: FolderItem {
    public enum Order {
        case filesFirst
        case foldersFirst
    }
    
    public let ref: Ref
    public var isFile: Bool { false }
    
    public func forEach(order: Order = .filesFirst, do block: (FolderItem) -> Void) {
        var files: [File] = []
        var folders: [Folder] = []
        do {
            let manager = ref.manager
            let contents = try manager.manager.contentsOfDirectory(at: ref.url, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [])
            for item in contents {
                let values = try item.resourceValues(forKeys: [.isDirectoryKey])
                if values.isDirectory ?? false {
                    folders.append(manager.folder(for: item))
                } else {
                    files.append(manager.file(for: item))
                }
            }
        } catch {
            
        }

        switch order {
        case .filesFirst:
            files.forEach(block)
            folders.forEach(block)
            
        case .foldersFirst:
            folders.forEach(block)
            files.forEach(block)
        }
    }
}

public struct File: FolderItem {
    public let ref: Ref
    public var isFile: Bool { true }
}

