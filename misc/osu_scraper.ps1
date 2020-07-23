<# 
this script will take all audio files from the osu directory, 
rename them to appropriate names and move them to a specified folder
 #>

$OSUDIR = "D:\Games\osu!\Songs"
$CPDIR = "D:\music\osump3"

if(!(Test-Path -Path $OSUDIR )){
	echo "DEBUG please check your osu directory is correct"
	exit
}

if(!(Test-Path -Path $CPDIR )){
	echo "DEBUG directory $CPDIR does not exist, creating..."
    New-Item -ItemType directory -Path $CPDIR
}

Get-ChildItem -Path $OSUDIR -Directory | foreach {

	<# since most osu audio tracks are literally called audio.mp3 this
	causes many issues with conflicting file names #>	
	$filename = $_.Name
	
	# grab the first mp3 file over 1mb. we assume this is the osz audio track 
	Get-ChildItem -LiteralPath $_.FullName *.mp3 | where-object {$_.length -gt 1mb} | Select-Object -First 1 {
		if([System.IO.File]::Exists("$CPDIR\$filename.mp3")){
			echo "DEBUG file $filename.mp3 exists, skipping..."
		} else {
			echo "DEBUG Copying $filename"
			Copy-Item -LiteralPath $_.FullName -Destination "$CPDIR\$filename.mp3"
		}
	}
}