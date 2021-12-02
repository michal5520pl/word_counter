#region textFiles

function saveTextFile([String] $file, $data, $mode = "a"){
    if($mode -ieq "a"){
        return $($data | Add-Content -Path $file);
    }
    elseif($mode -ieq "w"){
        return $($data | Set-Content -Path $file);
    }
    else {
        throw "Unknown mode! Exiting.";
        exit;
    }
}

function readTextFile([String] $file, [bool] $raw = $false){
    checkIfExists($file);

    if($raw){
        return Get-Content -Path $file -Raw;
    }
    else {
        return Get-Content -Path $file;
    }
}

#endregion textFiles

#region RTFiles

function checkFormat([string] $inputFile){
    # Check if it is XLS
    if($inputFile -ilike "*.xls"){
        return "xls";
    }
    
    # Check if it is XLSX
    if($inputFile -ilike "*.xlsx"){
        return "xlsx";
    }

    # Check if it is CSV
    if($inputFile -ilike "*.csv"){
        return "csv";
    }
}

function loadExcel([string] $inputFile){
    #Requires -Module ImportExcel

    # Import Excel worksheet from RequestTracker
    $inputData = Import-Excel $inputFile -WorksheetName "result";
    
    # If $inputData was imported successfully...
    if(($inputData.getType().BaseType -eq "System.Array") -and ($inputData.Length -gt 0)){
		# ...then if there is no PlainContent column, throw an error
		if($inputData[0].PlainContent -is $null){
			throw "No PlainContent column found. Exiting.";
			exit;
		}
		
        # return all rows
        return $inputData;
	}
	else {
		# ...else exit the script
		throw "File is incorrect. Exiting.";
		exit;
	}
}

#endregion RTFiles

#region allFiles

function checkIfExists([String] $inputPath){
    if($(Get-ChildItem -Path $inputPath -File).Length -ne 1){
        throw "No file!";
        exit;
    }
}

function fileLoader([string] $inputFile, [AllowNull][string] $fileFormat){
    # Check if there is the file
    checkIfExists($inputFile);

    # Check if user gave the file format
    if($fileFormat -eq $null){
        # If not, execute checkFormat
        checkFormat($inputFile);
    }

    # ***********************

    if($fileFormat -like "xls*"){
        return loadExcel($inputFile);
    }
    elseif($fileFormat -like "csv"){
        throw "We don't support CSV yet.";
        exit;
    }
}

#endregion allFiles