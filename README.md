# Fallout-TTW

Random stuff, settings, mod scripts etc. for my latest Fallout TTW play-through [Fallout, F3, FNV, TTW].

## Licensing

Due to the fact that this repo contains my own work as well as work from other authors, I have decided to add known licenses to the individual (sub) folders, to the best of my knowledge. This is to ensure that the original authors of the files/mods/scripts etc. are credited and that their work is not used in a way that they did not intend.

My own work is licensed under the [Unlicense](https://unlicense.org/), which is a public domain license. This means that you can do whatever you want with my work, without needing to credit me, but feel free to do so if you want.

## [Auto Item Collector](./Auto%20Item%20Collector/)

All props to the original author [ebizoe](https://www.nexusmods.com/newvegas/users/627838) of the [Auto Item Collector](https://www.nexusmods.com/newvegas/mods/77775) mod, I just made a few changes to suit my needs.

I initially added all v2.8 files except the esp itself from which only the GECK scripts were extracted. All modifications done afterwards are either my own or merges from a more recent version of the original mod.

My current ini files can be found in the subfolder [config/my_config](./Auto%20Item%20Collector/config/my_config/).

## [CB Settings & Scripts](./CB%20Settings%20&%20Scripts/)

Some of my game settings, ini files, minor GECK scripts, etc.

## [CB Sound Tweaks](./CB%20Sound%20Tweaks/)

The first mod I made so I could play TTW. Some sounds are really much to loud, annoying, or even completely unbearable for my ND brain. This mod allows the user to e.g. tweak the base volume per sound form or change one sound to another via 2 INI files.

## [CB Stealth Gear](./CB%20Stealth%20Gear/)

ESP file with some custom gear I use.

***TODO: Add ESP file to repo.***

## Misc

### [ck_object_window_data_to_csv.ps1](./ck_object_window_data_to_csv.ps1)

A PowerShell script to extract the current table data from the Object Window in various Creation Kits to a semicolon ";" separated CSV file.

I wrote this since I there is no native copy option in this dialog. Even when selecting multiple rows, it always only copies a single key, not even all columns of a row. This extracts all rows and columns, including the table header into a CSV file. No selection needed, just the dialog must be open and ideally contain some data :).

- **Requirements** are roughly the following:
  - Windows 11 & PowerShell *(in doubt a recent version)*
  - The [Windows Software Development Kit (SDK)](https://developer.microsoft.com/en-us/windows/downloads/windows-sdk/)
    - Specifically `inspect.exe` (the [Inspect](https://learn.microsoft.com/en-us/windows/win32/winauto/inspect-objects tool) to find automation IDs.
    - After installation it can be found in `C:\Program Files (x86)\Windows Kits\{major-version}\bin\{version}\x64\inspect.exe` *(depending on the SDK version)*.
  - A running Creation Kit with an open Object Window ... for obvious reasons :)
- **Compatibility** at least with the following Creation Kits:
  - Fallout New Vegas / Fallout 3 GECK *(Garden of Eden Creation Kit)*
  - Fallout 4 Creation Kit 64bit (Next-Gen)
