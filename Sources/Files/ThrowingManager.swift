// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct ThrowingRef: LocationRef {
    typealias Manager = ThrowingManager

    let url: URL
    let manager: ThrowingManager
    init(for url: URL, manager: Manager) {
        self.url = url
        self.manager = manager
    }
}

struct ThrowingManager: FolderManager {
    let manager: FileManager
    typealias FileType = File
    typealias FolderType = Folder
    typealias ReferenceType = ThrowingRef
}

extension FileManager {
    var locations: ThrowingManager { ThrowingManager(manager: self) }
}
