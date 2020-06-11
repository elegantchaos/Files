// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import Files

final class FolderManagerTests: XCTestCase {
    func testFolder() {
        let h = FolderManager.shared.home
        
        XCTAssertEqual(h.url, URL(fileURLExpandingPath: "~/"))
        XCTAssertTrue(h.exists)
        XCTAssertFalse(h.isFile)
        XCTAssertFalse(h.isHidden)
        
        let url = temporaryFile()
        let folder = FolderManager.shared.folder(for: url)
        folder.create()
        XCTAssertTrue(FileManager.default.fileExists(atURL: url))
        
        let url2 = url.deletingLastPathComponent().appendingPathComponent("Test2")
        let renamed = folder.rename(as: "Test2")
        XCTAssertFalse(FileManager.default.fileExists(atURL: url))
        XCTAssertFalse(folder.exists)
        
        XCTAssertTrue(FileManager.default.fileExists(atURL: url2))
        XCTAssertTrue(renamed.exists)
        renamed.delete()
        
        XCTAssertFalse(FileManager.default.fileExists(atURL: url2))
        
    }
    
    func testFile() {
        let url = temporaryFile(named: "test", extension: "txt")
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try! "test".write(to: url, atomically: true, encoding: .utf8)
        let file = FolderManager.shared.file(for: url)
        XCTAssertTrue(file.exists)
        XCTAssertTrue(file.isFile)
        XCTAssertFalse(file.isHidden)

        let url2 = url.deletingLastPathComponent().appendingPathComponent("Test2")
        let renamed = file.rename(as: "Test2")
        XCTAssertFalse(FileManager.default.fileExists(atURL: url))
        XCTAssertFalse(file.exists)
        
        XCTAssertTrue(FileManager.default.fileExists(atURL: url2))
        XCTAssertTrue(renamed.exists)
        renamed.delete()
        
        XCTAssertFalse(FileManager.default.fileExists(atURL: url2))
    }
    
    func testHidden() {
        let url = temporaryFile(named: ".test")
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
        try! "test".write(to: url, atomically: true, encoding: .utf8)
        let file = FolderManager.shared.file(for: url)
        XCTAssertTrue(file.isHidden)
    }
    
    func testFailure() {
        var receivedError: NSError? = nil
        let fm = FolderManager(errorHandler: { error in receivedError = error as NSError })
        fm.temporary.file("non-existent").rename(as: "test")
        XCTAssertEqual(receivedError?.code, 4)
        XCTAssertEqual(receivedError?.domain, "NSCocoaErrorDomain")
    }
}
