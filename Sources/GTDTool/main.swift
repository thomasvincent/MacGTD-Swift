import Foundation
import MacGTD

enum Command: String {
    case add = "add"
    case version = "version"
    case help = "help"
}

func printHelp() {
    print("""
    MacGTD Tool v\(Version.current)
    
    Usage:
      GTDTool add "Task title" [--app APP] [--list LIST]
      GTDTool version
      GTDTool help
    
    Options:
      --app    Target app (todo, outlook, teams, onenote) [default: todo]
      --list   List name for Microsoft To Do [optional]
    
    Examples:
      GTDTool add "Prepare presentation" --app outlook
      GTDTool add "Buy groceries" --app todo --list "Shopping"
    """)
}

func printVersion() {
    print("MacGTD v\(Version.current)")
}

// Main execution
guard CommandLine.arguments.count > 1 else {
    printHelp()
    exit(0)
}

let command = Command(rawValue: CommandLine.arguments[1]) ?? .help

switch command {
case .add:
    guard CommandLine.arguments.count > 2 else {
        print("Error: Task title required")
        exit(1)
    }
    
    let taskTitle = CommandLine.arguments[2]
    var app: TaskApp = .microsoftToDo
    var list: String? = nil
    
    var i = 3
    while i < CommandLine.arguments.count {
        if CommandLine.arguments[i] == "--app", i + 1 < CommandLine.arguments.count {
            switch CommandLine.arguments[i + 1].lowercased() {
            case "todo":
                app = .microsoftToDo
            case "outlook":
                app = .outlook
            case "teams":
                app = .teams
            case "onenote":
                app = .oneNote
            default:
                print("Unknown app: \(CommandLine.arguments[i + 1])")
                exit(1)
            }
            i += 2
        } else if CommandLine.arguments[i] == "--list", i + 1 < CommandLine.arguments.count {
            list = CommandLine.arguments[i + 1]
            i += 2
        } else {
            i += 1
        }
    }
    
    do {
        try TaskManager.shared.addTask(title: taskTitle, toApp: app, withList: list)
        print("Task added: \(taskTitle)")
    } catch TaskError.emptyTaskTitle {
        print("Error: Task title cannot be empty")
        exit(1)
    } catch TaskError.notImplemented {
        print("Error: This function is not yet implemented")
        exit(1)
    } catch {
        print("Error: \(error.localizedDescription)")
        exit(1)
    }
    
case .version:
    printVersion()
    
case .help:
    printHelp()
}