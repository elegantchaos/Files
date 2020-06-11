// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 08/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

public class FolderManager {
    public struct Ref {
        let manager: FolderManager
        let url: URL
        
        init(url: URL, manager: FolderManager = FolderManager.shared) {
            self.url = url
            self.manager = manager
        }
    }

    public typealias LogHandler = (String) -> Void
    public typealias ErrorHandler = (Error) -> Void
    
    let manager: FileManager
    var logHandler: LogHandler
    var errorHandler: ErrorHandler
    
    public static var shared = FolderManager(manager: FileManager.default)

    public var desktop: Folder { return Folder(ref: Ref(url: manager.desktopDirectory(), manager: self)) }
    public var current: Folder { return Folder(ref: Ref(url: manager.workingDirectory(), manager: self)) }
    public var home: Folder { return Folder(ref: Ref(url: manager.homeDirectory(), manager: self)) }
    public var temporary: Folder { return Folder(ref: Ref(url: manager.temporaryDirectory(), manager: self)) }
    
    init(manager: FileManager = FileManager.default, fileManager: FileManager = .default, logHandler: LogHandler? = nil, errorHandler: ErrorHandler? = nil) {
        self.manager = manager
        self.logHandler = logHandler ?? { string in print(string) }
        self.errorHandler = errorHandler ?? { error in print(error) }
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
    
    public func folder(for path: String) -> Folder {
        folder(for: URL(fileURLWithPath: path))
    }

    func log(_ string: String) {
        logHandler(string)
    }
    
    func log(_ error: Error) {
        errorHandler(error)
    }
}
