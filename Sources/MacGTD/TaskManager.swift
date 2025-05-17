import Foundation
import AppKit

public enum TaskApp {
    case microsoftToDo
    case outlook
    case teams
    case oneNote
    
    var appIdentifier: String {
        switch self {
        case .microsoftToDo:
            return "com.microsoft.to-do-mac"
        case .outlook:
            return "com.microsoft.Outlook"
        case .teams:
            return "com.microsoft.Teams"
        case .oneNote:
            return "com.microsoft.onenote.mac"
        }
    }
}

public class TaskManager {
    public static let shared = TaskManager()
    
    private init() {}
    
    public func addTask(title: String, toApp app: TaskApp, withList list: String? = nil) throws {
        guard !title.isEmpty else {
            throw TaskError.emptyTaskTitle
        }
        
        // Encode the task title for URL schemes
        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw TaskError.encodingFailed
        }
        
        switch app {
        case .microsoftToDo:
            try addTaskToMicrosoftToDo(title: encodedTitle, list: list)
        case .outlook:
            try addTaskToOutlook(title: encodedTitle)
        case .teams:
            try addTaskToTeams(title: encodedTitle)
        case .oneNote:
            try addTaskToOneNote(title: encodedTitle)
        }
        
        // Show notification
        showNotification(title: "Task Added", body: "Task successfully added to \(app)")
    }
    
    private func addTaskToMicrosoftToDo(title: String, list: String?) throws {
        // Implementation would use AppleScript or URL schemes
        // This is a placeholder for the actual implementation
        
        let script = """
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
        
        try runAppleScript(script)
    }
    
    private func addTaskToOutlook(title: String) throws {
        // Placeholder implementation
        let script = """
        tell application "Microsoft Outlook"
            activate
            make new task with properties {subject:"\(title)"}
        end tell
        """
        
        try runAppleScript(script)
    }
    
    private func addTaskToTeams(title: String) throws {
        // Placeholder implementation using system events
        // Teams doesn't have good AppleScript support, so would need UI automation
        
        throw TaskError.notImplemented
    }
    
    private func addTaskToOneNote(title: String) throws {
        // Placeholder implementation
        let script = """
        tell application "Microsoft OneNote"
            activate
            delay 1
            tell application "System Events"
                keystroke "n" using {command down}
                delay 0.5
                keystroke "\(title)"
            end tell
        end tell
        """
        
        try runAppleScript(script)
    }
    
    private func runAppleScript(_ script: String) throws {
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: script)
        scriptObject?.executeAndReturnError(&error)
        
        if let error = error {
            throw TaskError.appleScriptError(error["NSAppleScriptErrorMessage"] as? String ?? "Unknown error")
        }
    }
    
    private func showNotification(title: String, body: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.informativeText = body
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
    }
}

public enum TaskError: Error {
    case emptyTaskTitle
    case encodingFailed
    case appleScriptError(String)
    case applicationNotFound(String)
    case notImplemented
}