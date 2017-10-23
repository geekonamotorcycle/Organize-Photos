# Organize-Photos.ps1 
# Version 0.5
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

    MyInterface() {
        [String]$This.SourceDirectory = "Default";
        [String]$This.DestinationRoot = "Default";
        [String]$This.MoveCopy = "Default";
        [Boolean]$This.RUN = $true;
        [string]$This.DateType = "Default";
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
        $This.Print("green", '*'*80);
        if ($This.SourceDirectory.Equals("Default")) {
            $This.Print("red", "`n" + "You must select a source directory.")
        }
        else {
            $This.Print("green", "`n" +"The Current source directory is: " + $This.SourceDirectory);
        }
        if ($This.DestinationRoot.Equals("Default")) {
            $This.Print("red", "You must select a destination directory.")
        }
        else {
            $This.Print("green", "The Current destination directory is: " + $This.DestinationRoot);
        }
        if ($This.DateType.Equals("Default")) {
            $This.Print("red", "You must select an organization parameter(by Creation or Modified date).")
        }
        else {
            $This.Print("green", "Files will be organized by: " + $This.DateType);
        }
        if ($This.MoveCopy.Equals("Default")) {
            $This.Print("red", "You must select whether the files will be moved or copied." + "`n")
        }
        else {
            $This.Print("green", "Files will be: " + $This.MoveCopy + "`n");
        }
        $This.Print("green", '*' * 80);

    }

    [void] ShowMenu () {
        $This.Print("", "")
        $This.Print("", "*"*55)
        $This.Print("", "Make a selection below")
        $This.Print("", "*"*55)
        $This.Print("", "1. Select a source directory")
        $This.Print("", "2. Select a destination directory")
        $This.Print("", "3. Select creation date or last modified date")
        $This.Print("", "4. Select whether to move or copy the files")
        $This.Print("", "5. Show dates of files (Recommended before proceeding)")
        $This.Print("", "6. Run script")
        $This.Print("", "7. Quit")
        $This.Print("", "*"*55)
    }

    [void] Main() {
        [OrganizePhotos] $OrganizePhotos = [OrganizePhotos]::New();
        while ($This.RUN) {
            $This.displayStatus();
            $This.showMenu();
            $command = read-host "Make a Selection: "
            if ($command.Equals("7")) {
                $This.RUN = $false;
            }
            elseif ($command.Equals("1")) {
                $This.Print("", "Enter the full path to the directory from which you would like to copy or move files: ");
                $This.SourceDirectory = Read-Host;
                if ($OrganizePhotos.SetSourcePath($This.SourceDirectory)) {
                    $This.Print("green", "source Folder Set Successfully");
                }
                else {
                    $This.Print("red", "The Source Folder is Invalid");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.SourceDirectory = "Default";
                }  
            }
            elseif ($command.Equals("2")) {
                $This.Print("", "Enter the full path to the root of the directory files should be moved to: ");
                $This.DestinationRoot = Read-Host;
                if ($OrganizePhotos.SetDestinationPath($This.DestinationRoot)) {
                    $This.Print("green", "Destination Folder Set Successfully")
                }
                else {
                    $This.Print("red", "The destination Folder is Invalid");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.DestinationRoot = "Default";
                }  
            }
            elseif ($command.Equals("3")) {
                $This.Print("", "Enter 1 to organize by creation date and 2 to organize by last modified date.");
                $Selection = Read-Host;
                if ($Selection.Equals("1")) {
                    $This.DateType = "creation";
                }
                elseif ($Selection.Equals("2")) {
                    $This.DateType = "modified";
                }
                else {
                    $This.Print("Red", "You entered $Selection which is an invalid Selection");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.DateType = "Default";
                }
            }
            elseif ($command.Equals("4")) {
                $This.Print("", "Enter 1 to COPY files and 2 To MOVE files")
                $Selection = Read-Host;
                if ($Selection.Equals("1")) {
                    $This.MoveCopy = "copy";
                }
                elseif ($Selection.Equals("2")) {
                    $This.MoveCopy = "move";
                }
                else {
                    $This.Print("Red", "You entered $Selection which is an invalid Selection");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                    $This.MoveCopy = "Default";
                }
            }
            elseif ($command.Equals("5")) {
                $OrganizePhotos.ShowDates();
                $This.Print("", "Please Check Test.csv in the same folder where This script was RUN before proceeding");
                $This.Print("", "Press Enter to the returned to the main Menu")
                Read-Host
            }
            elseif ($command.Equals("6")) {
                if ($This.MoveCopy.Equals("Default") -or $This.DestinationRoot.Equals("Default") -or $This.MoveCopy.Equals("Default") -or $This.SourceDirectory.Equals("Default") ) {
                    $This.Print("red", "A required Paramaeter wasnot set, please try again.");
                    $This.Print("", "Press enter to return to the main menu");
                    Read-Host
                }
                else {
                    if ($This.MoveCopy.Equals("copy")) {
                        if ($This.DateType.Equals("creation")) {
                            $FileNames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $FileNames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.CopyFile($looper.SourcePath, $looper.CreatedTargetPath);
                            }
                            $This.Print("", "The Script Was RUN. Please check the destination folder")
                            $This.Print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                        elseif ($This.DateType.Equals("modified")) {
                            $FileNames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $FileNames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.copyFile($looper.SourcePath, $looper.ModifiedTargetPath);
                            }
                            $This.Print("", "The Script Was RUN. Please check the destination folder")
                            $This.Print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                    }
                    elseif ($This.MoveCopy.Equals("move")) {
                        if ($This.DateType.Equals("creation")) {
                            $FileNames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $FileNames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.MoveFile($looper.SourcePath, $looper.CreatedTargetPath);
                            }
                            $This.Print("", "The Script Was RUN. Please check the destination folder")
                            $This.Print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                        elseif ($This.DateType.Equals("modified")) {
                            $FileNames = $OrganizePhotos.getObjectsFlat();
                            foreach ($file in $FileNames) {
                                $looper = $OrganizePhotos.CollectObjectInfo($file);
                                $OrganizePhotos.MoveFile($looper.SourcePath, $looper.ModifiedTargetPath);
                            }
                            $This.Print("", "The Script Was RUN. Please check the destination folder")
                            $This.Print("", "press enter to return to the main menu...")
                            Read-Host
                        }
                    }
                }
            }
            else {
                $This.RUN = $true;
            }
                
        }

    }
}