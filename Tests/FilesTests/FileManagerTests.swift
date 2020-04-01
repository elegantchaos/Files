// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import Files

final class FileManagerTests: XCTestCase {
    func testFileExistsAtURL() {
        let url = URL(fileURLWithPath: #file)
        XCTAssertTrue(FileManager.default.fileExists(atURL: url))
        let bogus = url.appendingPathExtension("bogus")
        XCTAssertFalse(FileManager.default.fileExists(atURL: bogus))
    }
}
