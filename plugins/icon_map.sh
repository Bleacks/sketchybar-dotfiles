case $@ in
"Messages" | "Nachrichten")
  icon_result="󰭹"
  ;;
"KeePassXC")
  icon_result=""
  ;;
"Keeper Password Manager")
  icon_result=""
  ;;
"Microsoft Edge")
  icon_result="󰇩"
  ;;
"Microsoft Sharepoint")
  icon_result="󱎑"
  ;;
"Microsoft OneDrive")
  icon_result="󰏊"
  ;;
"VLC")
  icon_result="󰕼"
  ;;
"Notes")
  icon_result="󰺿"
  ;;
"Caprine")
  icon_result="󰈎"
  ;;
"Zulip")
  icon_result="󰬡"
  ;;
"Microsoft To Do" | "Things")
  icon_result=""
  ;;
"Microsoft Outlook")
  icon_result="󰴢"
  ;;
"GitHub Desktop")
  icon_result="󰊤"
  ;;
"App Store")
  icon_result="󱃁"
  ;;
"Kaleidoscope")
  icon_result="󱧭"
  ;;
"Sourcetree" | "Git Kraken")
  icon_result="󰘬"
  ;;
"Chromium" | "Google Chrome" | "Google Chrome Canary")
  icon_result=""
  ;;
"Microsoft Word")
  icon_result="󱎒"
  ;;
"Microsoft Teams")
  icon_result="󰊻"
  ;;
"Neovide" | "MacVim" | "Vim" | "VimR")
  icon_result=""
  ;;
"Sublime Text")
  icon_result=""
  ;;
"WhatsApp")
  icon_result="󰖣"
  ;;
"Parallels Desktop")
  icon_result="󰢹"
  ;;
"Microsoft Excel")
  icon_result="󱎏"
  ;;
"Microsoft PowerPoint")
  icon_result="󱎐"
  ;;
"Microsoft OneNote")
  icon_result="󰝇"
  ;;
"Firefox Developer Edition" | "Firefox Nightly")
  icon_result="󰈹"
  ;;
"Trello")
  icon_result="󰔲"
  ;;
"Notion")
  icon_result="󰠮"
  ;;
"Evernote Legacy")
  icon_result="󰈄"
  ;;
"Calendar" | "Fantastical")
  # icon_result="" # Nerd Font
  icon_result="􀉉" # SF Symbols
  ;;
"Android Studio")
  icon_result=""
  ;;
"Slack")
  icon_result="󰒱"
  ;;
"Bitwarden")
  icon_result=""
  ;;
"System Preferences" | "System Settings")
  # icon_result="􀍟" # Apple
  icon_result="󰒓"
  ;;
"Discord" | "Discord Canary" | "Discord PTB")
  icon_result="󰙯"
  ;;
"Firefox")
  icon_result="󰈹"
  ;;
"Skype")
  icon_result="󰒯"
  ;;
"Dropbox")
  icon_result="󰇣"
  ;;
"Blender")
  icon_result="󰂫"
  ;;
"Canary Mail" | "HEY" | "Mail" | "Mailspring" | "MailMate" | "邮件" | "Outlook")
  icon_result="󰇰"
  ;;
"Safari" | "Safari Technology Preview")
  icon_result="󰀹"
  ;;
"Telegram")
  icon_result=""
  ;;
"Spotify")
  icon_result="󰓇"
  ;;
"Spotlight")
  icon_result="󰍉"
  ;;
"Music")
  icon_result="󰝚"
  ;;
"Pages")
  icon_result="󰴓"
  ;;
"Atom")
  icon_result=""
  ;;
"Todoist")
  icon_result=""
  ;;
"Preview" | "Skim" | "zathura")
  icon_result=""
  ;;
"Code" | "Code - Insiders")
  icon_result="󰨞"
  ;;
"Calibre")
  icon_result=""
  ;;
"Finder" | "访达")
  icon_result="󰀶"
  ;;
"Alacritty" | "Hyper" | "iTerm2" | "kitty" | "Terminal" | "WezTerm")
  # icon_result="" # Font Awesome
  icon_result=""
  ;;
"FortiClient")
  icon_result="󰒘"
  ;;
"1Password")
  icon_result="󰢁"
  ;;
"Activity Monitor")
  icon_result="󰄦"
  ;;
"Font Book")
  icon_result=""
  ;;
"OpenVPN Connect")
  icon_result=""
  ;;
*)
  icon_result="󱀶"
  ;;
esac
echo $icon_result
