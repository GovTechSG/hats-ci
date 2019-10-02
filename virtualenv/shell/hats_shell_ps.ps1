# Set current path
$current_path = (Get-Item -Path ".\" -Verbose).FullName

echo "INFO: Stored current working directory at $current_path"

# INFO: Set path to hats C:\Users\hats\Desktop\hats-ci\virtualenv\shell\
# $path_to_hats  = split-path -parent $MyInvocation.MyCommand.Definition
$path_to_hats = "$PSScriptRoot"
$path_to_origPrefix = "$path_to_hats\hats\Lib\orig-prefix.txt";

echo "path_to_origPrefix: $path_to_origPrefix "

$origPrefixContent = [IO.File]::ReadAllText($path_to_origPrefix)
echo "origPrefixContent $origPrefixContent"
$pythonDir = "$path_to_hats\Python37".ToLower();
echo "pythonDir: $pythonDir "

If (!$pythonDir.equals($origPrefixContent)) {
	echo "Overwrite 'hats\Lib\orig-prefix.txt' with directory to Python"

	[System.IO.File]::WriteAllText($path_to_origPrefix,$pythonDir,[System.Text.Encoding]::ASCII)
}

$env:Path = "$env:windir;$env:windir\system32;$env:windir\system32\WindowsPowerShell\v1.0"

echo "INFO: Set path to Python37"
$env:Path = "$env:Path;$path_to_hats\Python37;$path_to_hats\Python37\Scripts";

if ([System.IntPtr]::Size -eq 4)
{
	echo "INFO: Set path to JDK32 for this session"
	$env:JAVA_HOME = "$path_to_hats\jdk32"
	$env:Path = "$env:Path;$env:JAVA_HOME\bin";
}
else
{
	echo "INFO: Set path to JDK for this session"
	$env:JAVA_HOME = "$path_to_hats\jdk"
	$env:Path = "$env:Path;$env:JAVA_HOME\bin";
}

$client = new-object System.Net.WebClient;
$path_to_hats = "$env:PROGRAMFILES\hats"

echo "INFO: Set path to browser drivers for this session"

. $path_to_hats\utils\Get-ExeTargetMachine.ps1

$ie_path = "C:\Program Files\Internet Explorer\iexplore.exe"

if (Test-Path env:ie_path) {
	$ie_path = $env:ie_path
}

if (Test-Path $ie_path) 
{
	$ie_version = (Get-Item $ie_path).VersionInfo.FileVersion
	
	if ((Get-ExeTargetMachine $ie_path).TargetMachine -eq "x64")
	{
		echo "INFO: Found 64-bit Microsoft Internet Explorer Version $ie_version"
		# Fallback to 32-bit IE driver for now to workaround slow page typing
		# $env:Path = "$env:Path;$path_to_hats\drivers\ie64";
		$env:Path = "$env:Path;$path_to_hats\drivers\ie32";
	}
	else
	{
		echo "INFO: Found 32-bit Microsoft Internet Explorer Version $ie_version"
		$env:Path = "$env:Path;$path_to_hats\drivers\ie32";
	}
	
}
else 
{
	echo "WARN: Could not detect Microsoft internet Explorer"
	$env:Path = "$env:Path;$path_to_hats\drivers\ie64";
}

#$env:Path = "$env:Path;$path_to_hats\drivers\ie";

$path_to_programfiles_x86 = "C:\Program Files (x86)"

$chrome_path = "$path_to_programfiles_x86\Google\Chrome\Application\chrome.exe";

if (-Not (Test-Path $chrome_path))
{
	$chrome_path = "C:\Program Files\Google\Chrome\Application\chrome.exe"
}

if (Test-Path env:chrome_path) {
	$chrome_path = $env:chrome_path
}

if (Test-Path $chrome_path) 
{
	$chrome_version = (Get-Item $chrome_path).VersionInfo.FileVersion
	if ($chrome_version -eq $null)
	{
		echo "WARN: Could not detect Google Chrome"
	}
	else
	{
		echo "INFO: Found Google Chrome Version $chrome_version"

        $chrome_version_short = $chrome_version.substring(0,2)
        $chromedriver_source_path = "$path_to_hats\chromedriver-32-chrome{0}.zip" -f $chrome_version_short
        $chromedriver_destination_path = "$path_to_hats\drivers\chrome-{0}" -f $chrome_version_short

        if ($chrome_version -match "^5[6-8].*") 
		{
			echo "INFO: Support for Chrome v58 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\chrome-58";
		}
		elseif ($chrome_version -match "^(59|6[0-3]).*") 
		{
			echo "INFO: Support for Chrome v59-63 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\chrome-63";
		}
		elseif ($chrome_version -match "^(6[4-6]).*") 
		{
			echo "INFO: Support for Chrome v64-66 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\chrome-66";
		}
		elseif ($chrome_version -match "^(7[4-6]).*") 
		{
			echo "INFO: Support for Chrome v-74-76 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\chrome-76";
		}
		elseif ($chrome_version_short -eq "77") 
		{
			echo "INFO: Support for Chrome v77 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\chrome-77";
		}
		elseif ($chrome_version_short -eq "78") 
		{
			echo "INFO: Support for Chrome v78 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\chrome-78";
		}
        else
        {
            if (Test-Path -Path $chromedriver_destination_path)
            {
                echo "INFO: Support for Chrome v{0} enabled" -f $chrome_version_short
                $env:Path = "$env:Path;$path_to_hats\drivers\chrome-{0}" -f $chrome_version_short;
            }
            else
            {
                echo "INFO: Support for Chrome v{0} not found" -f $chrome_version_short
                $chromedriver_version_url = "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_{0}" -f $chrome_version.substring(0, $chrome_version.length - 2)
                $chromedriver_version = Invoke-WebRequest $chromedriver_version_url
                $chromedriver_filename = "chromedriver-32-chrome{0}.zip" -f $chrome_version_short
                echo "INFO: Downloading latest Chromedriver from https://chromedriver.storage.googleapis.com/{0}/chromedriver_win32.zip" -f $chromedriver_version.Content
                $client.DownloadFile("https://chromedriver.storage.googleapis.com/{0}/chromedriver_win32.zip" -f $chromedriver_version.Content, $chromedriver_source_path);
                Expand-Archive -LiteralPath $chromedriver_source_path -DestinationPath $chromedriver_destination_path
                Remove-Item $chromedriver_source_path
                echo "INFO: Support for Chrome v{0} enabled" -f $chrome_version_short
                $env:Path = "$env:Path;$path_to_hats\drivers\chrome-{0}" -f $chrome_version_short;
            }
        }
	}
	
}
else
{
	echo "WARN: Could not detect Google Chrome"
	$env:Path = "$env:Path;$path_to_hats\drivers\chrome";
}


$firefox_path = "$path_to_programfiles_x86\Mozilla Firefox\firefox.exe";

if (-Not (Test-Path $firefox_path))
{
	$firefox_path = "C:\Program Files\Mozilla Firefox\firefox.exe"
}

if (Test-Path env:firefox_path) {
	$firefox_path = $env:firefox_path
}

if (Test-Path $firefox_path)
{	
	$firefox_version = (Get-Item $firefox_path).VersionInfo.FileVersion

	if ((Get-ExeTargetMachine $firefox_path).TargetMachine -eq "x64")
	{
		echo "INFO: Found 64-bit Mozilla Firefox Version $firefox_version"
		
		if ($firefox_version -match "^([5][0-4])|([0-4][0-9]).*") 
		{
			echo "INFO: Support for Mozilla Firefox <= v54 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\firefox64-firefox-54";
		}
		elseif ($firefox_version -match "^([5][5-9])|(6[0-2]).*")
		{
			echo "INFO: Support for Mozilla Firefox <= v62 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\firefox64-firefox-62";
		}
		else
		{
			$env:Path = "$env:Path;$path_to_hats\drivers\firefox64";
		}
		
	} 
	else 
	{
		echo "INFO: Found 32-bit Mozilla Firefox Version $firefox_version"
		
		if ($firefox_version -match "^([5][0-4])|([0-4][0-9]).*") 
		{
			echo "INFO: Support for Mozilla Firefox <= v54 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\firefox32-firefox-54";
		}
		elseif ($firefox_version -match "^([5][5-9])|(6[0-2]).*")
		{
			echo "INFO: Support for Mozilla Firefox <= v62 enabled"
			$env:Path = "$env:Path;$path_to_hats\drivers\firefox32-firefox-62";
		}
		else
		{
			$env:Path = "$env:Path;$path_to_hats\drivers\firefox32";
		}
	}

}
else
{
	echo "WARN: Could not detect Mozilla Firefox"
	$env:Path = "$env:Path;$path_to_hats\drivers\firefox64";
}

$edge_path = "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe"

if (Test-Path $edge_path) {
    $edge_version = (Get-AppxPackage Microsoft.MicrosoftEdge).Version

    if ($edge_version -eq "44.18362.1.0")
    {
        echo "INFO: Found 64-bit Microsoft Edge Version $edge_version."
    }
    else
    {
        if ($edge_version -eq "42.17134.1.0")
        {
            $env:Path = "$env:Path;$path_to_hats\drivers\edge-64-42";
            echo "INFO: Found 64-bit Microsoft Edge Version $edge_version."
        }
        elseif ($edge_version -eq "41.16299.15")
        {
            $env:Path = "$env:Path;$path_to_hats\drivers\edge-64-41";
            echo "INFO: Found 64-bit Microsoft Edge Version $edge_version."
        }
        elseif ($edge_version -eq "40.15063")
        {
            $env:Path = "$env:Path;$path_to_hats\drivers\edge-64-40";
            echo "INFO: Found 64-bit Microsoft Edge Version $edge_version."
        }
        else
        {
            echo "INFO: Found 64-bit Microsoft Edge Version $edge_version. Only version 40.15063 or greater are supported."
        }
    }
}

# if (Test-Path $edge_path)
# {
# 	$edge_version = (Get-Item $edge_path).VersionInfo.FileVersion

# 	if ((Get-ExeTargetMachine $edge_path).TargetMachine -eq "x64")
# 	{
# 		echo "INFO: Found 64-bit Microsoft Edge Version $edge_version"
# 		$env:Path = "$env:Path;$path_to_hats\drivers\edge64";
# 	}
# 	else
# 	{
# 		echo "INFO: Found 32-bit Microsoft Edge Version $edge_version"
# 		$env:Path = "$env:Path;$path_to_hats\drivers\edge32"
# 	}
# }
# else
# {
# 	echo: "WARN: Could not detect Microsoft Edge"
# 	$env:Path = "$env:Path;$path_to_hats\drivers\edge64"
# }

$env:ie_version = $ie_version;
$env:chrome_version = $chrome_version;
$env:firefox_version = $firefox_version;
# $env:edge_version = $edge_version;

echo "INFO: Set path to utils for this session"
$env:Path = "$env:Path;$path_to_hats\utils";

echo "INFO: Set path to node for this session"
$env:Path = "$env:Path;$path_to_hats\nodejs";

echo "INFO: Set path to node_modules for this session"
$env:Path = "$env:Path;$path_to_hats\node_modules\.bin;./node_modules/.bin";

echo "INFO: Set path to npm-global for this session"
$env:Path = "$env:Path;$path_to_hats\npm-global;$path_to_hats\npm-global\bin";

echo "INFO: Set path to androidSDK tools for this session"
$env:Path = "$env:Path;$path_to_hats\androidSDK\emulator;$path_to_hats\androidSDK\tools;$path_to_hats\androidSDK\tools\bin\;$path_to_hats\androidSDK\platform-tools";

$env:ANDROID_HOME = "$path_to_hats\androidSDK"
$env:ANDROID_SDK_HOME = "$path_to_hats\androidSDK"
$env:ANDROID_SDK_ROOT = "$path_to_hats\androidSDK"

echo "INFO: Set path to Git for this session"
$env:Path = "$env:Path;$path_to_hats\Git\cmd;$path_to_hats\Git\mingw32\bin;$path_to_hats\Git\usr\bin"

echo "INFO: Set path to Gatling for this session"
$env:Path = "$env:Path;$path_to_hats\Gatling\bin"
$env:GATLING_HOME = "$path_to_hats\Gatling"

echo "INFO: Set path to JMeter for this session"
$env:Path = "$env:Path;$path_to_hats\JMeter\bin"

echo "INFO: Set path to RED for this session"
$env:Path = "$env:Path;$path_to_hats\RED"

echo "INFO: Set path to TagUI for this session"
$env:Path = "$env:Path;$path_to_hats\tagui\src"

echo "INFO: Set path to SikuliX for this session"
$env:Path = "$env:Path;$path_to_hats\tagui\src\tagui.sikuli"

echo "INFO: Set path to scrcpy for this session"
$env:Path = "$env:Path;$path_to_hats\scrcpy-win64"

if (Test-Path "$path_to_hats\jython2.7.0")
{	
	echo "INFO: Add path to Jython"
	$env:Path = "$env:Path;$path_to_hats\jython2.7.0\bin"
}

echo "INFO: Activate hats virtual environment"
cd "$path_to_hats"
hats\Scripts\activate

cd "$current_path"

. $path_to_hats\utils\check_last_update.ps1

echo ""
$allArgs = $PsBoundParameters.Values + $args + ""

if ($allArgs)
{
	echo "Running: $allArgs"
	iex "& $allArgs"
} else
{
	echo "Run 'commands' to get a list of useful commands."
	echo ""
}
