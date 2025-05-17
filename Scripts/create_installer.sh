#!/bin/bash

# Set error handling
set -e

VERSION=$(cat Sources/MacGTD/Version.swift | grep "public static let current" | cut -d'"' -f2)
PACKAGE_NAME="MacGTD-$VERSION"
IDENTIFIER="com.thomasvincent.macgtd"

echo "Creating installer for MacGTD v$VERSION..."

# Ensure we have Swift built
echo "Building Swift package..."
swift build -c release

# Create package directory structure
echo "Creating package structure..."
mkdir -p build/pkgroot/usr/local/bin
mkdir -p build/pkgroot/Applications/MacGTD/AppleScripts
mkdir -p build/pkgroot/Library/LaunchAgents
mkdir -p "build/pkgroot/Library/Application Support/MacGTD"

# Copy binaries and scripts
echo "Copying files..."
cp .build/release/GTDTool build/pkgroot/usr/local/bin/gtd
chmod +x build/pkgroot/usr/local/bin/gtd

# Copy AppleScripts
cp Package/AppleScripts/*.scpt "build/pkgroot/Applications/MacGTD/AppleScripts/"

# Create service file
cat > build/pkgroot/Library/LaunchAgents/com.thomasvincent.macgtd.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.thomasvincent.macgtd</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/gtd</string>
        <string>version</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

# Create an uninstall script
cat > "build/pkgroot/Applications/MacGTD/uninstall.sh" << EOF
#!/bin/bash

echo "Uninstalling MacGTD..."

# Remove binary
sudo rm -f /usr/local/bin/gtd

# Remove service file
sudo rm -f /Library/LaunchAgents/com.thomasvincent.macgtd.plist

# Remove application files
sudo rm -rf /Applications/MacGTD

# Remove support files
sudo rm -rf "/Library/Application Support/MacGTD"

echo "MacGTD has been uninstalled."
EOF
chmod +x "build/pkgroot/Applications/MacGTD/uninstall.sh"

# Create the component package
echo "Creating component package..."
pkgbuild --root build/pkgroot \
         --identifier "$IDENTIFIER" \
         --version "$VERSION" \
         --install-location "/" \
         "build/$PACKAGE_NAME.pkg"

# Create the distribution package with a nice UI
echo "Creating distribution package..."
mkdir -p build/resources

# Create a welcome file
cat > build/resources/welcome.html << EOF
<html>
<head>
<style>
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    font-size: 14px;
    line-height: 1.5;
    color: #333;
    margin: 20px;
}
h1 {
    font-size: 24px;
    margin-bottom: 10px;
}
p {
    margin-top: 0;
    margin-bottom: 10px;
}
</style>
</head>
<body>
<h1>Welcome to MacGTD $VERSION</h1>
<p>MacGTD is a Swift implementation of GTD (Getting Things Done) workflows for Microsoft 365 applications on macOS.</p>
<p>This installer will set up:</p>
<ul>
<li>The GTD command-line tool</li>
<li>Supporting AppleScripts</li>
<li>Required system components</li>
</ul>
<p>Click Continue to proceed with the installation.</p>
</body>
</html>
EOF

# Create a distribution file
cat > build/distribution.xml << EOF
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="1">
    <title>MacGTD $VERSION</title>
    <welcome file="welcome.html" mime-type="text/html"/>
    <background alignment="left" scaling="none"/>
    <allowed-os-versions>
        <os-version min="12.0"/>
    </allowed-os-versions>
    <pkg-ref id="$IDENTIFIER"/>
    <options customize="never" require-scripts="false"/>
    <choices-outline>
        <line choice="default">
            <line choice="$IDENTIFIER"/>
        </line>
    </choices-outline>
    <choice id="default"/>
    <choice id="$IDENTIFIER" visible="false">
        <pkg-ref id="$IDENTIFIER"/>
    </choice>
    <pkg-ref id="$IDENTIFIER" version="$VERSION" onConclusion="none">$PACKAGE_NAME.pkg</pkg-ref>
</installer-gui-script>
EOF

# Build the final installer package
productbuild --distribution build/distribution.xml \
             --resources build/resources \
             --package-path build \
             "MacGTD-$VERSION-Installer.pkg"

echo "Installer created: MacGTD-$VERSION-Installer.pkg"

# Make the script executable and copy it to the Package directory for GitHub Packages
chmod +x Scripts/create_installer.sh
mkdir -p Package/Installer
cp "MacGTD-$VERSION-Installer.pkg" Package/Installer/

echo "Done!"