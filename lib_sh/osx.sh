#!/usr/bin/env bash

action "Configuring OSX pereferences."

source ./echos.sh

#######################################################################
#    General UI/UX
#######################################################################


bot "*********************** General UI/UX ***********************"


check_ok (){
    if [[ $? == 0 ]]; then
        ok $1
    else
        fail $2
    fi
}


running "Set computer name (as done via System Preferences -> Sharing)"
    sudo scutil  --set ComputerName "TrangTranMD102"
    #sudo scutil --set HostName "0x6D746873"
    ##sudo scutil --set LocalHostName "0x6D746873"
    ##sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "0x6D746873"
check_ok

  # Set standby delay to 24 hours (default is 1 hour)
  # sudo pmset -a standbydelay 86400

running "Disable the sound effects on boot"
sudo nvram SystemAudioVolume="%01"
check_ok

running "Disable transparency in the menu bar and elsewhere on Yosemite"
defaults write com.apple.universalaccess reduceTransparency -bool true
check_ok

running "Menu bar: hide the Time Machine, Volume, and User icons"
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/Volume.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu"
done

running "Menu items: AirPort, Battery, Clock"
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"
check_ok

running "Set highlight color to green"
defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"
check_ok

running "Set sidebar icon size to medium"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

running "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`
check_ok

# Disable the over-the-top focus ring animation
#defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Increase window resize speed for Cocoa applications
#defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

running "Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
check_ok

# Expand print panel by default
#defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
#defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
#defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
#defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
#defaults write com.apple.LaunchServices LSQuarantine -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
#/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
#defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
#defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
#defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
#defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
#defaults write com.apple.helpviewer DevMode -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding

running "Reveal IP address, hostname, OS version, etc. when clicking the clock  
        in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
check_ok

# Restart automatically if the computer freezes
#sudo systemsetup -setrestartfreeze on

# Never go into computer sleep mode
#sudo systemsetup -setcomputersleep Off > /dev/null

running "Disable Notification Center and remove the menu bar icon"
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null
check_ok

# Disable smart quotes as they’re annoying when typing code
#defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
#defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

#######################################################################
#    Dock
#######################################################################
bot "****************** DOCK *************************"



# Enable highlight hover effect for the grid view of a stack (Dock)
#defaults write com.apple.dock mouse-over-hilite-stack -bool true

running "Set the icon size of Dock items to 30 pixels"
defaults write com.apple.dock tilesize -int 30
check_ok

running "Change minimize/maximize window effect"
defaults write com.apple.dock mineffect -string "scale"
check_ok

running  "Minimize windows into their application’s icon"
defaults write com.apple.dock minimize-to-application -bool true
check_ok

running "Enable spring loading for all Dock items"
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
check_ok

running "Show indicator lights for open applications in the Dock"
defaults write com.apple.dock show-process-indicators -bool true
check_ok

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true

running "Don’t animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false
check_ok

running "Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1
check_ok

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
#defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
#defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
#defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
#defaults write com.apple.dock mru-spaces -bool false

running "remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0
check_ok

running "Remove the animation when hiding/showing the Dock
"defaults write com.apple.dock autohide-time-modifier -float 0
check_ok

running "Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true
check_ok

running "Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true
check_ok

# Disable the Launchpad gesture (pinch with thumb and three fingers)
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Reset Launchpad, but keep the desktop wallpaper intact
#find "${HOME}/Library/Application Support/Dock" -name "*-*.db" -maxdepth 1 -delete

# Add iOS & Watch Simulator to Launchpad
#sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
#sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
running "Hot corners: Right screen corner -> Desktop"
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
check_ok
# Bottom left screen corner → Start screen saver
#defaults write com.apple.dock wvous-bl-corner -int 5
#defaults write com.apple.dock wvous-bl-modifier -int 0


#######################################################################
#   Finder
#######################################################################
bot "************* FINDER ********************"

running "Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true
check_ok

running "Finder: disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

running "Set Desktop as the default location for new Finder windows \
        For other paths, use `PfLo` and `file:///full/path/here/`"
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"
check_ok

running "Show icons for hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
check_ok

running "Finder: show hidden files by default"
#defaults write com.apple.finder AppleShowAllFiles -bool true
check_ok

running "Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
check_ok

running "Finder: show status bar"
defaults write com.apple.finder ShowStatusBar -bool true
check_ok

running "Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool true
check_ok

running "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
check_ok

running "Keep folders on top when sorting by namei"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
check_ok

running "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
check_ok

running "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
check_ok

running "Enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
check_ok

running "Remove the spring loading delay for directories"
defaults write NSGlobalDomain com.apple.springing.delay -float 0
check_ok

running "Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
check_ok

running "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
check_ok

running "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
check_ok

running "Show item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
check_ok

running "Show item info to the right of the icons on the desktop"
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
check_ok

running "Enable snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
check_ok

# Increase grid spacing for icons on the desktop and in other icon views
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
#/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
#/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

running "Use list view in all Finder windows by default \
        Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
check_ok

running "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false
check_ok

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
#defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
#sudo nvram boot-args="mbasd=1"

running "Show the ~/Library folder"
chflags nohidden ~/Library
check_ok

running "Show the /Volumes folderi"
sudo chflags nohidden /Volumes
check_ok

# Remove Dropbox’s green checkmark icons in Finder
#file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
#[ -e "${file}" ] && mv -f "${file}" "${file}.bak"

running "Expand the following File Info panes: \
         “General”, “Open with”, and “Sharing & Permissions"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true
check_ok

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

bot "****************** TERMINAL & ITERM 2 ***********************"

running "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4
check_ok


running "copy init folder"
if [[ ! -d {$HOME}/init ]] ; then
    mkdir {$HOME}/init
fi
cp -Rf osx/files/init/* ${HOME}/init/. 2>&1 >/dev/null
check_ok

running "Use a modified version of the Solarized Dark theme by default in Terminal.app"
osascript ${HOME}/init/SolarizedDarkTheme.scpt
check_ok

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
#defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable the annoying line marks
#defaults write com.apple.Terminal ShowLineMarks -int 0


running "Install Powerline Fonts"
cp -Rf osx/files/fonts/* ${HOME}/Library/Fonts/ 2>&1 >/dev/null
check_ok


running "Install the customized theme for iTerm"
open ${HOME}/init/iTerm2.itermcolors
check_ok

# don’t display the annoying prompt when quitting iterm
#defaults write com.googlecode.iterm2 promptonquit -bool false



###############################################################################
# CHROME
###############################################################################

bot "****************** CHROME ***********************"

running "Disable two-finger swipe navigation for Chrome"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
check_ok

