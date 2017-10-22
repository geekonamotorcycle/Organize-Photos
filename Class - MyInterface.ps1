class myInterface {
    [string]$sourceDirectory;
    [string]$destinationRoot;
    [string]$moveCopy;
    [string]$dateType;
    hidden [boolean]$run;

    myInterface() {
        [String]$This.sourceDirectory = "Default";
        [String]$This.destinationRoot = "Default";
        [String]$This.moveCopy = "Default";
        [Boolean]$This.run = $true;
        [string]$This.dateType = "Default";
    }

    [void] print ([string]$color, [string]$text) {
        if ($color.Equals("")) {
            Write-Host $text -ForegroundColor White
        }
        else {
            Write-Host $text -ForegroundColor $color
        }
        
    }
    
    [void] displayStatus () {
        Clear-Host
        $This.print("green", "********************************************************************************`n");
        if ($This.sourceDirectory.Equals("Default")) {
            $This.print("red", "You must select a source directory.")
        }
        else {
            $This.print("green", "The Current source directory is: " + $This.sourceDirectory);
        }
        if ($This.destinationRoot.Equals("Default")) {
            $This.print("red", "You must select a destination directory.")
        }
        else {
            $This.print("green", "The Current destination directory is: " + $This.destinationRoot);
        }
        if ($This.dateType.Equals("Default")) {
            $This.print("red", "You must select an organization parameter(by Creation or Modified date).")
        }
        else {
            $This.print("green", "Files will be organized by: " + $This.dateType);
        }
        if ($This.moveCopy.Equals("Default")) {
            $This.print("red", "You must select whether the files will be moved or copied.")
        }
        else {
            $This.print("green", "Files will be: " + $This.moveCopy);
        }
        $This.print("green", "`n********************************************************************************");

    }
    
    [void] showMenu () {
        $This.print("", "")
        $This.print("", "******************************************")
        $This.print("", "MAKE A SELECTION BELOW")
        $This.print("", "******************************************")
        $This.print("", "1. Select a source directory")
        $This.print("", "2. Select a destination directory")
        $This.print("", "3. Select creation date or last modified date")
        $This.print("", "4. Select whether to move or copy the files")
        $This.print("", "5. Show dates of files (Recommended before proceeding)")
        $This.print("", "6. Run script")
        $This.print("", "7. Quit")
        $This.print("", "******************************************`n")
    }

    [void] Main() {
        [OrganizePhotos] $OrganizePhotos = [OrganizePhotos]::New();
        while ($This.run) {
            $This.displayStatus();
            $This.showMenu();
            $command = read-host "Make a Selection: "
            if ($command.Equals("7")) {
                $This.run = $false;
            }
            elseif ($command.Equals("1")) {
                $This.print("", "Enter the full path to the directory from which you would like to copy or move files: ");
                $This.sourceDirectory = Read-Host;
                if ($OrganizePhotos.SetSourcePath($This.sourceDirectory)) {
                    $This.print("green", "source Folder Set Successfully");
                }
                else {
                    $This.print("red", "The Source Folder is Invalid");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.sourceDirectory = "Default";
                }  
            }
            elseif ($command.Equals("2")) {
                $This.print("", "Enter the full path to the root of the directory files should be moved to: ");
                $This.destinationRoot = Read-Host;
                if ($OrganizePhotos.SetDestinationPath($This.destinationRoot)) {
                    $This.print("green", "Destination Folder Set Successfully")
                }
                else {
                    $This.print("red", "The destination Folder is Invalid");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.destinationRoot = "Default";
                }  
            }
            elseif ($command.Equals("3")) {
                $This.print("", "Enter 1 to organize by creation date and 2 to organize by last modified date.");
                $selection = Read-Host;
                if ($selection.Equals("1")) {
                    $This.dateType = "creation";
                }
                elseif ($selection.Equals("2")) {
                    $This.dateType = "modified";
                }
                else {
                    $This.print("Red", "You entered $selection which is an invalid selection");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.dateType = "Default";
                }
            }
            elseif ($command.Equals("4")) {
                $This.print("", "Enter 1 to COPY files and 2 To MOVE files")
                $selection = Read-Host;
                if ($selection.Equals("1")) {
                    $This.moveCopy = "copy";
                }
                elseif ($selection.Equals("2")) {
                    $This.moveCopy = "move";
                }
                else {
                    $This.print("Red", "You entered $selection which is an invalid selection");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.moveCopy = "Default";
                }
            }
            elseif ($command.Equals("5")) {
                $OrganizePhotos.showDates();
                $This.print("", "Please Check Test.csv in the same folder where this script was run before proceeding");
                $This.print("", "Press Enter to the returned to the main Menu")
                Read-Host
            }
            elseif ($command.Equals("6")) {
                if ($This.moveCopy.Equals("Default") -or $This.destinationRoot.Equals("Default") -or $this.moveCopy.Equals("Default") -or $This.sourceDirectory.Equals("Default") ) {
                    $This.print("red", "A required Paramaeter wasnot set, please try again.");
                    $This.print("", "Press enter to return to the main menu");
                    Read-Host
                }
                else {
                    if ($This.moveCopy.Equals("copy")) {
                        if ($This.dateType.Equals("creation")) {
                            $Filenames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $Filenames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.CopyFile($looper.SourcePath, $looper.CreatedTargetPath);
                            }
                            $This.print("", "The Script Was Run. Please check the destination folder")
                            $This.print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                        elseif ($This.dateType.Equals("modified")) {
                            $Filenames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $Filenames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.copyFile($looper.SourcePath, $looper.ModifiedTargetPath);
                            }
                            $This.print("", "The Script Was Run. Please check the destination folder")
                            $This.print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                    }
                    elseif ($This.moveCopy.Equals("move")) {
                        if ($This.dateType.Equals("creation")) {
                            $Filenames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $Filenames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.MoveFile($looper.SourcePath, $looper.CreatedTargetPath);
                            }
                            $This.print("", "The Script Was Run. Please check the destination folder")
                            $This.print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                        elseif ($This.dateType.Equals("modified")) {
                            $Filenames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $Filenames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.MoveFile($looper.SourcePath, $looper.ModifiedTargetPath);
                            }
                            $This.print("", "The Script Was Run. Please check the destination folder")
                            $This.print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                    }
                }
            }
            else {
                $This.run = $true;
            }
                
        }

    }
}