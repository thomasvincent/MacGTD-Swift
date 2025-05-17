import XCTest
@testable import MacGTD

final class TaskManagerTests: XCTestCase {
    let taskManager = TaskManager.shared
    
    func testEmptyTaskTitle() {
        XCTAssertThrowsError(try taskManager.addTask(title: "", toApp: .microsoftToDo)) { error in
            XCTAssertEqual(error as? TaskError, TaskError.emptyTaskTitle)
        }
    }
    
    // This test mocks the AppleScript functionality for testing
    func testAddTaskToMicrosoftToDo() {
        // Create a mock task manager that overrides the AppleScript execution
        let mockTaskManager = MockTaskManager()
        
        do {
            try mockTaskManager.addTask(title: "Test Task", toApp: .microsoftToDo)
            XCTAssertEqual(mockTaskManager.lastApp, .microsoftToDo)
            XCTAssertEqual(mockTaskManager.lastTitle, "Test Task")
            XCTAssertNil(mockTaskManager.lastList)
        } catch {
            XCTFail("Failed to add task with error: \(error)")
        }
    }
    
    func testAddTaskToMicrosoftToDoWithList() {
        let mockTaskManager = MockTaskManager()
        
        do {
            try mockTaskManager.addTask(title: "Test Task", toApp: .microsoftToDo, withList: "Test List")
            XCTAssertEqual(mockTaskManager.lastApp, .microsoftToDo)
            XCTAssertEqual(mockTaskManager.lastTitle, "Test Task")
            XCTAssertEqual(mockTaskManager.lastList, "Test List")
        } catch {
            XCTFail("Failed to add task with error: \(error)")
        }
    }
    
    func testAddTaskToOutlook() {
        let mockTaskManager = MockTaskManager()
        
        do {
            try mockTaskManager.addTask(title: "Test Task", toApp: .outlook)
            XCTAssertEqual(mockTaskManager.lastApp, .outlook)
            XCTAssertEqual(mockTaskManager.lastTitle, "Test Task")
        } catch {
            XCTFail("Failed to add task with error: \(error)")
        }
    }
    
    func testTaskAppIdentifiers() {
        XCTAssertEqual(TaskApp.microsoftToDo.appIdentifier, "com.microsoft.to-do-mac")
        XCTAssertEqual(TaskApp.outlook.appIdentifier, "com.microsoft.Outlook")
        XCTAssertEqual(TaskApp.teams.appIdentifier, "com.microsoft.Teams")
        XCTAssertEqual(TaskApp.oneNote.appIdentifier, "com.microsoft.onenote.mac")
    }
}

// Mock implementation for testing
class MockTaskManager: TaskManager {
    var lastTitle: String?
    var lastApp: TaskApp?
    var lastList: String?
    var shouldThrowError = false
    
    override func addTask(title: String, toApp app: TaskApp, withList list: String? = nil) throws {
        guard !title.isEmpty else {
            throw TaskError.emptyTaskTitle
        }
        
        if shouldThrowError {
            throw TaskError.appleScriptError("Mock error")
        }
        
        lastTitle = title
        lastApp = app
        lastList = list
    }
}