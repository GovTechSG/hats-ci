# Set path to hats
$path_to_hats = "$env:PROGRAMFILES\hats"

echo "Create drivers folder in $path_to_hats"
If(!(test-path $path_to_hats))
{
	New-Item -ItemType Directory -Force -Path "$path_to_hats"
}

If(!(test-path "$path_to_hats\Git"))
{
	New-Item -ItemType Directory -Force -Path "$path_to_hats\Git"
}

If(!(test-path "$path_to_hats\Robotcorder"))
{
	New-Item -ItemType Directory -Force -Path "$path_to_hats\Robotcorder"
}

. .\Get-IniContent.ps1

$iniContent = Get-IniContent "config.ini"

echo "Download Git"
$client = new-object System.Net.WebClient;
[System.Net.ServicePointManager]::SecurityProtocol =  [Enum]::ToObject([Net.SecurityProtocolType], 3072);

$client.DownloadFile($iniContent["Git"]["Git"],"$path_to_hats\PortableGit.exe");

echo "Unzipping Git"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'x', '"PortableGit.exe"', '-o"Git"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Download Robotcorder"
$client = new-object System.Net.WebClient;
$client.DownloadFile($iniContent["hats"]["Robotcorder"],"$path_to_hats\Robotcorder.crx");

echo "Unzipping Robotcorder"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'x', '"Robotcorder.crx"', '-o"Robotcorder"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Rename Robotcorder\_metadata folder to metadata"
Rename-Item "$path_to_hats\Robotcorder\_metadata" "metadata"

echo "Download Gatling"
$client = new-object System.Net.WebClient;
$client.DownloadFile($iniContent["Gatling"]["Gatling"],"$path_to_hats\Gatling.zip");

echo "Unzipping Gatling"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'x', '"Gatling.zip"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Rename Gatling folder"
If(test-path "$path_to_hats\Gatling")
{
	Remove-Item -ItemType Directory -Force -Path "$path_to_hats\Gatling"
}

Rename-Item "$path_to_hats\gatling-charts-highcharts-bundle-3.0.0-RC3" "Gatling"

echo "Download JMeter"
$client = new-object System.Net.WebClient;
$client.DownloadFile($iniContent["JMeter"]["JMeter"],"$path_to_hats\JMeter.zip");

echo "Unzipping JMeter"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'x', '"JMeter.zip"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Rename JMeter"
If(test-path "$path_to_hats\JMeter")
{
	Remove-Item -ItemType Directory -Force -Path "$path_to_hats\JMeter"
}

Rename-Item "$path_to_hats\apache-jmeter-5.0" "JMeter"

echo "Download RED"
$client = new-object System.Net.WebClient;
$client.DownloadFile($iniContent["RED"]["RED"],"$path_to_hats\RED.zip");

echo "Unzipping RED"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'x', '"RED.zip"', '-o"RED"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Replace RED splash bitmap"
$path_to_RED_splash_bmp = "RED\configuration\org.eclipse.equinox.launcher\org.robotframework.ide.eclipse.product.plugin_0.8.2.201712181235";
New-Item "$path_to_hats\$path_to_RED_splash_bmp" -ItemType Directory

$client.DownloadFile($iniContent["hats"]["splash.bmp"],"$path_to_hats\$path_to_RED_splash_bmp\splash.bmp");
