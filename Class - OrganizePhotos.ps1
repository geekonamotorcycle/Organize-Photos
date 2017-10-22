Class OrganizePhotos {
    [string]$OriginPath;
    [string]$DestPath;
    $PathsList;
    [hashtable]$ObjectHolder;
    [string]$FileName;
    [string]$FileType;
    [string]$SourcePath;
    [string]$createdDate;
    [string]$CreatedTargetPath;
    [string]$modifiedDate;
    [string]$ModifiedTargetPath;
    [string]$FileHash

    OrganizePhotos() {
        $This.OriginPath = "Default";
        $This.DestPath = "Default";
        $This.PathsList = @();
        $This.ObjectHolder = [ordered] @{
            "FileName"           = "";
            "FileType"           = "";
            "SourcePath"         = "";
            "CreatedDate"        = "";
            "CreatedTargetPath"  = "";
            "ModifiedDate"       = "";
            "ModifiedTargetPath" = "";
            "FileHash"           = "";
        }
        $This.FileName = "Default";
        $This.FileType = "Default";
        $This.SourcePath = "Default";
        $This.CreatedDate = "Default";
        $This.CreatedTargetPath = "Default";
        $This.ModifiedDate = "Default";
        $This.ModifiedTargetPath = "Default";
        $This.FileHash = "Default";
    }
    [Boolean] SetSourcePath ([string]$newSourcePath) {
        if (Test-Path -Path $newSourcePath) {
            $This.OriginPath = $newSourcePath;
            return $true;
        }
        else {
            return $false
        }
    }
    [bool] SetDestinationPath ([string]$newDestinationPath) {
        if (Test-Path -Path $newDestinationPath) {
            $This.DestPath = $newDestinationPath;
            return $true;
        }
        else {
            return $false;
        }
    }
    [array] getObjectsFlat () {
        if ($This.OriginPath.Equals("Default")) {
            Throw "The SourceRootDirectory Is set to default";
        }
        else {
            $This.PathsList = Get-ChildItem -file -Path $This.OriginPath;
            $This.PathsList = $This.PathsList.FullName;
            return $This.PathsList;
        }
    }
    [array] getObjectsRecurse () {
        if ($This.OriginPath.Equals("Default")) {
            Throw "The SourceRootDirectory Is set to default";
        }
        else {
            $This.PathsList = Get-ChildItem -file -Path $This.OriginPath -Recurse;
            $This.PathsList = $This.PathsList.FullName;
            return $This.PathsList;
        }
    }
    [hashtable] CollectObjectInfo ([string]$SourcePath) {
        $temp = Get-ChildItem -File -Path $SourcePath -ErrorAction SilentlyContinue;
        $This.fileName = $temp.Name;
        $This.filetype = $temp.Extension;
        $This.SourcePath = $temp.FullName;
        $This.createdDate = $temp.CreationTime.ToShortDateString();
        $This.createdDate = $This.createdDate.Replace("/", "-");
        $This.CreatedTargetPath = Join-Path -Path $This.DestPath -ChildPath $This.createdDate;
        $This.modifiedDate = $temp.LastWriteTime.ToShortDateString();
        $This.modifiedDate = $This.modifiedDate.Replace("/", "-");
        $This.ModifiedTargetPath = Join-Path -Path $This.DestPath -ChildPath $This.modifiedDate;
        $This.objectHolder = [ordered] @{
            "FileName"           = $This.FileName;
            "FileType"           = $This.FileType;
            "SourcePath"         = $This.SourcePath;
            "CreatedDate"        = $This.CreatedDate;
            "CreatedTargetPath"  = $This.CreatedTargetPath;
            "ModifiedDate"       = $This.ModifiedDate;
            "ModifiedTargetPath" = $This.ModifiedTargetPath;
            "FileHash"           = "Default";
        }
        return $This.ObjectHolder;
    }
    [void] CopyFile ([string]$SourcePath, [string]$DestinationDirectory) {
        [string]$CompleteDest = Join-Path -Path $DestinationDirectory -ChildPath $This.FileName
        if (Test-Path -Path $DestinationDirectory) {
            Copy-Item -Path $SourcePath -Destination $DestinationDirectory
            
        }
        else {
            New-Item -ItemType Directory -Path $DestinationDirectory
            Copy-Item -Path $SourcePath -Destination $DestinationDirectory
            
        }
        if (Test-Path -Path $CompleteDest) {
            $This.ObjectHolder.Add("Success" , $true);    
        }
        else {
            $This.ObjectHolder.Add("Success" , $false);
        }
        
    }
    [void] MoveFile ([string]$SourcePath, [string]$DestinationDirectory) {
        [string]$CompleteDest = Join-Path -Path $DestinationDirectory -ChildPath $This.FileName
        if (Test-Path -Path $DestinationDirectory) {
            Move-Item -Path $SourcePath -Destination $DestinationDirectory
            
        }
        else {
            New-Item -ItemType Directory -Path $DestinationDirectory
            Move-Item -Path $SourcePath -Destination $DestinationDirectory
            
        }
        if (Test-Path -Path $CompleteDest) {
            $This.ObjectHolder.Add("Success" , $true);    
        }
        else {
            $This.ObjectHolder.Add("Success" , $false);
        }
        
    }
    [void] ShowDates() {
        $filenames = $This.getObjectsFlat();
        $simObject = @();
        foreach ($filename in $filenames) {
            $looper = $This.CollectObjectInfo($filename);
            $row = New-Object PSObject
            $row | Add-Member -MemberType NoteProperty -Name "FileName" -Value $looper.FileName;
            $row | Add-Member -MemberType NoteProperty -Name "FileType" -Value $looper.FileType;
            $row | Add-Member -MemberType NoteProperty -Name "CreatedDate" -Value $looper.CreatedDate;
            $row | Add-Member -MemberType NoteProperty -Name "ModifiedDate" -Value $looper.ModifiedDate;
            $simObject += $row;
        }
        $simObject | Export-Csv -Path test.csv -NoTypeInformation -Encoding UTF8
    }
}