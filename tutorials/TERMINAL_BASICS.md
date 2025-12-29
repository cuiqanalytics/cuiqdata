# Terminal Basics

## Opening a Terminal

**Windows:**
- Press `Win + R`, type `cmd`, and press Enter
- Or press `Win + X` and select "Terminal" or "Command Prompt"

**Mac:**
- Press `Cmd + Space`, type `terminal`, and press Enter
- Or open Applications > Utilities > Terminal

**Linux:**
- Press `Ctrl + Alt + T`
- Or right-click desktop and select "Open Terminal"

## Executing commands

Type a command name (for example `dir`) and press Enter

## Navigating Directories

Print your current location:

**Mac/Linux:**
```
pwd
```

**Windows:**
```
cd
```

Change to a directory (all platforms):
```
cd path/to/directory
```

Go to your home directory:

**Mac/Linux:**
```
cd ~
```

**Windows:**
```
cd %USERPROFILE%
```

Go up one level (all platforms):
```
cd ..
```

## Listing Files

List files in current directory:

**Mac/Linux:**
```
ls
```

Output example:
```
Desktop     Documents   Downloads   data.csv    script.sh
```
(Items without `/` are files; directories often appear first)

**Windows:**
```
dir
```

Output example:
```
Directory of C:\Users\YourName

12/26/2024  10:30 AM    <DIR>          Desktop
12/26/2024  10:30 AM    <DIR>          Documents
12/26/2024  11:45 AM             5,120 data.csv
12/26/2024  11:50 AM               340 script.bat
```
(`<DIR>` indicates directories; files show their size)

List with more details:

**Mac/Linux:**
```
ls -l
```

Output example:
```
drwxr-xr-x   5 user  staff   160 Dec 26 10:30 Desktop
-rw-r--r--   1 user  staff  5120 Dec 26 11:45 data.csv
-rwxr-xr-x   1 user  staff   340 Dec 26 11:50 script.sh
```
(Lines starting with `d` are directories; lines starting with `-` are files)

**Windows:**
```
dir /s
```

Output example:
```
Directory of C:\Users\YourName\project

12/26/2024  10:30 AM    <DIR>          .
12/26/2024  10:30 AM    <DIR>          ..
12/26/2024  10:30 AM    <DIR>          Desktop
12/26/2024  10:30 AM    <DIR>          Documents
12/26/2024  11:45 AM             5,120 data.csv
12/26/2024  11:50 AM               340 script.bat

Directory of C:\Users\YourName\project\Desktop

12/26/2024  10:35 AM    <DIR>          .
12/26/2024  10:35 AM    <DIR>          ..
12/26/2024  11:15 AM             2,048 notes.txt
```
(`<DIR>` = directory; entries with sizes = files; `/s` shows subdirectories recursively)

## Viewing File Contents

View the contents of a text file:

**Mac/Linux:**
```
cat filename.txt
```

**Windows:**
```
type filename.txt
```

Example:
```
cat data.csv
```

Output:
```
name,age,city
Alice,28,Boston
Bob,35,Seattle
```

## Closing

Type (all platforms):
```
exit
```

Or press:
- **Mac/Linux:** `Ctrl + D`
- **Windows:** `Ctrl + Z` then `Enter`
