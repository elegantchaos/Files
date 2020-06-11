////
////  File 2.swift
////
////
////  Created by Sam Deane on 11/06/2020.
////
//
//import Foundation
//
//public class OldFolderManager {
//    public struct Ref {
//        let manager: OldFolderManager
//        let url: URL
//
//        init(url: URL, manager: OldFolderManager = OldFolderManager.shared) {
//            self.url = url
//            self.manager = manager
//        }
//    }
//
//    public typealias LogHandler = (String) -> Void
//    public typealias ErrorHandler = (Error) -> Void
//
//    let manager: FileManager
//    var logHandler: LogHandler
//    var errorHandler: ErrorHandler
//
//    public static var shared = OldFolderManager(manager: FileManager.default)
//
//    public var desktop: OldFolder { return OldFolder(ref: Ref(url: manager.desktopDirectory(), manager: self)) }
//    public var current: OldFolder { return OldFolder(ref: Ref(url: manager.workingDirectory(), manager: self)) }
//    public var home: OldFolder { return OldFolder(ref: Ref(url: manager.homeDirectory(), manager: self)) }
//    public var temporary: OldFolder { return OldFolder(ref: Ref(url: manager.temporaryDirectory(), manager: self)) }
//
//    init(manager: FileManager = FileManager.default, fileManager: FileManager = .default, logHandler: LogHandler? = nil, errorHandler: ErrorHandler? = nil) {
//        self.manager = manager
//        self.logHandler = logHandler ?? { string in print(string) }
//        self.errorHandler = errorHandler ?? { error in print(error) }
//    }
//
//    public func ref(for url: URL) -> Ref {
//        Ref(url: url, manager: self)
//    }
//    
//    public func file(for url: URL) -> OldFile {
//        OldFile(ref: ref(for: url))
//    }
//
//    public func folder(for url: URL) -> OldFolder {
//        OldFolder(ref: ref(for: url))
//    }
//
//    public func folder(for path: String) -> OldFolder {
//        folder(for: URL(fileURLWithPath: path))
//    }
//
//    func log(_ string: String) {
//        logHandler(string)
//    }
//
//    func log(_ error: Error) {
//        errorHandler(error)
//    }
//}
//
//public protocol OldItem {
//    var ref: OldFolderManager.Ref { get }
//    var path: String { get }
//    var isFile: Bool { get }
//    var isHidden: Bool { get }
//    var exists: Bool { get }
//    var name: ItemName { get }
//    func sameType(with url: URL) -> Self
//}
//
//public extension OldItem {
//    var isHidden: Bool {
//        let values = try? ref.url.resourceValues(forKeys: [.isHiddenKey])
//        return values?.isHidden ?? false
//    }
//
//    var path: String {
//        ref.url.path
//    }
//
//    var url: URL {
//        ref.url
//    }
//
//    var name: ItemName {
//        let ext = ref.url.pathExtension
//        return ItemName(ref.url.deletingPathExtension().lastPathComponent, pathExtension: ext.isEmpty ? nil : ext)
//    }
//
//    var exists: Bool {
//        return ref.manager.manager.fileExists(atURL: ref.url)
//    }
//}
//
//public protocol OldItemContainer: OldItem {
//    associatedtype FileType
//    associatedtype FolderType
//
//    var ref: OldFolderManager.Ref { get }
//    var up: FolderType { get }
//    func file(_ name: ItemName) -> FileType
//    func folder(_ name: ItemName) -> FolderType
//    func item(_ name: ItemName) -> OldItem?
//    func item(_ name: String) -> OldItem?
//    func file(_ name: String) -> FileType
//    func folder(_ name: String) -> FolderType
//    func folder(for url: URL) -> FolderType
//    func file(for url: URL) -> FileType
//    func forEach(inParallelWith parallel: Self?, order: Order, filter: Filter, recursive: Bool, do block: (OldItem, Self?) -> Void) throws
//}
//
//public extension OldItemContainer where FolderType: OldItemContainer, FileType: OldItem, FolderType == Self {
//    var up: FolderType {
//        return folder(for: ref.url.deletingLastPathComponent())
//    }
//
//    func file(_ name: ItemName) -> FileType {
//        return file(for: ref.url.appending(name))
//    }
//
//    func folder(_ name: ItemName) -> FolderType {
//        return folder(for: ref.url)
//    }
//
//    func item(_ name: ItemName) -> OldItem? {
//        let url = ref.url.appending(name)
//        var isDirectory: ObjCBool = false
//        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
//        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
//    }
//
//    func item(_ name: String) -> OldItem? {
//        item(ItemName(name))
//    }
//
//    func file(_ name: String) -> FileType {
//        file(ItemName(name))
//    }
//
//    func folder(_ name: String) -> FolderType {
//        folder(ItemName(name))
//    }
//
//    func folder(_ components: [String]) -> FolderType {
//        return folder(for: ref.url.appendingPathComponents(components))
//    }
//
//    func forEach(order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (OldItem) -> Void) throws {
//        try forEach(inParallelWith: nil, order: order, filter: filter, recursive: recursive) { item, _ in block(item) }
//    }
//
//    func forEach(inParallelWith parallel: Self?, order: Order = .filesFirst, filter: Filter = .none, recursive: Bool = true, do block: (OldItem, Self?) -> Void) throws {
//         var files: [FileType] = []
//         var folders: [FolderType] = []
//         let manager = ref.manager
//         let contents = try manager.manager.contentsOfDirectory(at: ref.url, includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey], options: [])
//         for item in contents {
//             let values = try item.resourceValues(forKeys: [.isDirectoryKey])
//             if values.isDirectory ?? false {
//                 let item = folder(for: item)
//                 folders.append(item)
//             } else {
//                 let item = file(for: item)
//                 if filter.passes(item) { files.append(item) }
//             }
//         }
//
//         func processFolders() throws {
//             if recursive {
//                 try folders.forEach { folder in
//                    let nested: Optional<FolderType>
//                    if let parallel = parallel {
//                        let nestedURL = parallel.ref.url.appendingPathComponent(ref.url.lastPathComponent)
//                        try? ref.manager.manager.createDirectory(at: nestedURL, withIntermediateDirectories: true, attributes: nil)
//                        nested = self.folder(for: nestedURL)
//                    } else {
//                        nested = nil
//                    }
//
//                    try folder.forEach(inParallelWith: nested, order: order, filter: filter, recursive: recursive, do: block)
//                 }
//             }
//
//             let filtered = folders.filter({ return filter.passes($0) })
//             filtered.forEach({ block($0, parallel) })
//         }
//
//         func processFiles() {
//             files.forEach({ block($0, parallel) })
//         }
//
//         switch order {
//         case .filesFirst:
//             processFiles()
//             try processFolders()
//
//         case .foldersFirst:
//             try processFolders()
//             processFiles()
//         }
//     }
//}
//
//public protocol OldThrowingItem: OldItem {
//    func delete() throws
//    @discardableResult func copy(to: OldFolder, as: ItemName?, replacing: Bool) throws -> Self
//    @discardableResult func rename(as: ItemName, replacing: Bool) throws -> Self
//}
//
//public extension OldThrowingItem {
//    @discardableResult func copy(to folder: OldFolder, as newName: ItemName?, replacing: Bool = false) throws -> Self {
//        let source = ref.url
//        var dest = folder.ref.url
//        if let name = newName {
//            dest = dest.appending(name)
//        } else {
//            dest = dest.appendingPathComponent(source.lastPathComponent)
//        }
//
//        if replacing {
//            try? ref.manager.manager.removeItem(at: dest)
//        }
//
//        try ref.manager.manager.copyItem(at: source, to: dest)
//
//        return sameType(with: dest)
//    }
//
//    func delete() throws {
//        try ref.manager.manager.removeItem(at: ref.url)
//    }
//
//    @discardableResult func rename(as newName: ItemName, replacing: Bool = false) throws -> Self {
//        let source = ref.url
//        let dest = ref.url.deletingLastPathComponent().appending(newName)
//        if replacing {
//            try? ref.manager.manager.removeItem(at: dest)
//        }
//
//        try ref.manager.manager.moveItem(at: source, to: dest)
//        return sameType(with: dest)
//    }
//
//    @discardableResult func copy(to folder: OldFolder, as newName: String? = nil, replacing: Bool = false) throws -> Self {
//        let name = newName == nil ? nil : ItemName(newName!)
//        return try copy(to: folder, as: name, replacing: replacing)
//    }
//
//    @discardableResult func rename(as newName: String, replacing: Bool = false) throws -> Self {
//        return try rename(as: ItemName(newName), replacing: replacing)
//    }
//}
//
//public protocol OldQuietItem: OldItem {
//    associatedtype T
//    init(wrapped: T)
//    var wrapped: T { get }
//}
//
//public extension OldQuietItem where T: OldThrowingItem {
//    var ref: OldFolderManager.Ref { wrapped.ref }
//    var isFile: Bool { wrapped.isFile }
//    func sameType(with url: URL) -> Self {
//        Self(wrapped: wrapped.sameType(with: url))
//    }
//
//    func rename(as name: ItemName, replacing: Bool = false) -> Self {
//        return attemptReturning() {
//            let renamed = try wrapped.rename(as: name, replacing: replacing)
//            return Self(wrapped: renamed)
//        } ?? self
//    }
//
//    func delete() {
//        attempt {
//            try wrapped.delete()
//        }
//    }
//
//    func attempt(_ action: () throws -> Void) {
//        do {
//            try action()
//        } catch {
//            wrapped.ref.manager.log(error)
//        }
//    }
//
//    func attemptReturning<T>(_ action: () throws -> T?) -> T? {
//        do {
//            return try action()
//        } catch {
//            wrapped.ref.manager.log(error)
//            return nil
//        }
//    }
//
//}
//
//public struct OldQuietFile: OldQuietItem {
//    public init(wrapped: OldFile) {
//        self.wrapped = wrapped
//    }
//
//    public var wrapped: OldFile
//    public typealias T = OldFile
//}
//
//public struct OldQuietFolder: OldQuietItem, OldItemContainer {
//    public func item(_ name: ItemName) -> OldItem? {
//        let item = wrapped.item(name)
//        if let file = item as? OldFile {
//            return OldQuietFile(wrapped: file)
//        } else if let folder = item as? OldFolder {
//            return OldQuietFolder(wrapped: folder)
//        } else {
//            fatalError("Unknown item type")
//        }
//    }
//
//    public func file(for url: URL) -> OldQuietFile {
//        OldQuietFile(wrapped: wrapped.file(for: url))
//    }
//
//    public func folder(for url: URL) -> OldQuietFolder {
//        OldQuietFolder(wrapped: wrapped.folder(for: url))
//    }
//
//    public typealias FileType = OldQuietFile
//    public typealias FolderType = OldQuietFolder
//
//    public init(wrapped: OldFolder) {
//        self.wrapped = wrapped
//    }
//
//    public var wrapped: OldFolder
//    public typealias T = OldFolder
//
//    func create() {
//        do {
//            try wrapped.create()
//        } catch {
//            wrapped.ref.manager.errorHandler(error)
//        }
//    }
//
//}
//
//public struct OldFile: OldThrowingItem {
//    public let ref: OldFolderManager.Ref
//    public var isFile: Bool { true }
//
//    public var asText: String? { try? String(contentsOf: ref.url, encoding: .utf8) }
//    public func write(as text: String) { try? text.write(to: ref.url, atomically: true, encoding: .utf8) }
//
//    public func sameType(with url: URL) -> OldFile {
//        return ref.manager.file(for: url)
//    }
//
//    public var quiet: OldQuietFile { OldQuietFile(wrapped: self) }
//}
//
//public struct OldFolder: OldThrowingItem {
//    public let ref: OldFolderManager.Ref
//    public var isFile: Bool { false }
//    
//    public var quiet: OldQuietFolder { OldQuietFolder(wrapped: self) }
//
//    public func create() throws {
//        try ref.manager.manager.createDirectory(at: ref.url, withIntermediateDirectories: true, attributes: nil)
//    }
//
//    public func sameType(with url: URL) -> OldFolder {
//        return ref.manager.folder(for: url)
//    }
//}
//
//extension OldFolder: OldItemContainer {
//    public typealias FileType = OldFile
//    public typealias FolderType = OldFolder
//    
//    public func file(for url: URL) -> OldFile {
//        return ref.manager.file(for: url)
//    }
//
//    public func folder(for url: URL) -> OldFolder {
//        return ref.manager.folder(for: url)
//    }
//
//    public func item(_ name: ItemName) -> OldItem? {
//        let url = ref.url.appending(name)
//        var isDirectory: ObjCBool = false
//        guard ref.manager.manager.fileExists(atPath: url.path, isDirectory: &isDirectory) else { return nil }
//        return isDirectory.boolValue ? ref.manager.folder(for: url) : ref.manager.file(for: url)
//    }
//}
//
//extension OldFolder: CustomStringConvertible {
//    public var description: String { "📁: \"\(name.fullName)\" (\(ref.url.path))" }
//}
