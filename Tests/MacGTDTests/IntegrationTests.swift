import XCTest
@testable import MacGTD

final class IntegrationTests: XCTestCase {
    // This test requires Microsoft To Do to be installed
    func testMicrosoftToDoIntegration() throws {
        // Skip this test by default as it requires the actual app
        try XCTSkipIf(true, "Skipping integration test that requires Microsoft To Do")
        
        let taskManager = TaskManager.shared
        
        do {
            try taskManager.addTask(title: "Integration Test Task", toApp: .microsoftToDo)
            // Success if no exception is thrown
        } catch TaskError.applicationNotFound(let appName) {
            XCTFail("Microsoft To Do app not found: \(appName)")
        } catch {
            XCTFail("Failed to add task with error: \(error)")
        }
    }
    
    // This test requires Microsoft Outlook to be installed
    func testOutlookIntegration() throws {
        // Skip this test by default as it requires the actual app
        try XCTSkipIf(true, "Skipping integration test that requires Microsoft Outlook")
        
        let taskManager = TaskManager.shared
        
        do {
            try taskManager.addTask(title: "Integration Test Task", toApp: .outlook)
            // Success if no exception is thrown
        } catch TaskError.applicationNotFound(let appName) {
            XCTFail("Microsoft Outlook app not found: \(appName)")
        } catch {
            XCTFail("Failed to add task with error: \(error)")
        }
    }
    
    // Test the command-line tool integration
    func testCommandLineToolIntegration() throws {
        // This test requires the command-line tool to be built
        try XCTSkipIf(true, "Skipping integration test that requires built command-line tool")
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: ".build/debug/GTDTool")
        process.arguments = ["version"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        
        try process.run()
        process.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        XCTAssertEqual(output, "MacGTD v\(Version.current)")
        XCTAssertEqual(process.terminationStatus, 0)
    }
}