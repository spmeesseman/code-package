######################################################################
#                                                                    #
# This script converts specified demographic fileds to               #
# specified values in a text file(s)                                 #
#                                                                    #
######################################################################


######################################################################
#                                                                    #
# Command line parameters must be iterated first                     #
#                                                                    #
######################################################################

# Read in command line parameters if any

param ( 
    [string]$in = "historytmp.txt",
    [string]$out = "history.txt", 
    [string]$numsections = "1",
    [switch]$listonly = $false,
    [string]$version = "",
    [string]$project = "",
    [switch]$Help = $false,
    [switch]$h = $false
)

######################################################################
#                                                                    #
# Static definitions                                                 #
#                                                                    #
######################################################################

$szInputFile = $in;
$szOutputFile = $out;
$szNumSections = $numsections;

$iNumberOfDashesInVersionLine = 20;

# Get the scripts executing directory name
$ScriptDir = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition);

# Define script version
$ScriptVersion = "106";

# Get current date in different format
$CurrentDateFormatted = Get-Date -format "MM/dd/yyyy";

######################################################################
#                                                                    #
# Function to write messages to a log file and to the screen         #
#                                                                    #
######################################################################

function LogMessage($message)
{
   # Get current date time
   $CurrentDateTime = Get-Date -format "yyyy\/MM\/dd \a\t HH:mm:ss";

   # Construct complete message
   $FormattedMessage = "$CurrentDateTime $message";

   # Write the message to the screen
   write-host $FormattedMessage
}

######################################################################
#                                                                    #
# Function to display help context / application usage to the screen #
#                                                                    #
######################################################################

function WriteHelpToScreen
{
    $FormattedMessage = " ";
    write-host $FormattedMessage;
    $FormattedMessage = "Usage:";
    write-host $FormattedMessage;
    $FormattedMessage = " ";
    write-host $FormattedMessage;
    $FormattedMessage = "    ExtractReleaseHistory.ps1 -i <InputFile> -o <OutputFile> -n 1 -p <ProjectName> -v <Version>";
    write-host $FormattedMessage;
    $FormattedMessage = " ";
    write-host $FormattedMessage;
    $FormattedMessage = "        Where <InputFile> and <OutputFile> must be complete paths";
    write-host $FormattedMessage;
    $FormattedMessage = "        Where the number following the -n option is the number of sections to extract out";
    write-host $FormattedMessage;
    $FormattedMessage = "        Where the <ProjectName> is the name of the project";
    write-host $FormattedMessage;
    $FormattedMessage = "        Where the <Version> is the release number of the project";
    write-host $FormattedMessage;
    $FormattedMessage = " ";
    write-host $FormattedMessage;
 }
 
######################################################################
#                                                                    #
# Script Entry Point                                                 #
#                                                                    #
######################################################################

# Check if user requested help
if ($Help -or $h)
{
    write-host " ";
    WriteHelpToScreen;
    write-host " ";
    exit;
}

# Make sure user entered correct cmd line params
if ($szInputFile -eq "" -or $szOutputFile -eq "")
{
    $FormattedMessage = "Error: No input/output file provided";
    write-host $FormattedMessage;
    write-host " ";
    WriteHelpToScreen;
    exit;
}

# convert number of sections to int
try
{
    $iNumSections = [int32]::Parse($szNumSections);
}
catch
{
    LogMessage("      Parse Error - Invalid NumSections parameter");
    LogMessage("*** Error type  : $_.Exception.GetType().FullName");
    LogMessage("*** Error code  : $($_.Exception.ErrorCode)");
    LogMessage("*** Error text  : $($_.Exception.Message)");  
    exit;
}

# Write start message to log file
LogMessage(" ");
LogMessage("-------------------------------------------------------");
LogMessage(" ");
LogMessage("ExtractReleaseHistory.ps1");
LogMessage("Script to extract history info from history.txt file");
LogMessage(" ");
LogMessage("Date               : '$CurrentDateFormatted'");
LogMessage("Version            : '$ScriptVersion'");
LogMessage("Input File         : '$szInputFile'");
LogMessage("Output File        : '$szOutputFile'");
LogMessage("Num Sections       : '$iNumSections'");
LogMessage(" ");
LogMessage("-------------------------------------------------------");
LogMessage(" ");

# Code operation:
#
# Open the file
#
# Find the following string structure for the last entry:
#
#    Build 101
#    April 3rd, 2015
#    ---------------------------------------------------------------------------
#
# Extract the latest entry
#
# Save to output file
#

Set-Location $ScriptDir;

# Make sure the specified input file exists

if (!(Test-Path $szInputFile))
{
    LogMessage("ERROR:");
    LogMessage("***   Input file not found, exit");
    exit;
}

$szContents = "";

#Read in contents of file
$szContents = Get-Content $szInputFile | Out-String;

# Initialize

$iIndex1 = $szContents.Length;
$iIndex2 = 0;
$bFoundStart = 0;
$iSectionsFound = 0;

# Loop to find our search text

while ($iIndex1 -ge 0)
{
	# Get index of field name
	$iIndex1 = $szContents.LastIndexOf("Version ", $iIndex1);
	# make sure the field name was found
	if ($iIndex1 -eq -1)
	{
	    LogMessage("ERROR:");
        LogMessage("***   Last section could not be found (0), exit");
	    exit;
	}
    
    if ($szContents[$iIndex1 - 1] -ne "`n")
    {
        $iIndex1--;
        continue;
    }
	# Check to make sure this is the beginning line, if it is then 2 lines underneath
	# will be a dashed line consisting of $NumberOfDashesInVersionLine dash characters
	
	$iIndex2 = $szContents.IndexOf("`n", $iIndex1);
	# make sure the newline was found
	if ($iIndex2 -eq -1)
	{
	    LogMessage("ERROR:");
	    LogMessage("***   Last section could not be found (1), exit");
	    exit;
	}

	$iIndex2 = $szContents.IndexOf("`n", $iIndex2 + 1);
	# make sure the newline was found
	if ($iIndex2 -eq -1)
	{
	    LogMessage("ERROR:");
        LogMessage("***   Last section could not be found (2), exit");
	    exit;
	}
	
	#increment index2 past new line and on to 1st ch in next line
	$iIndex2++;

	# Now $iIndex2 should be the index to the start of a dashed line
	
	$numdashes = 0;
	for ($numdashes = 0; $numdashes -lt $iNumberOfDashesInVersionLine; $numdashes++)
	{
	    if ($szContents[$iIndex2 + $numdashes] -ne '-')
	    {
	       break;
	    }
	}
	
	# make sure we found our dashed line
	if ($numdashes -eq $iNumberOfDashesInVersionLine)
	{
	   $bFoundStart = 1;
	   $iSectionsFound++;
	   if ($iSectionsFound -ge $iNumSections)
	   {
	       break;
	   }
	}
	
	# decrement $iIndex1, which is the index to the start of the string "Build ", but
	# this could have occurred in the body of the text, keep searching
	$iIndex1--;
}

# make sure we found our starting point  
if ($bFoundStart -eq 0)
{
    LogMessage("      Last section could not be found (D:$numdashes), exit");
    exit;
}

# Style the contents to monospace font
$szContents = $szContents.Substring($iIndex1);

$szContents = $szContents.Replace("&", "&amp;");
# Replace '<' and '>' with 'lt;' and 'gt;'
$szContents = $szContents.Replace("<", "&lt;");
$szContents = $szContents.Replace(">", "&gt;");
# Replace spaces with &nbsp;
$szContents = $szContents.Replace(" ", "&nbsp;");
$szContents = $szContents.Replace("`r`n", "<br>");

$szContents = "<font face=`"Courier New`">" + $szContents + "</font>"

# $iIndex1 is our start index

$szFinalContents = "<b>$project Version $version has been released.</b><br><br>";
#$szFinalContents += "Release Location: <a href='\\192.168.68.120\d$\SoftwareImages\$project\$version'>\\192.168.68.120\d$\SoftwareImages\$project\$version</a><br><br>";

if (Test-Path "\\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version")
{
    $szFinalContents += "Release Location: \\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version<br><br>";
}
else
{
    $szFinalContents += "Release Location: \\192.168.68.120\d$\SoftwareImages\$project\$version<br><br>";
}

if (Test-Path "\\192.168.68.120\d$\SoftwareImages\$project\$version\history.txt")
{
    $szFinalContents += "Complete History: \\192.168.68.120\d$\SoftwareImages\$project\$version\history.txt<br><br>";
}
elseif (Test-Path "\\192.168.68.120\d$\SoftwareImages\$project\$version\doc\history.txt")
{
    $szFinalContents += "Complete History: \\192.168.68.120\d$\SoftwareImages\$project\$version\doc\history.txt<br><br>";
}
elseif (Test-Path "\\192.168.68.120\d$\SoftwareImages\$project\$version\documentation\history.txt")
{
    $szFinalContents += "Complete History: \\192.168.68.120\d$\SoftwareImages\$project\$version\documentation\history.txt<br><br>";
}
elseif (Test-Path "\\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version\history.txt")
{
    $szFinalContents += "Complete History: \\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version\history.txt<br><br>";
}
elseif (Test-Path "\\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version\doc\history.txt")
{
    $szFinalContents += "Complete History: \\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version\doc\history.txt<br><br>";
}
elseif (Test-Path "\\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version\documentation\history.txt")
{
    $szFinalContents += "Complete History: \\192.168.68.120\d$\SoftwareImages\Scripts\$project\$version\documentation\history.txt<br><br>";
}
else
{
    $szFinalContents += "Complete History: \\192.168.68.120\d$\SoftwareImages\$project\$version\history.txt<br><br>";
}

$szFinalContents += "Most Recent Entry:<br><br>";

if ($listonly -eq $false)
{
    $szFinalContents += $szContents;
}
else
{
    $iIndex1 = $szContents.IndexOf("*");
    while ($iIndex1 -ne -1)
    {
        $iIndex2 = $szContents.IndexOf("<br>", $iIndex1);
        $szContents = $szContents.Substring(0, $iIndex1) + $szContents.Substring($iIndex2 + 4);
        $iIndex1 = $szContents.IndexOf("*");
    }
    $szFinalContents = "<font face=`"Courier New`">" + $szContents + "</font>"
}

# Reverse versions display newest at top if more than 1 section
if ($iNumSections -gt 1)
{    
    $sections = @();
    
    $iIndex2 = $szContents.IndexOf(">Version&nbsp;", 0) + 1;
    for ($i = 0; $i -lt $iNumSections; $i++)
    {
        $iIndex1 = $iIndex2 ;
        $iIndex2 = $szContents.IndexOf(">Version&nbsp;", $iIndex1 + 1) + 1;
        if ($iIndex2 -eq 0)
        {
            $iIndex2  = $szContents.IndexOf("</font>");
        }
        #LogMessage($iIndex1);
        #LogMessage($iIndex2);
        #LogMessage($szContents.Substring($iIndex1, $iIndex2 - $iIndex1));
        $sections += $szContents.Substring($iIndex1, $iIndex2 - $iIndex1);
    }  
    $szContents = "";  
    for ($i = $iNumSections - 1; $i -ge 0; $i--)
    {
        $szContents += $sections[$i];
        if ($szContents.Substring($szContents.Length - 12) -ne "<br><br><br>")
        {
            $szContents += "<br>";
        }
    }
    $szFinalContents = "<font face=`"Courier New`" style=`"font-size:12px`">" + $szContents + "</font>"
}

# Write file
out-file -filepath $szOutputFile -Encoding "ASCII" -Append -inputobject $szFinalContents

LogMessage("Successfully saved output to $szOutputFile");
LogMessage("Done");

