import XCTest
@testable import MacGTD

final class VersionTests: XCTestCase {
    func testVersionFormat() {
        let version = Version.current
        let components = version.split(separator: ".")
        
        XCTAssertEqual(components.count, 3, "Version should have major.minor.patch format")
        XCTAssertTrue(Int(components[0]) != nil, "Major version should be a number")
        XCTAssertTrue(Int(components[1]) != nil, "Minor version should be a number")
        XCTAssertTrue(Int(components[2]) != nil, "Patch version should be a number")
    }
    
    func testVersionComponents() {
        XCTAssertGreaterThanOrEqual(Version.major, 0, "Major version should be non-negative")
        XCTAssertGreaterThanOrEqual(Version.minor, 0, "Minor version should be non-negative")
        XCTAssertGreaterThanOrEqual(Version.patch, 0, "Patch version should be non-negative")
    }
    
    func testVersionString() {
        let expected = "\(Version.major).\(Version.minor).\(Version.patch)"
        XCTAssertEqual(Version.current, expected, "Version.current should match the expected format")
    }
}