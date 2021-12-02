function isExcluded([string][Required] $word){
    $present = $false;

    if($null -ne $excludedWords){
        if($true -eq $excludedWords.Contains($word)){
            $present = $true;
            return $present;
        }
    }

    if($null -ne $excludedWordsFiles){
        for($i = 0; $i -lt $excludedWordsFiles.Length; ++$i){
            if($(Test-Path -Path $excludedWordsFiles[$i]) -eq $false){
                if($quiet -is $null -or $quiet -eq $false){
                    Write-Error -Message $("No file " + $excludedWordsFiles[$i]);
                }
            }
            else {
                if($(readTextFile($excludedWordsFiles[$i], $true)).Contains($word) -eq $true){
                    $present = $true;
                    return $present;
                }
            }
        }
    }

    return $present;
}

function count([array] $array, [string] $word){
    $amount = 0;

    for($i = 0; $i -lt $array.Length; ++$i){
        $numberOfArrays = $array[$i].PlainContent.Split($word);

        if($numberOfArrays -gt 1){
            $amount += ($numberOfArrays / 2);
        }
    }

    return $amount;
}

function getWords([array] $array){
    $words = @();

    for($i = 0; $i -lt $array.Length; ++$i){
        $splitted = $array[$i].PlainContent.Split(' ');

        for($j = 0; $j -lt $splitted.Length; ++$j){
            if(-not (isExcluded($splitted[$j]))){
                if(-not ($words.Contains($splitted[$j]))){
                    $words.Add($splitted[$j]);
                }
            }
        }
    }

    return $words;
}

function prepareCSV([System.Array] $array, [string] $saveFile){
    $words = getWords($array);
    saveTextFile($saveFile, "", "w");

    for($i = 0; $i -lt $words.Length; ++$i){
        saveTextFile($saveFile, $("{0},{1}" -f $words[$i],$(count($words[$i]))));
    }
}