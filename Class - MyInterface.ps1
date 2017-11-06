# Class - MyInterFace.ps1 
# Version 0.8
# Designed for powershell 5.1
# Copyright 2017 - Joshua Porrata
# Not for business use without an inexpensive license, contact 
# Localbeautytampabay@gmail.com for questions about a lisence 
# there is no warranty, This might destroy everything it touches. 

class MyInterface {
    [string]$SourceDirectory;
    [string]$DestinationRoot;
    [string]$MoveCopy;
    [string]$DateType;
    hidden [boolean]$RUN;
    [OrganizePhotos]$OrganizePhotos;
    $JsonImport;
    $Jsonerror;
    $GetHash;
    $Recurse;

    MyInterface() {
        [string]$This.SourceDirectory = "Default";
        [String]$This.DestinationRoot = "Default";
        [String]$This.MoveCopy = "Default";
        [Boolean]$This.RUN = $true;
        [String]$This.DateType = "Default";
        [OrganizePhotos]$This.OrganizePhotos = [OrganizePhotos]::new();
        $This.Jsonerror = "Default";
        $This.Jsonerror;
        $This.InitialImport();
    }

    [void] Print ([string]$color, [string]$Text) {
        if ($color.Equals("")) {
            Write-Host $Text -ForegroundColor White
        }
        else {
            Write-Host $Text -ForegroundColor $color
        }   
    }

    [void] DisplayStatus () {
        Clear-Host
        $This.Print("Green", '*' * 80);
        if ($This.SourceDirectory.Equals("Default")) {
            $This.Print("Red", "`n" + "You must select a source directory.")
        }
        else {
            $This.Print("Green", "`n" + "The Current source directory is: " + $This.SourceDirectory);
        }
        if ($This.DestinationRoot.Equals("Default")) {
            $This.Print("Red", "You must select a destination directory.")
        }
        else {
            $This.Print("Green", "The Current destination directory is: " + $This.DestinationRoot);
        }
        if ($This.DateType.Equals("Default")) {
            $This.Print("Red", "You must select an organization parameter(by Creation or Modified date).")
        }
        else {
            $This.Print("Green", "Files will be organized by: " + $This.DateType);
        }
        if ($This.MoveCopy.Equals("Default")) {
            $This.Print("Red", "You must select whether the files will be moved or copied." + "`n")
        }
        else {
            $This.Print("Green", "Files will be: " + $This.MoveCopy + "");
        }
        $This.Print("Green", "Recurse through folder: " + $This.Recurse);
        $This.Print("Green", "Get File Hash: " + $This.GetHash + "`n");
        $This.Print("green", '*' * 80);
    }

    [void] ShowMenu () {
        $This.Print("", "")
        $This.Print("", "*" * 55)
        $This.Print("", "Make a selection below")
        $This.Print("", "*" * 55)
        $This.Print("", "1. Select a source directory")
        $This.Print("", "2. Select a destination directory")
        $This.Print("", "3. Select creation date or last modified date")
        $This.Print("", "4. Select whether to Copy or Move the files")
        $This.Print("", "5. Show dates of files (Recommended before proceeding)")
        $This.Print("", "6. Run script")
        $This.Print("", "7. Import From ./OP-Settings.JSON")
        $This.Print("", "X. Quit")
        $This.Print("", "*" * 55)
    }

    [void] Main () {
        while ($This.RUN) {
            $This.displayStatus();
            $This.showMenu();
            $command = Read-Host "Make a Selection: "
            Switch ($command) {
                1 {$This.SetSourceRoot(); }
                2 {$This.SetDestRoot(); }
                3 {$This.SelectSortType(); }
                4 {$This.SelectCopyMove(); }
                5 {$This.ExportData(); }
                6 {$This.RunScript(); }
                7 {$This.ImportSettings(); }
                "x" {$This.RUN = $false; } 
                default {
                    $This.Print("red", "The command you entered is not valid, please check the available commands and try again!");
                    Start-Sleep -Seconds 1;
                }
            }
        }
    }

    [void] SetSourceRoot () {
        $This.Print("", "Enter the full path to the directory from which you would like to copy or move files: ");
        $This.SourceDirectory = Read-Host
        if ($This.OrganizePhotos.SetSourcePath($This.SourceDirectory)) {
            $This.Print("green", "source Folder Set Successfully");
        }
        else {
            $This.Print("red", "The Source Folder is Invalid");
            Start-Sleep -Seconds 1
            Read-Host
            $This.SourceDirectory = "Default";
        }
    }

    [void] SetDestRoot () {
        $This.Print("", "Enter the full path to the root of the directory files should be moved to: ");
        $This.DestinationRoot = Read-Host;
        if ($This.OrganizePhotos.SetDestinationPath($This.DestinationRoot)) {
            $This.Print("green", "Destination Folder Set Successfully")
        }
        else {
            $This.Print("red", "The destination folder is invalid");
            Start-Sleep -Seconds 1
            $This.DestinationRoot = "Default";
        }  
    }

    [void] SelectSortType () {
        $This.Print("", "Enter 1 to organize by creation date and 2 to organize by last modified date.");
        $Selection = Read-Host;
        Switch ($Selection) {
            1 {
                $This.DateType = "creation";
            }
            2 {
                $This.DateType = "modified";
            }
            Default {
                $This.Print("Red", "You entered $Selection which is an invalid Selection");
                Start-Sleep -Seconds 1
                $This.DateType = "Default";
            }
        }
    }

    [void] SelectCopyMove() {
        $This.Print("", "Enter 1 to Copy files and 2 To Move files")
        $Selection = Read-Host;
        switch ($Selection) {
            1 {
                $This.MoveCopy = "copy";
            }
            2 {
                $This.MoveCopy = "move"; 
            }
            default {
                $This.Print("Red", "You entered $Selection which is an invalid Selection");
                Start-Sleep -Seconds 1;
                $This.MoveCopy = "Default";
            }
        }
    }

    [void] ExportData() {
        $This.OrganizePhotos.ExportReport($This.GetHash);
        $This.Print("", "Please Check Test.csv in the same folder where This script was RUN before proceeding");
        Start-Sleep -Seconds 3
    }

    [void] RunScript() {
        try {
            $FileNames = $This.OrganizePhotos.getObjectsFlat();
            foreach ($File in $FileNames) {
                $Looper = $This.OrganizePhotos.CollectObjectInfo($file, $false);
                Switch ($This.MoveCopy) {
                    "move" {
                        #Switch 1 determines if the file will be copied or moved
                        Switch ($This.DateType) {
                            "creation" {
                                #Switch 2 determines if the created or modified date will be used to organize
                                switch ($Looper.FileType.Equals(".dng")) {
                                    $True { $This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.RawCreateTargetPath); }
                                    Default {$This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.CreatedTargetPath); }
                                }
                            }
                            "modified" {
                                #Switch 2 determines if the created or modified date will be used to organize
                                switch ($Looper.FileType.Equals(".dng")) {
                                    $True { $This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.RawModTargetPath); }
                                    Default {$This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.ModifiedTargetPath); }
                                }
                            }
                            default {
                                $This.Print("Red", "While evauluating the Creation/Modified switch within the Move Switch Block, there was an error that resulted in the default Switch being triggered.");
                            } 
                        }
                    }
                    "copy" {
                        #Switch 1 determines if the file will be copied or moved
                        Switch ($This.DateType) {
                            "creation" {
                                #Switch 2 determines if the created or modified date will be used to organize
                                switch ($Looper.FileType.Equals(".dng")) {
                                    $True { $This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.RawCreateTargetPath); }
                                    Default {$This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.CreatedTargetPath); }
                                }
                            }
                            "modified" {
                                #Switch 2 determines if the created or modified date will be used to organize
                                switch ($Looper.FileType.Equals(".dng")) {
                                    $True { $This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.RawModTargetPath); }
                                    Default {$This.OrganizePhotos.MoveFile($Looper.SourcePath, $Looper.ModifiedTargetPath); }
                                }
                            }
                            default {
                                #Switch 2 determines if the created or modified date will be used to organize
                                $This.Print("Red", "While evauluating the Creation/Modified switch within the Copy Switch Block, there was an error that resulted in the default Switch being triggered.");
                            } 
                        }
                    }
                    default {
                        $This.Print("Red", "While evauluating the Move/Copy Switch there was an error that resulted in the default Switch being triggered.");
                    }
                }
            }
            
        }
        catch {
            $This.Print("red", "An error in the RunScript Method has triggered the catch block. Please Check the Error variables.");
            Start-Sleep -Seconds 1
        }
        finally {
            $This.Print("", "The RunScript method has completed.")
            Start-Sleep -Seconds 1 
        }
    }

    [void] InitialImport() {
        $This.ImportSettings();
    }

    [void] ShowStatus () {
        This.Print("", $This.SourceDirectory);
        This.Print("", $This.DestinationRoot );
        This.Print("", $This.MoveCopy);
        This.Print("", $This.DateType);
        This.Print("", $This.GetHash);
        This.Print("", $This.Recurse);
        This.Print("", "Press enter to return to the main menu");
        Read-Host
    }

    [void] ImportSettings () {
        try {
            if (Test-Path -Path ./OP-Settings.json) {
                $This.JsonImport = Get-Content -Path ./OP-Settings.json -ErrorVariable $This.Jsonerror;
                $This.JsonImport = $This.JsonImport | ConvertFrom-Json -ErrorVariable $This.Jsonerror;
                $This.OrganizePhotos.SetSourcePath($This.JsonImport.SourceRoot.ToString());
                $This.SourceDirectory = $This.JsonImport.SourceRoot.ToString();
                $This.OrganizePhotos.SetDestinationPath($This.JsonImport.DestRoot.ToString());
                $This.DestinationRoot = $This.JsonImport.DestRoot.ToString();
                $This.MoveCopy = $This.JsonImport.CopyMove.ToString();
                $This.DateType = $This.JsonImport.CreationModified.ToString();
                [bool]$This.GetHash = $This.JsonImport.GetHash;
                [bool]$This.Recurse = $This.JsonImport.Recurse;
            }
            else {
                $This.Print("Yellow", "Could not find ./OP-Settings.json");
            }
        }
        catch {
            $This.Print("Red", "You caught the catch block");
            $This.Jsonerror;
            Start-Sleep -Seconds 1
        }
        finally {
            $This.Print("yellow", "When importing the source and destination are assumed to be known working paths and are not checked. Please double Check");
            Start-Sleep -Seconds 3 
        }
    }
}