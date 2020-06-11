// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct NonThrowingReference: LocationRef {
    typealias Manager = NonThrowingManager

    let url: URL
    let manager: NonThrowingManager
    
    init(for url: URL, manager: Manager) {
        self.url = url
        self.manager = manager
    }
}

struct NonThrowingManager: FolderManager {
    typealias FileType = NonThrowingFile
    typealias FolderType = NonThrowingFolder
    typealias ReferenceType = NonThrowingReference
    typealias ItemType = NonThrowingCommon
    
    public typealias LogHandler = (String) -> Void
    public typealias ErrorHandler = (Error) -> Void
    
    let manager: FileManager
    let logHandler: LogHandler
    let errorHandler: ErrorHandler

    init(manager: FileManager = FileManager.default, logHandler: LogHandler? = nil, errorHandler: ErrorHandler? = nil) {
        self.manager = manager
        self.logHandler = logHandler ?? { print($0) }
        self.errorHandler = errorHandler ?? { print($0) }
    }
    
    func log(_ string: String) {
        logHandler(string)
    }

    func log(_ error: Error) {
        errorHandler(error)
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


extension FileManager {
    var quiet: NonThrowingManager { NonThrowingManager(manager: self) }
}
