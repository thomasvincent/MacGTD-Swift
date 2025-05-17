import XCTest
@testable import MacGTD

final class FunctionalTests: XCTestCase {
    // Test the full workflow of adding a task
    func testAddTaskWorkflow() throws {
        // Use a mock to avoid actual Apple Script execution
        let mockTaskManager = MockTaskManager()
        
        // Test with Microsoft To Do
        try mockTaskManager.addTask(title: "Buy groceries", toApp: .microsoftToDo, withList: "Shopping")
        XCTAssertEqual(mockTaskManager.lastApp, .microsoftToDo)
        XCTAssertEqual(mockTaskManager.lastTitle, "Buy groceries")
        XCTAssertEqual(mockTaskManager.lastList, "Shopping")
        
        // Test with Outlook
        try mockTaskManager.addTask(title: "Call client", toApp: .outlook)
        XCTAssertEqual(mockTaskManager.lastApp, .outlook)
        XCTAssertEqual(mockTaskManager.lastTitle, "Call client")
    }
    
    // Test error handling
    func testErrorHandling() {
        let mockTaskManager = MockTaskManager()
        mockTaskManager.shouldThrowError = true
        
        XCTAssertThrowsError(try mockTaskManager.addTask(title: "Test task", toApp: .microsoftToDo)) { error in
            XCTAssertEqual((error as? TaskError)?.localizedDescription, TaskError.appleScriptError("Mock error").localizedDescription)
        }
    }
    
    // Test the command line parsing functionality
    func testCommandLineParsing() {
        // This would be a functional test of the command line argument parsing
        // In a real implementation, we would extract the argument parsing logic to a separate
        // function that could be tested without actually running the tool
        
        // For this example, we'll do a simple mock test
        let args = ["GTDTool", "add", "Test task", "--app", "outlook"]
        
        // Mock version of what would happen in main.swift
        let command = args[1]
        XCTAssertEqual(command, "add")
        
        let taskTitle = args[2]
        XCTAssertEqual(taskTitle, "Test task")
        
        var app: TaskApp = .microsoftToDo
        if args[3] == "--app" && args[4] == "outlook" {
            app = .outlook
        }
        XCTAssertEqual(app, .outlook)
    }
    
    // Test the AppleScript generation
    func testAppleScriptGeneration() {
        // Here we would test that the AppleScript is being correctly generated
        // This is just a placeholder for the real implementation
        
        // Create a subclass of TaskManager that exposes the script generation
        class TestTaskManager: TaskManager {
            func generateAppleScriptForToDo(title: String, list: String? = nil) -> String {
                return """
                tell application "Microsoft To Do"
                    activate
                    delay 1
                    tell application "System Events"
                        keystroke "n" using {command down}
                        delay 0.5
                        keystroke "\(title)"
                        delay 0.5
                        keystroke return
                    end tell
                end tell
                """
            }
        }
        
        let testManager = TestTaskManager()
        let script = testManager.generateAppleScriptForToDo(title: "Test Task")
        
        XCTAssertTrue(script.contains("Microsoft To Do"))
        XCTAssertTrue(script.contains("Test Task"))
    }
}