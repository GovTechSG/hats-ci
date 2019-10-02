# Set path to hats
$path_to_hats = "$env:PROGRAMFILES\hats"

# Create edge paths to allow drivers to have a destination to save in
# $path_to_edge32 = "$path_to_hats\drivers\edge32"
# $path_to_edge64 = "$path_to_hats\drivers\edge64"

echo "Create drivers folder in $path_to_hats"
If(!(test-path $path_to_hats))
{
	New-Item -ItemType Directory -Force -Path "$path_to_hats"
}

If(!(test-path "$path_to_hats\drivers"))
{
	New-Item -ItemType Directory -Force -Path "$path_to_hats\drivers"
	New-Item -ItemType Directory -Force -Path "$path_to_hats\drivers\edge-64-42"
	New-Item -ItemType Directory -Force -Path "$path_to_hats\drivers\edge-64-41"
	New-Item -ItemType Directory -Force -Path "$path_to_hats\drivers\edge-64-40"
}

. .\Get-IniContent.ps1

$iniContent = Get-IniContent "config.ini"
[System.Net.ServicePointManager]::SecurityProtocol =  [Enum]::ToObject([Net.SecurityProtocolType], 3072);

echo "Download Chrome driver"
$client = new-object System.Net.WebClient;
$client.DownloadFile($iniContent["BrowserDrivers"]["Chrome-32"],"$path_to_hats\chromedriver-32.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Chrome-32-chrome78"],"$path_to_hats\chromedriver-32-chrome78.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Chrome-32-chrome77"],"$path_to_hats\chromedriver-32-chrome77.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Chrome-32-chrome76"],"$path_to_hats\chromedriver-32-chrome76.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Chrome-32-chrome66"],"$path_to_hats\chromedriver-32-chrome66.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Chrome-32-chrome63"],"$path_to_hats\chromedriver-32-chrome63.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Chrome-32-chrome58"],"$path_to_hats\chromedriver-32-chrome58.zip");

echo "Download IE driver"
$client.DownloadFile($iniContent["BrowserDrivers"]["IE-32"],"$path_to_hats\IEDriverServer-32.zip");

echo "Download Firefox driver"
$client.DownloadFile($iniContent["BrowserDrivers"]["Firefox-32"],"$path_to_hats\geckodriver-32.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Firefox-64"],"$path_to_hats\geckodriver-64.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Firefox-32-firefox54"],"$path_to_hats\geckodriver-32-firefox54.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Firefox-64-firefox54"],"$path_to_hats\geckodriver-64-firefox54.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Firefox-32-firefox62"],"$path_to_hats\geckodriver-32-firefox62.zip");
$client.DownloadFile($iniContent["BrowserDrivers"]["Firefox-64-firefox62"],"$path_to_hats\geckodriver-64-firefox62.zip");

echo "Download Edge driver"
$client.DownloadFile($iniContent["BrowserDrivers"]["Edge-64-42"], "$path_to_hats\drivers\edge-64-42\MicrosoftWebDriver.exe");
$client.DownloadFile($iniContent["BrowserDrivers"]["Edge-64-41"], "$path_to_hats\drivers\edge-64-41\MicrosoftWebDriver.exe");
$client.DownloadFile($iniContent["BrowserDrivers"]["Edge-64-40"], "$path_to_hats\drivers\edge-64-40\MicrosoftWebDriver.exe");

echo "Unzipping Chrome driver"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"chromedriver-32.zip"', '-o"drivers\chrome"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"chromedriver-32-chrome78.zip"', '-o"drivers\chrome-78"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"chromedriver-32-chrome77.zip"', '-o"drivers\chrome-77"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"chromedriver-32-chrome76.zip"', '-o"drivers\chrome-76"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"chromedriver-32-chrome66.zip"', '-o"drivers\chrome-66"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"chromedriver-32-chrome63.zip"', '-o"drivers\chrome-63"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"chromedriver-32-chrome58.zip"', '-o"drivers\chrome-58"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Unzipping IE driver"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"IEDriverServer-32.zip"', '-o"drivers\ie32"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"

echo "Unzipping Firefox driver"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"geckodriver-32.zip"', '-o"drivers\firefox32"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"geckodriver-64.zip"', '-o"drivers\firefox64"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"geckodriver-32-firefox54.zip"', '-o"drivers\firefox32-firefox-54"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"geckodriver-64-firefox54.zip"', '-o"drivers\firefox64-firefox-54"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"geckodriver-32-firefox62.zip"', '-o"drivers\firefox32-firefox-62"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
Start-Process -FilePath "$path_to_hats\7-Zip\Files\7-Zip\7z.exe" -ArgumentList 'e', '"geckodriver-64-firefox62.zip"', '-o"drivers\firefox64-firefox-62"', '-aoa' -NoNewWindow -Wait -WorkingDirectory "$path_to_hats"
