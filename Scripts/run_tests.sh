#!/bin/bash

# Set error handling
set -e

echo "=================================="
echo "Running MacGTD Swift Tests"
echo "=================================="

# Build the project
echo "Building project..."
swift build

# Run the tests
echo "Running unit tests..."
swift test --filter "MacGTDTests.VersionTests"
swift test --filter "MacGTDTests.TaskManagerTests"

echo "Running functional tests..."
swift test --filter "MacGTDTests.FunctionalTests"

# Skip integration tests by default since they require actual applications
if [ "$1" == "--with-integration" ]; then
    echo "Running integration tests..."
    TEST_INTEGRATION=1 swift test --filter "MacGTDTests.IntegrationTests"
else
    echo "Skipping integration tests (use --with-integration flag to run them)"
fi

echo "=================================="
echo "All tests completed successfully!"
echo "=================================="