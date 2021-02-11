// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/02/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import Files

final class NoThrowFolderManagerTests: XCTestCase {
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

    func testNoThrowFailure() {
        var receivedError: NSError? = nil
        let fm = NonThrowingManager(errorHandler: { error in receivedError = error as NSError })
        _ = fm.temporary.file("non-existent").rename(as: "test")
        XCTAssertEqual(receivedError?.code, 4)
        XCTAssertEqual(receivedError?.domain, "NSCocoaErrorDomain")
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
}
