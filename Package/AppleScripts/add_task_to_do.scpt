tell application "Microsoft To Do"
	activate
	delay 1
	tell application "System Events"
		keystroke "n" using {command down}
		delay 0.5
		keystroke "New Task"
		delay 0.5
		keystroke return
	end tell
end tell