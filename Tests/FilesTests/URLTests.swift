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
