# SafariStand for Safari 10 - 12

MacPlus plugin for Safari.

This is a fork of the (fork of the) original SafariStand project, that supports macOS 10.14 Mojave. The forked project seems abandoned, so I decided to create this one to continue the project since the fork does not work well with Safari 12.

Current version supports Safari 12, 11, 10 on Yosemite, El Capitan, Sierra, High Sierra and Mojave. I probably killed the support for the other versions when I was making changes for Safari 10 and macOS Sierra. If you wish to use SafariStand with any of the older Safari versions, you can download a legacy build from the original author [here](https://github.com/hetima/SafariStand/releases).

[Download latest version](https://github.com/w0lfschild/SafariStand/releases/latest)

# MacOS Sierra 10.12.4+ and Library Validation
Version 10.12.4 introduces a library validation feature which makes it almost impossible (as per now) to inject a library such as Safari Stand to Safari without having it signed with the same signature the original Safari is signed with (which is something only Apple can do). 

To load the plugin both `System Integrity Protection` and `Apple Mobile File Integrity` must be disabled.

# MacPlus
SafariStand is tested and working fine on macOS 10.10 to 10.14 with the following MacPlus version from w0lfschild: [link](https://github.com/w0lfschild/MacPlus)

# Issues & Contribution
I welcome and appreciate contributions from the community.

I am new to this project, so may not be familiar with some of the features which may still be in a broken state. So if your favorite feature does not work, let me know and I'll see what I can do. Or make a fix youself and create a pull request :) 

# Current Author

1. [w0lf](https://w0lfschild.github.io/)

# Original Author
All credit must go to this guy actually, cause he did an amazing job putting the whole project together from scratch. I just changed a few things to adapt the module to the changes Apple did to their Safari codebase. 

1. [hetima](http://hetima.com/)  
1. [eac](http://eac.me)

# License
SafariStand  
MIT License. Copyright (c) 2016 hetima, Ivan Faiustov

[HTSymbolHook](https://github.com/hetima/HTSymbolHook)  
MIT License. Copyright (c) 2013 hetima

[DMTabBar](https://github.com/malcommac/DMTabBar)  
MIT License. Copyright (c) 2012 Daniele Margutti
