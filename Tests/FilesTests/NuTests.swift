// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 11/06/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
import XCTestExtensions

@testable import Files

final class NuManagerTests: XCTestCase {
    func testBasic() {
        let temp = FileManager.default.locations.temporary
        print(temp)
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
    
//
//    func testFile() {
//        let url = temporaryFile(named: "test", extension: "txt")
//        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
//        try! "test".write(to: url, atomically: true, encoding: .utf8)
//        let file = fm.file(for: url)
//        XCTAssertTrue(file.exists)
//        XCTAssertTrue(file.isFile)
//        XCTAssertFalse(file.isHidden)
//
//        let url2 = url.deletingLastPathComponent().appendingPathComponent("Test2")
//        let renamed = try! file.rename(as: "Test2")
//        XCTAssertFalse(FileManager.default.fileExists(atURL: url))
//        XCTAssertFalse(file.exists)
//
//        XCTAssertTrue(FileManager.default.fileExists(atURL: url2))
//        XCTAssertTrue(renamed.exists)
//        try! renamed.delete()
//
//        XCTAssertFalse(FileManager.default.fileExists(atURL: url2))
//    }

}
