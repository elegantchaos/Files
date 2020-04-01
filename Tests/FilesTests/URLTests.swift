// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 01/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import XCTest
@testable import Files

final class URLTests: XCTestCase {
    func testAppendingPathComponents() {
        let url = URL(fileURLWithPath: "/")
        
        XCTAssertEqual(url.appendingPathComponents(["foo", "bar"]).path, "/foo/bar")
    }

    func testAppendingPathComponents2() {
        let url = URL(fileURLWithPath: "/")
        
        XCTAssertEqual(url.appendingPathComponents(["foo", "bar"]).path, "/foo/bar")
    }

}
