# init.el
This is my debian/macOS friendly emacs config. The place the init.el file in your ~/.emacs.d/ directory and my emacs config should be ready to go on your very own machine.

# macOS_setup
This is a script with some basic setup to get a clean macOS install up and running with a basic (but pretty) dev environment. Nothing too fancy.
Run the following lines in a terminal:
```
curl -fsSl https://raw.githubusercontent.com/sreeladas/emacs/master/macOS_setup.sh > macOS_setup.sh
chmod u+x macOS_setup.sh
```

Open macOS_setup.sh in your fav text editor to make sure you're not going to break anything or add unwanted things -- if you work in bash, don't use my zsh setup, that kind of thing

Note: Each part of the script will be confirmed with you prior to being run, in most cases with a clickable link to documentation so you can confirm the product during the script run. The only part that will not be confirmed is the installation of [Homebrew](https://brew.sh/) since it is a requirement for most of this script.

```
./macOS_setup.sh
```
