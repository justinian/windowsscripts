# Make Shortcuts of select files residing in $source_location at $destination_location

[string] $source_location = Split-Path -parent $myInvocation.MyCommand.Definition
[string] $destination_location = "${Env:AppData}\Microsoft\Windows\Start Menu\Programs\Scripts"
$shell = New-Object -ComObject 'WScript.Shell'

if (Test-Path $destination_location -PathType container) {
	rm -r -Force $destination_location
}
New-Item $destination_location -ItemType container >$null

$script_types = @{
	"*.ps1" = ("C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe", "-File");
	"*.py" = ("C:\tools\python2\python.exe", "");
	"*.pyw" = ("C:\tools\python2\pythonw.exe", "");
	}

foreach ($mask in $script_types.Keys) {
	"Looking for $mask scripts..."

	[array]$file_masks = ,$mask
	[array]$files = Get-ChildItem -Path ( "$source_location" + '\*' ) -Include $file_masks -ea 0
	if (!$?) {
		'Error: ' + "$($error[0].Exception.Message)"
		Start-Sleep 2
		exit 1
	}

	foreach ($file in $files) {
		"`t$file"
		$item = $script_types.Item($mask)
		$lnk = $shell.CreateShortcut( "$( Join-Path $destination_location $(Split-Path -Leaf $($file.FullName)))" + ".lnk" )
		$lnk.TargetPath = $item[0]
		$lnk.Arguments = $item[1] + " `"$($file.FullName)`""
		$lnk.WorkingDirectory = Split-Path -Parent $file.FullName
		$lnk.Save()
	}
	""
}

"Done."
Start-Sleep 2
exit 0
