# Organize-Photos.ps1 
# Version 0.5
# Designed for powershell 5.1
# Copyright 2017 - Joshua Porrata
# Not for business use without an inexpensive license, contact 
# Localbeautytampabay@gmail.com for questions about a lisence 
# there is no warranty, This might destroy everything it touches. 

Class OrganizePhotos {
    [string]$OriginPath;
    [string]$DestPath;
    $PathsList;
    [hashtable]$ObjectHolder;
    [string]$FileName;
    [string]$FileType;
    [string]$SourcePath;
    [string]$CreatedDate;
    [string]$CreatedTargetPath;
    [string]$ModifiedDate;
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
    [array] GetObjectsFlat () {
        if ($This.OriginPath.Equals("Default")) {
            Throw "The SourceRootDirectory Is set to default";
        }
        else {
            $This.PathsList = Get-ChildItem -file -Path $This.OriginPath;
            $This.PathsList = $This.PathsList.FullName;
            return $This.PathsList;
        }
    }
    [array] GetObjectsRecurse () {
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
        $Temp = Get-ChildItem -File -Path $SourcePath -ErrorAction SilentlyContinue;
        $This.FileName = $Temp.Name;
        $This.FileType = $Temp.Extension;
        $This.SourcePath = $Temp.FullName;
        $This.CreatedDate = $Temp.CreationTime.ToString("MM-dd-yyyy");
        #$This.CreatedDate = $This.CreatedDate.Replace("/", "-");
        $This.CreatedTargetPath = Join-Path -Path $This.DestPath -ChildPath $This.CreatedDate;
        $This.ModifiedDate = $Temp.LastWriteTime.ToString("MM-dd-yyyy");
        #$This.ModifiedDate = $This.ModifiedDate.Replace("/", "-");
        $This.ModifiedTargetPath = Join-Path -Path $This.DestPath -ChildPath $This.ModifiedDate;
        $This.ObjectHolder = [ordered] @{
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
        $FileNames = $This.getObjectsFlat();
        $simObject = @();
        foreach ($FileName in $FileNames) {
            $looper = $This.CollectObjectInfo($FileName);
            $Row = New-Object PSObject
            $Row | Add-Member -MemberType NoteProperty -Name "FileName" -Value $looper.FileName;
            $Row | Add-Member -MemberType NoteProperty -Name "FileType" -Value $looper.FileType;
            $Row | Add-Member -MemberType NoteProperty -Name "CreatedDate" -Value $looper.CreatedDate;
            $Row | Add-Member -MemberType NoteProperty -Name "ModifiedDate" -Value $looper.ModifiedDate;
            $simObject += $Row;
        }
        $simObject | Export-Csv -Path test.csv -NoTypeInformation -Encoding UTF8
    }
}