# SafariStand for Safari 10

SIMBL plugin for Safari.

This is a fork of the original SafariStand project, that supports macOS Sierra and Safari 10. Original project seems abandoned, so I decided to create this one to continue the project since the original does not work well with Safari 10 and the author does not seem to be accepting any pull requests.

Current version supports Safari 10.1 & 10.0 only. I probably killed the support for the other versions when I was making changes for Safari 10 and macOS Sierra. If you wish to use SafariStand with any of the older Safari versions, you can download a legacy build from the original author [here](https://github.com/hetima/SafariStand/releases).

[Download latest version](https://github.com/anakinsk/SafariStand/releases/latest)

# MacOS Sierra 10.12.4+ and Library Validation
Version 10.12.4 introduces a library validation feature which makes it almost impossible (as per now) to inject a library such as Safari Stand to Safari without having it signed with the same signature the original Safari is signed with (which is something only Apple can do). 

We found a way to do it tho, by installing a patcher that replaces your current Safari binary in your Applications folder with last version without library validation from the Sierra 10.12.3

It seems that the majority of Safari functionality is located inside the private framework which is located elsewhere and therefore will not be affected by the patch. This means that even though "About Safari" window shows the older version after applying a patch, you actually still have the latest one. 

**Important:**
1) You will need to disable SIP (System Integrity Protection) before applying a patch.
2) This patcher is not signed which means you will have to either allow apps downloaded from "anywhere" in your System Preferences->Security & Privacy tab or open it via the context menu (Right mouse click->Open)
3) You need to manually create a backup of Safari.app in your Applications folder before applying a patch
4) You can re-enable SIP after applying the patch
5) You will need to apply the patch every time you update Safari
6) It is recommended that you do not update to the next version of MAC OS without getting "all clear" from the community, otherwise you risk spending considerable time waiting for the fix if SafariStand breaks again

Patch is now included with every SafariStand release but it is recommended that you download the latest version from this page if you have problems before reporting new bug.

If you need even more details just follow up with [this thread](https://github.com/anakinsk/SafariStand/issues/38).

[Download Safari Stand Patcher](https://github.com/anakinsk/SafariStand/files/911989/Safari.Stand.Patcher.pkg.zip)

# SIMBL
SafariStand is tested and working fine on macOS Sierra and El Capitan with the following SIMBL version from w0lfschild: [link](https://github.com/w0lfschild/mySIMBL)

# Issues & Contribution
I welcome and appreciate contributions from the community.

I am new to this project, so may not be familiar with some of the features which may still be in a broken state. So if your favorite feature does not work, let me know and I'll see what I can do. Or make a fix youself and create a pull request :) 

# Current Author
http://eac.me

# Original Author
All credit must go to this guy actually, cause he did an amazing job putting the whole project together from scratch. I just changed a few things to adapt the module to the changes Apple did to their Safari codebase. 

http://hetima.com/  
https://twitter.com/hetima

# License
SafariStand  
MIT License. Copyright (c) 2016 hetima, Ivan Faiustov

[HTSymbolHook](https://github.com/hetima/HTSymbolHook)  
MIT License. Copyright (c) 2013 hetima

[DMTabBar](https://github.com/malcommac/DMTabBar)  
MIT License. Copyright (c) 2012 Daniele Margutti
