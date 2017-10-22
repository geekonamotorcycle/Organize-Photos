# Organize-Photos
##  A script that will enumerate and organize photos based on Creation Date or Last Modified Date.

##### If you want to run the script you only need to download Organize-Photos.ps1 and run it. (Make sure your powershell execution policy is set to allow this.)

1.  Dump all your photos into a single folder. 
2.  Start the script.
3.  Set option 1: This is the source folder where you have dumped all your folders example: C:\Unsorted\
4.  Set option 2: This is the root folder where files will be organized by date. Example : C:\users\derp\pictures\2017\
5.  Set option 3: Select whether the creation date or last modified date will be used to organize photos (sometimes modified is a better         choice!)
6.  Set option 4: Do you want to Move the files form the source folder or Copy them?
7.  Run option 5! This will dump a file called test.csv into the same folder the script is being run from.Make sure you review that files, it will give you a better idea about whether you really should organize by creation date or modified date.
8.  Run the script with option 6. If you see an error message, figure it out on your own, its very simple. I may be available to answer questions, but don't count on that.

##### Gotachas
*   ou must set options 1-4 before you can run the script.
*   Files in the destination folder will not be overwritten and a nasty error will appear, its ok, usually, you will need to manually review   those files.
*   I was running windows this morning when I wrote this, I usually run Kubuntu and it should run under powershell in GNULinux and OSX as     long as you organize by modified date (creation date is usually hidden)

##### TODO
*   Logging
*   Translation of filename to creation date
*   Verify Linux Compatibility
