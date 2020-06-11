// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct QuietRef: LocationRef {
    typealias Manager = QuietLocations

    let url: URL
    let manager: QuietLocations
    init(for url: URL, manager: Manager) {
        self.url = url
        self.manager = manager
    }
}

struct QuietLocations: LocationsManager {
    let manager: FileManager
    typealias FileType = NuQuietFile
    typealias FolderType = NuQuietFolder
    typealias ReferenceType = QuietRef

    func log(_ string: String) {

    }

    func log(_ error: Error) {

    }

    func attempt(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            log(error)
        }
    }

    func attemptReturning<T>(_ action: () throws -> T?) -> T? {
        do {
            return try action()
        } catch {
            log(error)
            return nil
        }
    }
}

protocol NuQuietItem: NuItem {
}

extension NuQuietItem where Manager == QuietLocations {
    func rename(as newName: ItemName, replacing: Bool = false) -> Self {
        do {
            let source = ref.url
            let dest = ref.url.deletingLastPathComponent().appending(newName)
            if replacing {
                try? ref.manager.manager.removeItem(at: dest)
            }

            try ref.manager.manager.moveItem(at: source, to: dest)
            return sameType(with: dest)
        } catch {
            ref.manager.log(error)
            return self
        }
    }
    
    func delete() {
        ref.manager.attempt {
            try ref.manager.manager.removeItem(at: ref.url)
        }
    }
}

struct NuQuietFile: NuQuietItem {
    let ref: QuietRef
    var isFile: Bool { true }
    typealias Manager = QuietLocations
}

protocol NuQuietContainer: NuItemContainer, NuQuietItem {
    func create()
}

struct NuQuietFolder: NuQuietContainer {
    let ref: QuietRef
    var isFile: Bool { false }
    typealias Manager = QuietLocations

    func create() {
        ref.manager.attempt {
            try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
        }
    }

}

extension FileManager {
    var quiet: QuietLocations { QuietLocations(manager: self) }
}
