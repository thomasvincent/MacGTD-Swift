# MacGTD for Microsoft 365

A Swift implementation of GTD (Getting Things Done) workflows for Microsoft 365 applications on macOS.

## Version

Current version: 1.0.0 (Semantic Versioning)

## Overview

MacGTD (formerly MacGTD-Microsoft) has been migrated from AppleScript/Automator to Swift, providing a more robust, maintainable, and testable codebase. This project helps implement the GTD methodology with Microsoft 365 applications such as:

- Microsoft To Do
- Outlook
- OneNote
- Teams

## Features

- Quick task capture for Microsoft 365 applications
- Command-line interface for task creation
- Swift library for integration with other applications
- Semantic versioning for better dependency management
- Packaged AppleScripts available for legacy support
- Comprehensive test suite (unit, integration, and functional tests)
- macOS installer package

## Requirements

- macOS 12.0 or later
- Xcode 13.0 or later (for development)
- Microsoft 365 applications

## Installation

### Installer Package
Download and run the installer package from the latest release:

```bash
# Download from GitHub releases
open "MacGTD-1.0.0-Installer.pkg"
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/thomasvincent/MacGTD-Swift.git

# Build the project
cd MacGTD-Swift
swift build -c release

# Install the command-line tool
cp .build/release/GTDTool /usr/local/bin/gtd
```

## Usage

```bash
# Add a task to Microsoft To Do
gtd add "Prepare presentation" --app todo --list "Work"

# Add a task to Outlook
gtd add "Schedule meeting with team" --app outlook

# Display version information
gtd version

# Show help
gtd help
```

## Testing

The project includes comprehensive testing at multiple levels:

### Unit Tests
Tests individual components in isolation:
```bash
swift test --filter "MacGTDTests.VersionTests"
swift test --filter "MacGTDTests.TaskManagerTests"
```

### Integration Tests
Tests the integration between components and external systems:
```bash
swift test --filter "MacGTDTests.IntegrationTests"
```

### Functional Tests
Tests the system as a whole, verifying workflows:
```bash
swift test --filter "MacGTDTests.FunctionalTests"
```

### Running All Tests
Use the provided script to run all tests:
```bash
./Scripts/run_tests.sh
```

## Building the Installer

To create a macOS installer package:
```bash
./Scripts/create_installer.sh
```

## Legacy AppleScripts

The original AppleScripts and Automator workflows are packaged and available for download from the GitHub Packages. These can be used if you prefer the original implementation or need compatibility with older systems.

## Migration Notice

This project has been migrated from AppleScript to Swift to provide:

- Better performance and reliability
- Modern language features
- Improved testability
- Better maintainability
- Enhanced error handling

## License

MIT License