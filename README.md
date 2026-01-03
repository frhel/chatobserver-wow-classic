# ChatObserver

A World of Warcraft Classic addon that monitors chat channels for specified keywords and alerts you when they appear.

## Features

- Monitor chat channels for custom keywords
- Special monitoring mode for world boss announcements
- Sound notifications when keywords are detected
- Operating system icon flash notifications
- Persistent settings across sessions
- Easy-to-use slash commands

## Installation

1. Download or clone this repository
2. Copy the `chatobserver-wow-classic` folder to your WoW Classic AddOns directory:
   - Windows: `C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns\`
   - macOS: `/Applications/World of Warcraft/_classic_/Interface/AddOns/`
3. Restart WoW Classic or reload your UI with `/reload`

## Usage

### Commands

Type `/co` or `/chatobserver` to see all available commands.

### Managing Keywords

- **Add keywords**: `/co add <keyword>` (e.g., `/co add UBRS` or `/co add UBRS Strat Scholo DM`)
- **Remove keyword**: `/co remove <keyword>` (e.g., `/co remove UBRS`)
- **List keywords**: `/co list`
- **Clear all keywords**: `/co clear`

### Monitoring Control

- **Start monitoring**: `/co start`
- **Stop monitoring**: `/co stop`
- **Toggle world boss monitoring**: `/co wb`

### Notification Settings

- **Sound notifications**: `/co sound on` or `/co sound off`
- **OS icon flash**: `/co flashos on` or `/co flashos off`

## World Boss Monitoring

The addon includes built-in support for monitoring world boss announcements. Use `/co wb` to toggle monitoring for:
- Azuregos
- Kazzak
- Emeriss
- Lethon
- Ysondre
- Taerar

## Author

**frhel@github**

## Contributors

- @danielfoth

## License

See [LICENSE](LICENSE) file for details.

## Version

Current version: 0.6
