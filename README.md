# Studio-Lite
---

## Introduction

**Studio-Lite** is a debloat tool that aims at helping replenish workflow productivity and removing unnecessary frustration and headache in Roblox Studio. The inspiration and creation of this tool stems from the current state of Roblox's development editor. Bloated with numerous niche plugins and features that are generally unused among various developer professions, I have found these built-in plugins/features to be resource-intensive, generally cluttering, and overall, a detriment to my workflow and productivity in their existence.

#### Complaints

This is a concern for the platform, as over the years, it's hallmark IDE's design, maintenance, and feature implementation is becoming growingly unkempt. Each update to Roblox Studio forces over 30 resource intensive plugins onto it's users, where the viability of our professions reside in fast, iterative, efficient, productive work to stay afloat in a competitive industry. I require that my tools do nothing but only what I need them to do. I cannot have 300,000+ Instances being generated in Studio when I use Play mode, or 200,000+ Instances being generated in Studio in a new, empty Baseplate file, with many native plugins themselves leaking memory if they are used. The lack of control over design and customization in our IDE of choice does not lend much credence to Roblox, either. This tool aims to help aid these ailments, if only a little.

#### Features

This tool supports automated behavior, whereby after the use of ```install.ps1```, **every time** Roblox Studio is opened, it will check Roblox's subdirectory in your file system, and remove **all** or a **specified some** of the plugins that come natively with each installation, re-installation, and update of Roblox Studio. **This behavior is entirely automated** via the Windows Task Scheduler. For the most part, I made this tool for myself. If it helps you, that's great! I'm glad I could help bring this to you. If you'd like to add or suggest customization features for the tool, contribute, and/or edit and fit it to your liking, please do!

Included is a custom RobloxStudioRibbon.xml that is *extremely minimalist*. It is only one tab that looks to consolidate all of the non-native Studio plugins, as well as any native transform tools that come with Roblox. Utilizing the Quick Access toolbar as well, if you decide you like it, is recommended. You can select to use this by setting ```$useCustomRibbon``` to '```$TRUE```' under ```debloat.ps1```. This is set to ```$FALSE``` by default, as my style is subjective to myself, and could be considered invasive if I forced it upon you. Where you specify which plugins you'd like to keep is on a per-name basis under ```debloat.ps1```'s ```$excludedPlugins``` string array.

#### Results

As this is a *total* debloat tool, I opt naturally, to only have the absolute bare minimum of Roblox Studio's native plugins kept - only the functionality that I need that is not platform or productivity inhibiting. This results in resource savings in the realm of 50% on RAM usage (~600MB+) in basic test results on Windows 10, and noticable improvements in Roblox Studio's program speed over it's processes' lifetime, *generally speaking*. You are free to edit a version of the tool to your liking, encouraged to keep whichever plugins are necessary to your workflow, of course.

Reverting changes is done via running ```uninstall.ps1```. Doing this removes the Windows Scheduled Task, which is what handles all automated running of this code over it's lifetime. Upon removal, the tool will ask if you'd like to revert your changes by re-installing Roblox Studio. Simply Press Y and hit enter if you agree. Otherwise, the changes made by ```debloat.ps1``` will still apply, and eventually, Roblox Studio will revert to normal upon it's next update. Otherwise, inherently, Roblox Studio's re-installation will revert all changes made by ```debloat.ps1```.
