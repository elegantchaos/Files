import XCTest
@testable import URLExtensions

final class URLExtensionsTests: XCTestCase {
    func testAppendingPathComponents() {
        let url = URL(fileURLWithPath: "/")
        
        XCTAssertEqual(url.appendingPathComponents(["foo", "bar"]).path, "/foo/bar")
    }

    func testAppendingPathComponents2() {
        let url = URL(fileURLWithPath: "/")
        
        XCTAssertEqual(url.appendingPathComponents(["foo", "bar"]).path, "/foo/bar")
    }

}
