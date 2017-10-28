![Pretty Purple Flowers](https://farm5.staticflickr.com/4464/24015521458_9acd2d1e3f_k.jpg "Pretty Purple Flowers")


# Organize-Photos
##  A script that will enumerate and organize photos based on Creation Date or Last Modified Date.

##### Updated on 10-28-2017
*   I re-engaged the Try,Catch.Finally blocks and all their {} in battle, This time I won and the RunScript Method works. 
*   The Main Menu is now a series of method calls instead of the rats nest it was before.
*   The logic for the actual work of copying and moving is much simplified using switch statements.
*   The logic for the main menu is now a switch statement.
*   When outputting the CSV file with all the dates of all the files in the directory, the name is now MM-dd-yyy-HHmm-Results.csv
*   You can specify your settings in a file named OP-Settings.Json.
*   The OP-Settings.json files is now read when the MyInterface class is instantiated, This means I don't have to type in all my settings every time I start the application. I don't know why I didn't do this earlier. 
*   All manner of cleanup and generic bugfixes. 

##### If you want to run the script you only need to download Organize-Photos.ps1 & OP-Settings.Json and run the script it. (Make sure your powershell execution policy is set to allow this.)

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
*   There is a file you should also download named OP-Settings.JSON, This can be edited to save your settings. It should be straight-forward. 
*   You must set options 1-4 before you can run the script.
*   Files in the destination folder will not be overwritten and a nasty error will appear, its ok, usually, you will need to manually review   those files.
*   I was running windows this morning when I wrote this, I usually run Kubuntu and it should run under powershell in GNULinux and OSX as     long as you organize by modified date (creation date is usually hidden)

##### TODO
*   Verify Linux Compatibility
*   Make one giant happy object?
*   Logging
*   Translation of filename to creation date
