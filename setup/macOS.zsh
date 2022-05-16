#!/usr/bin/env zsh

# set -e

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "script is for macOS!"
  exit 1
fi

sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

if ! grep -q 'ulimit -n 10240' ~/.zshrc; then
    echo 'setting ulimit 10240'
    echo 'ulimit -n 10240' >> ~/.zshrc
fi

if [[ "$(uname -m)" == "arm64" ]]; then
    # https://stackoverflow.com/a/65398385
    echo "m1 chip ~ rosetta2 will be installed"
    softwareupdate --install-rosetta --agree-to-license
fi

if [ ! -f "Brewfile" ]; then
    echo "Brewfile missing.. what have you done"
    exit 1
fi

if [[ ! -d /Library/Developer/CommandLineTools ]]
then
    xcode-select --install
else
    xcpath=`xcode-select -p`
    echo "xcode cli tools already installed - see ${xcpath}"
fi

if ! command -v brew &> /dev/null
then
    echo "installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brewpath=`which brew`
    echo "brew already installed - see ${brewpath}"
fi

if ! command -v brew &> /dev/null
then
    echo "brew missing from path - may require sourcing"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ ! -d ~/.oh-my-zsh ]
then
    echo "installing oh-my-zsh"
    echo "the installer will exit after installation.. run this script again to continue"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo 'oh-my-zsh already installed - see ~/.oh-my-zsh'
fi

pip3 install --upgrade pip

PYPACKAGES=(
    shodan
    pysocks
    certstream
    virtualenv
)

pip3 install ${PYPACKAGES[@]}

brew bundle
brew update 
brew upgrade
brew cleanup
brew doctor

if command -v gh &> /dev/null
then
    gh auth status > /dev/null || gh auth login --web
fi

if command -v az &> /dev/null
then
    az account show > /dev/null || az login --allow-no-subscriptions
fi

echo "commencing system customisation"

# automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# remove duplicates in the “Open With” menu
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# increase sound quality for bluetooth audio
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# finder
# show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# show path bar
defaults write com.apple.finder ShowPathbar -bool true
# avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# automatically open new window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# show the ~/Library folder
chflags nohidden ~/Library
# show the /Volumes folder
sudo chflags nohidden /Volumes

# speed up mission control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# safari
# show the full URL in safari address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# enable debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# enable develop & webinspect menus
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
# disable java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false
# block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
# enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
# update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# activity monitor
# show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0
# sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# appstore
# enable WebKit developer tools
defaults write com.apple.appstore WebKitDeveloperExtras -bool true
# enable debugging
defaults write com.apple.appstore ShowDebugMenu -bool true

# updates
# enable automatic checks
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# check daily, not weekly
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
# download in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
# install system data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
# automatically download apps from other icloud macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
# turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "complete"
