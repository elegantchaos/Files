// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import Files

final class FolderManagerTests: XCTestCase {
    func makeTestStructure() -> URL {
        let f1 = temporaryFile(named: "root")
        try? FileManager.default.createDirectory(at: f1, withIntermediateDirectories: true, attributes: nil)
        let f2 = f1.appendingPathComponent("folder2")
        let f3 = f1.appendingPathComponent("folder3")
        try? FileManager.default.createDirectory(at: f2, withIntermediateDirectories: true, attributes: nil)
        try? FileManager.default.createDirectory(at: f3, withIntermediateDirectories: true, attributes: nil)
        return f1
    }
    
    func makeTestFile() -> URL {
        let url = temporaryFile(named: "test", extension: "txt")
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try! "test".write(to: url, atomically: true, encoding: .utf8)
        return url
    }
    
    func testFolder() {
        let fm = FileManager.default.locations
        let h = fm.home
        
        XCTAssertEqual(h.url, URL(fileURLExpandingPath: "~/"))
        XCTAssertTrue(h.exists)
        XCTAssertFalse(h.isFile)
        XCTAssertFalse(h.isHidden)
        
        let url = temporaryFile()
        let folder = fm.folder(for: url)
        try! folder.create()
        XCTAssertTrue(FileManager.default.fileExists(atURL: url))
        
        let url2 = url.deletingLastPathComponent().appendingPathComponent("Test2")
        let renamed = try! folder.rename(as: "Test2")
        XCTAssertFalse(FileManager.default.fileExists(atURL: url))
        XCTAssertFalse(folder.exists)
        
        XCTAssertTrue(FileManager.default.fileExists(atURL: url2))
        XCTAssertTrue(renamed.exists)
        try! renamed.delete()
        
        XCTAssertFalse(FileManager.default.fileExists(atURL: url2))
        
    }
    
    func testNoThrowFolder() {
        let fm = FileManager.default.nothrow
        let h = fm.home
        
        XCTAssertEqual(h.url, URL(fileURLExpandingPath: "~/"))
        XCTAssertTrue(h.exists)
        XCTAssertFalse(h.isFile)
        XCTAssertFalse(h.isHidden)
        
        let url = temporaryFile()
        let folder = fm.folder(for: url)
        folder.create()
        XCTAssertTrue(FileManager.default.fileExists(atURL: url))
        
        let url2 = url.deletingLastPathComponent().appendingPathComponent("Test2")
        let renamed = folder.rename(as: "Test2")
        XCTAssertNotNil(renamed)
        XCTAssertFalse(FileManager.default.fileExists(atURL: url))
        XCTAssertFalse(folder.exists)
        
        XCTAssertTrue(FileManager.default.fileExists(atURL: url2))
        XCTAssertTrue(renamed!.exists)
        renamed!.delete()
        
        XCTAssertFalse(FileManager.default.fileExists(atURL: url2))
        
    }
    
    func testFile() {
        let fm = FileManager.default.locations
        
        let url = temporaryFile(named: "test", extension: "txt")
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try! "test".write(to: url, atomically: true, encoding: .utf8)
        let file = fm.file(for: url)
        XCTAssertTrue(file.exists)
        XCTAssertTrue(file.isFile)
        XCTAssertFalse(file.isHidden)
        
        let url2 = url.deletingLastPathComponent().appendingPathComponent("Test2")
        let renamed = try! file.rename(as: "Test2")
        XCTAssertFalse(FileManager.default.fileExists(atURL: url))
        XCTAssertFalse(file.exists)
        
        XCTAssertTrue(FileManager.default.fileExists(atURL: url2))
        XCTAssertTrue(renamed.exists)
        try! renamed.delete()
        
        XCTAssertFalse(FileManager.default.fileExists(atURL: url2))
    }
    
    func testNoThrowFile() {
        let fm = FileManager.default.nothrow
        
        let url = temporaryFile(named: "test", extension: "txt")
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try! "test".write(to: url, atomically: true, encoding: .utf8)
        let file = fm.file(for: url)
        XCTAssertTrue(file.exists)
        XCTAssertTrue(file.isFile)
        XCTAssertFalse(file.isHidden)
        
        let url2 = url.deletingLastPathComponent().appendingPathComponent("Test2")
        let renamed = file.rename(as: "Test2")
        XCTAssertNotNil(renamed)
        XCTAssertFalse(FileManager.default.fileExists(atURL: url))
        XCTAssertFalse(file.exists)
        
        XCTAssertTrue(FileManager.default.fileExists(atURL: url2))
        XCTAssertTrue(renamed!.exists)
        renamed!.delete()
        
        XCTAssertFalse(FileManager.default.fileExists(atURL: url2))
    }
    
    func testHidden() {
        let url = temporaryFile(named: ".test")
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try! "test".write(to: url, atomically: true, encoding: .utf8)
        let file = FileManager.default.locations.file(for: url)
        XCTAssertTrue(file.isHidden)
    }
    
    func testCopy() {
        let url = makeTestFile()
        let temp = FileManager.default.locations.file(for: url)
        let container = temp.up
        XCTAssertTrue(temp.exists)
        XCTAssertTrue(temp.isFile)
        XCTAssertTrue(container.exists)
        let copied = try! temp.copy(to: container, as: "another")
        XCTAssertTrue(copied.exists)
        XCTAssertTrue(copied.url != temp.url)
        XCTAssertTrue(copied.url.deletingLastPathComponent() == temp.url.deletingLastPathComponent())
    }

    func testNoThrowCopy() {
        let url = makeTestFile()
        let temp = FileManager.default.nothrow.file(for: url)
        let container = temp.up
        XCTAssertTrue(temp.exists)
        XCTAssertTrue(temp.isFile)
        XCTAssertTrue(container.exists)
        let copied = temp.copy(to: container, as: "another")
        XCTAssertNotNil(copied)
        XCTAssertTrue(copied!.exists)
        XCTAssertTrue(copied!.url != temp.url)
        XCTAssertTrue(copied!.url.deletingLastPathComponent() == temp.url.deletingLastPathComponent())
    }

    func testFailure() {
        XCTAssertThrowsError(try FileManager.default.locations.temporary.file("non-existent").rename(as: "test"))
    }
    
    func testNoThrowFailure() {
        var receivedError: NSError? = nil
        let fm = NonThrowingManager(errorHandler: { error in receivedError = error as NSError })
        _ = fm.temporary.file("non-existent").rename(as: "test")
        XCTAssertEqual(receivedError?.code, 4)
        XCTAssertEqual(receivedError?.domain, "NSCocoaErrorDomain")
    }
    
    
    func testForEach() {
        let root = makeTestStructure()
        let folder = FileManager.default.locations.folder(for: root)
        var names = ["folder2", "folder3"]
        try! folder.forEach() { item in
            XCTAssertTrue(item is ThrowingFolder)
            let index = names.firstIndex(of: item.name.name)
            XCTAssertNotNil(index)
            names.remove(at: index!)
            let renamed = try item.rename(as: "blah", replacing: false)
            try renamed.delete()
        }
        XCTAssertEqual(names.count, 0)
    }

    func testForEachWibble() {
        let root = makeTestStructure()
        let folder = FileManager.default.locations.folder(for: root)
        var names = ["folder2", "folder3"]
        try! folder.forEach(inParallelWith: nil) { item, folder in
            XCTAssertTrue(item is ThrowingFolder)
            let index = names.firstIndex(of: item.name.name)
            XCTAssertNotNil(index)
            names.remove(at: index!)
            let renamed = try item.rename(as: "blah", replacing: false)
            try renamed.delete()
        }
        XCTAssertEqual(names.count, 0)
    }

    func testNoThrowForEach() {
        let root = makeTestStructure()
        let folder = FileManager.default.nothrow.folder(for: root)
        var names = ["folder2", "folder3"]
        try! folder.forEach() { item in
            XCTAssertTrue(item is NonThrowingFolder)
            let index = names.firstIndex(of: item.name.name)
            XCTAssertNotNil(index)
            names.remove(at: index!)
            let renamed = item.rename(as: "blah", replacing: false)
            XCTAssertNotNil(renamed)
            renamed!.delete()
        }
        XCTAssertEqual(names.count, 0)
    }
    
    func testTypePropogation() {
        let root = makeTestStructure()
        
        let temp = FileManager.default.locations.temporary
        XCTAssert(temp, isType: ThrowingFolder.self)
        XCTAssert(temp.file("test"), isType: ThrowingFile.self)
        XCTAssert(temp.folder("test"), isType: ThrowingFolder.self)
        XCTAssert(temp.up, isType: ThrowingFolder.self)
        try! FileManager.default.locations.folder(for: root).forEach() { item in
            XCTAssert(item, isType: ThrowingFolder.self)
        }
        
        let nothrow = FileManager.default.nothrow.temporary
        XCTAssert(nothrow, isType: NonThrowingFolder.self)
        XCTAssert(nothrow.file("test"), isType: NonThrowingFile.self)
        XCTAssert(nothrow.folder("test"), isType: NonThrowingFolder.self)
        XCTAssert(nothrow.up, isType: NonThrowingFolder.self)
        try! FileManager.default.nothrow.folder(for: root).forEach() { item in
            XCTAssert(item, isType: NonThrowingFolder.self)
        }
    }
}

// TODO: move to XCTestExtensions
func XCTAssert(_ item: Any, isType matching: Any.Type, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(type(of: item) == matching, file: file, line: line)

}
