#!/bin/bash

# Create workflow directory
mkdir -p "MS-GTD-QuickCapture.workflow/Contents/document.wflow"

# Create info.plist
cat > "MS-GTD-QuickCapture.workflow/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleIdentifier</key>
	<string>com.apple.Automator.MS-GTD-QuickCapture</string>
	<key>CFBundleName</key>
	<string>MS-GTD-QuickCapture</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0.0</string>
	<key>CFBundleVersion</key>
	<string>1.0.0</string>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>MS-GTD-QuickCapture</string>
			</dict>
			<key>NSMessage</key>
			<string>runWorkflowAsService</string>
		</dict>
	</array>
</dict>
</plist>
EOF

# Copy AppleScripts into workflow package
cp *.scpt "MS-GTD-QuickCapture.workflow/Contents/"

# Create zip file
zip -r MS-GTD-QuickCapture.zip MS-GTD-QuickCapture.workflow

echo "Workflow package created: MS-GTD-QuickCapture.zip"