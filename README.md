# xframes-ruby

## Instructions

### Install Ruby

#### Windows

I recommend to install Ruby via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/):

`winget install RubyInstallerTeam.RubyWithDevKit.3.2`

The reason why you need the dev kit is that the event machine gem needs to be compiled on the target machine.

Then install the dependencies (you likely need to close all terminals first):

- `gem install ffi`
- `gem install eventmachine`
- `gem install rx`

`RUBY_DLL_PATH` must be set, e.g.:

`$env:RUBY_DLL_PATH="C:\dev\xframes-ruby"`

For convenience, you may launch `main.bat` or `main.ps1` depending on whether you are using a regular command line or PowerShell.

#### Linux

- `sudo apt install ruby-full`
- `sudo gem install ffi`
- `sudo gem install eventmachine`
- `sudo gem install rx`

### Run the application

`ruby main.rb`

## Screenshots

Windows 11

![image](https://github.com/user-attachments/assets/2ddc2f41-5310-4f4c-a850-71c3edead95b)

Raspberry Pi 5

![image](https://github.com/user-attachments/assets/190f8603-a6db-45c6-a5f0-cfd4dc1b87e2)
