import Foundation
@testable import MacGTD

// Extension to TaskError to make it Equatable for testing
extension TaskError: Equatable {
    public static func == (lhs: TaskError, rhs: TaskError) -> Bool {
        switch (lhs, rhs) {
        case (.emptyTaskTitle, .emptyTaskTitle):
            return true
        case (.encodingFailed, .encodingFailed):
            return true
        case (.notImplemented, .notImplemented):
            return true
        case (.appleScriptError(let lhsError), .appleScriptError(let rhsError)):
            return lhsError == rhsError
        case (.applicationNotFound(let lhsApp), .applicationNotFound(let rhsApp)):
            return lhsApp == rhsApp
        default:
            return false
        }
    }
}

// A class to capture output for testing
class OutputCapture {
    private let pipe = Pipe()
    private let originalStdout: Int32
    private var capturedOutput = Data()
    
    init() {
        // Save original stdout
        originalStdout = dup(FileHandle.standardOutput.fileDescriptor)
        
        // Redirect stdout to pipe
        dup2(pipe.fileHandleForWriting.fileDescriptor, FileHandle.standardOutput.fileDescriptor)
        
        // Set up notification to capture data
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(captureOutput),
            name: .NSFileHandleDataAvailable,
            object: pipe.fileHandleForReading
        )
        
        pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
    }
    
    deinit {
        // Restore original stdout
        dup2(originalStdout, FileHandle.standardOutput.fileDescriptor)
        close(originalStdout)
    }
    
    @objc private func captureOutput() {
        let data = pipe.fileHandleForReading.availableData
        if !data.isEmpty {
            capturedOutput.append(data)
            pipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        }
    }
    
    func stop() -> String {
        // Flush buffer
        fflush(stdout)
        
        // Restore original stdout to prevent further capture
        dup2(originalStdout, FileHandle.standardOutput.fileDescriptor)
        
        // Get the captured output as string
        return String(data: capturedOutput, encoding: .utf8) ?? ""
    }
}