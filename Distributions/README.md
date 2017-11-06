![Sunflower](https://farm5.staticflickr.com/4500/38202645771_dc7349ef8b_c.jpg "Sunflower")


# Organize-Photos
##  An applicaiton for organizing photos by date and filetype

##### If you want to run the script you only need to download Organize-Photos.ps1 & OP-Settings.Json and run the script it. (Make sure your powershell execution policy is set to allow this.) A Zip File is also available in the distributions folder.

1.  Dump all your photos into a single folder. 
2.  Start the script.
3.  Set option 1: This is the source folder where you have dumped all your files example: C:\Unsorted\
4.  Set option 2: This is the root folder where files will be organized by date. Example : C:\users\derp\pictures\2017\
5.  Set option 3: Select whether the creation date or last modified date will be used to organize photos (sometimes modified is a better         choice!)
6.  Set option 4: Do you want to Move the files form the source folder or Copy them?
7.  Run option 5! This will dump a file called MM-dd-yyy-HHmm-Results.csv into the same folder the script is being run from. Make sure you review that file. It will give you a better idea about whether you really should organize by creation date or modified date.
8.  Run the script with option 6. If you see an error message, figure it out on your own, its very simple. I may be available to answer questions, but don't count on that.
9.  If you run option 7, it will import all your settings from ./OP-Settings.Json. You should do this.

##### Gotachas
*   There is a file you should also doanload named OP-Settings.JSON, This can be edited to save your settings. It should be straight-forward. 
*   You must set options 1-4 before you can run the script.
*   Files in the destination folder will not be overwritten and a nasty error will appear, its ok, usually, you will need to manually review   those files.
*   If your filesystem does not store the creation date or make it available (*nix) then powershell appears to use the last write date instead.

#####   TODO
*   Make one giant happy object?
*   Logging.
*   Translation of filename to creation date.
*   impliment recursive folder scan.
*   impliment ability to select what files are considered raw.
*   impliment handling for UPPERCASE file extensions.

### Updates from 11-05-2017
####    Updated to version .8
*   verified working in Windows, Linux and OSX

####    Class(OrganizePhotos)
*   Properties
    *   $RawCreateTargetPath = Holds the path used for Organizing raw files by creation date
    *   $RawModTargetPath = Holds the path used for Organizing raw files by Modified date
*   Method(OrganizePhotos) 
    *   $This.RawCreateTargetPath = This is the property that holds the created date path + the suffix /raw/
    *   $This.RawModTargetPath = This is the property that holds the modified date path + the suffix /raw/
*   Method(CollectObjectInfo)
    *   Added a Switch block for the Raw files type, 
```
switch ($This.FileType.Equals(".dng")) {
            $True {
                $This.RawModTargetPath = Join-Path -Path $This.ModifiedTargetPath -ChildPath $RawName;
                $This.RawCreateTargetPath = Join-Path -Path $This.CreatedTargetPath -ChildPath $RawName;
            }
            Default {
                $This.RawModTargetPath = "NotRaw";
                $This.RawCreateTargetPath = "NotRaw";
            }
        }
```
*   Method(ExportReport)
    *   Added Key for RawModTargetPath
    *   Added Key for RawCreateTargetPath
    *   Rearranged Report for Better Flow

####    Class(MyInterface)
*   Method(RunScript)
    *   Added 4 switchblocks (I know) that evaluate Whether the file being examined is a Raw file. If true the file will be copied or moved into the raw subfolder example code:
```
switch ($Looper.FileType.Equals(".dng")) {
    $True { $This.OrganizePhotos.MoveFile($looper.SourcePath, $looper.RawModTargetPath); }
    Default {$This.OrganizePhotos.MoveFile($looper.SourcePath, $looper.ModifiedTargetPath); }
    }
```

#### Updates from 10-29-2017
*   Added boolean variable to MyInterface called $GetHash , this is used to trigger a process that gets the filehash of the file being inspected.
*   Added switch and parameter for collection of file Hash into the CollectObjectInfo() Method. 
*   Modified InitialImport() and ImportSettings() so they will grab the boolean value for $GetHash from the Settings JSON. (Im not adding a menu option for this.) 
*   After Modifying Initial Import, I realized that the reasons for its existence are not well defines so I merged it with Importsettings()
*   Renamed ShowDates() to ExportReport() in the OrganizePhotos Object
*   Renamed OutputSim() to ExportData() In the MyInterface Object
*   Expanded report so it now shows calculated destination paths and source path along with file Hash
*   <b> You should consider Downloading the new JSON file, I dont know what wil happen without it. </b>
*   updated the json file to inculde a new ket called recurse, this will be another feature that I already added but didnt impliment.
*   Added a show status method which I have not implimented.
*   You now press X to exit the program. 
*   Status of the file HashVariable and the recurse variables are now shown in the main menu. 

#### Updated on 10-28-2017
*   I re-engaged the Try,Catch.Finally blocks and all their {} in battle, This time I won and the RunScript Method works. 
*   The Main Menu is now a series of method calls instead of the rats nest it was before.
*   The logic for the actual work of copying and moving is much simplified using switch statements.
*   The logic for the main menu is now a switch statement.
*   When outputting the CSV file with all the dates of all the files in the directory, the name is now MM-dd-yyy-HHmm-Results.csv
*   You can specify your settings in a file named OP-Settings.Json.
*   The OP-Settings.json files is now read when the MyInterface class is instantiated, This means I don't have to type in all my settings every time I start the application. I don't know why I didn't do this earlier. 
*   All manner of cleanup and generic bugfixes. 
