# Updating to support new version

This is my cheatsheet for updating XML2RFC-XXE to support a new version of XMLMind XML Editor.



**NOTE**: Some of this repo uses GIT LFS - this was a mistake, but is sufficently annoying to undo that I'm not going to bother. This means that you need `git-lfs` to work with this. 

Check if you have git-lfs by running `git lfs env`. If not, install it with (Mac) ```brew install git-lfs```



**<u>Short cheatsheet:</u>**

* Download xml2rfc-xxe-0.8.3.zip
* Unzip
* Edit xml2rfc/xml2rfc.xxe_addon, bump "addon location", "version" and "xxeVersion"
* Zip to new name (```zip -r xml2rfc-xxe-0.8.4.zip xml2rfc```, copy xml2rfc.xxe_addon to new name.
* Add these to the repo, commit and push. Also edit the README.md file.
* Profit!

