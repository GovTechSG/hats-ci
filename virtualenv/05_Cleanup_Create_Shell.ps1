# Set path to hats
$path_to_hats = "$env:PROGRAMFILES\hats"
echo "path_to_hats: $path_to_hats"

If(!(test-path $path_to_hats))
{
	New-Item -ItemType Directory -Force -Path "$path_to_hats"
}

echo "Removing temporary files that are no longer needed"
$fso = New-Object -ComObject scripting.filesystemobject
$fso.DeleteFolder("$path_to_hats\7-Zip")
$fso.DeleteFile("$path_to_hats\IEDriverServer-32.zip")
$fso.DeleteFile("$path_to_hats\chromedriver-32.zip")
$fso.DeleteFile("$path_to_hats\geckodriver-32.zip")
$fso.DeleteFile("$path_to_hats\geckodriver-64.zip")
$fso.DeleteFile("$path_to_hats\geckodriver-32-firefox54.zip")
$fso.DeleteFile("$path_to_hats\geckodriver-64-firefox54.zip")
$fso.DeleteFile("$path_to_hats\geckodriver-32-firefox62.zip")
$fso.DeleteFile("$path_to_hats\geckodriver-64-firefox62.zip")
$fso.DeleteFile("$path_to_hats\chromedriver-32-chrome78.zip")
$fso.DeleteFile("$path_to_hats\chromedriver-32-chrome77.zip")
$fso.DeleteFile("$path_to_hats\chromedriver-32-chrome76.zip")
$fso.DeleteFile("$path_to_hats\chromedriver-32-chrome66.zip")
$fso.DeleteFile("$path_to_hats\chromedriver-32-chrome63.zip")
$fso.DeleteFile("$path_to_hats\chromedriver-32-chrome58.zip")
$fso.DeleteFile("$path_to_hats\VCForPython37.exe")
$fso.DeleteFile("$path_to_hats\python37.exe")
$fso.DeleteFile("$path_to_hats\7z.msi")
# $fso.DeleteFile("$path_to_hats\jdk.exe")
$fso.DeleteFile("$path_to_hats\jdk.zip")
$fso.DeleteFile("$path_to_hats\androidSDK.zip")
$fso.DeleteFile("$path_to_hats\get-pip.py")
$fso.DeleteFile("$path_to_hats\node.zip")
$fso.DeleteFile("$path_to_hats\haxm.zip")
$fso.DeleteFile("$path_to_hats\PortableGit.exe");
$fso.DeleteFile("$path_to_hats\Gatling.zip")
$fso.DeleteFile("$path_to_hats\JMeter.zip")
$fso.DeleteFile("$path_to_hats\RED.zip")
# $fso.DeleteFile("$path_to_hats\scrcpy.zip")
$fso.DeleteFolder("$path_to_hats\utils\visualcppbuildtools")
$fso.DeleteFile("$path_to_hats\utils\visualcppbuildtools_full.exe")

echo "Copy shell scripts to $path_to_hats"
Copy-Item "shell\*" "$path_to_hats" -recurse

echo "Copy testpage to $path_to_hats"
Copy-Item "testpage" "$path_to_hats" -recurse

echo "Set Last Check for Update today"
Get-Date > "$path_to_hats\utils\last-check.txt"
