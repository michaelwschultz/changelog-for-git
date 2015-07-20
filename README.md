# Git Changelog Generator
###### With one command, generate a beautiful .html file of your entire commit history. A great way to remind you of your previous work and a fantastic visual for clients and/or co-workers.

## Example changelog
![example of what a changelog looks like](http://cl.ly/c05q/example-of-changelog.png)


## Setup
Make sure you are working in a git repository that has **at least one commit**.
I recommend created an alias to your **git-changelog.sh** file so that you can call it just by using a command like `changelog` inside each of your project folders.

To create an alias on your machine, just add the following line to your .bash_profile
located at /User/username/.bash_profile on OSX.

`alias changelog='sh ~/Dropbox/Files/git-changelog.sh'`

#### (optional) Automatically build new changelog on each commit
Place the **post-commit** file inside project-directory/.git/hooks/ and
edit the source path to run git-changelog immediately after every commit

example path: ~/Dropbox/Scripts/git-changelog.sh

## Commands
Run on current git respoitory with `$ sh PATH/TO/git-changelog.sh`

`$ sh PATH/TO/git-changelog -open` to open changelog after generation

`$ sh PATH/TO/git-changelog -force` to generate new changelog if you get stuck in a weird state

## Contact
- [@michaelschultz](http://twitter.com/@michaelschultz)
- http://michaelschultz.com