[CmdletBinding()]
param (
    # Specifies a path to one location.
    [Parameter(Mandatory = $true,
        Position = 0,
        ValueFromPipeline = $false,
        ValueFromPipelineByPropertyName = $true,
        HelpMessage = "Path to file location.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string]
    $inputFile,
    [Parameter(Position = 1)][string] $fileFormat,
    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$false,
               Position=2,
               ParameterSetName="ExcludedWordsFiles",
               ValueFromPipeline=$false,
               ValueFromPipelineByPropertyName=$true,
               HelpMessage="Path to one or more files with excluded words.")]
    [Alias("PSPath")]
    [string[]]
    $excludedWordsFiles,
    [Parameter(Mandatory = $false, Position = 3, ParameterSetName="ExcludedWords",
               ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true,
               HelpMessage = "List of excluded words")][string[]]$excludedWords,
    [Parameter][switch]$quiet
)

. ./fileOperations.ps1

$data = fileLoader($inputFile, $fileFormat);

if($null -eq $data){
	throw "No data.";
	exit;
}

./counter.ps1

prepareCSV($data, $inputFile + ".words.csv");