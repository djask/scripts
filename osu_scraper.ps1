<# 
this script will take all audio files from the osu directory, 
rename them to appropriate names and move them to a specified folder
 #>

$OSUDIR = "D:\Games\osu!\Songs"
$CPDIR = "D:\test"

if(!(Test-Path -Path $CPDIR )){
	echo "DEBUG directory $CPDIR does not exist, creating..."
    New-Item -ItemType directory -Path $CPDIR
}

Get-ChildItem -Path $OSUDIR -Directory | foreach {
	$filename = $_.Name
	Get-ChildItem -Path $_.FullName *.mp3 | foreach {
		if([System.IO.File]::Exists("$CPDIR\$filename.mp3")){
			echo "file $filename.mp3 exists, skipping..."
		} else {
			echo "DEBUG Copy-Item $_.FullName -Destination $CPDIR\$filename.mp3"
			Copy-Item $_.FullName -Destination "$CPDIR\$filename.mp3"
		}
	}
}