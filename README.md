# QuickMemo

A professional menu bar sticky notes app for macOS 14+ with full Markdown support and code syntax highlighting.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-5.0-orange)
![License](https://img.shields.io/badge/license-MIT-green)

## Features

- **Menu Bar Integration**: Lives in your menu bar for instant access
- **Multiple Notes**: Create and manage multiple notes with an intuitive list view
- **Markdown Support**: Full Markdown syntax with live preview
- **Code Syntax Highlighting**: Syntax highlighting for Swift, Python, JavaScript, Go, Rust, Java, C, C++, and more
- **Auto-Save**: Notes are automatically saved as you type
- **Search**: Quickly find notes with full-text search (⌘F)
- **Export**: Export notes as .md files
- **Adjustable Popup Size**: Customize the popup window size to your preference
- **Dark Mode**: Full support for macOS light and dark modes
- **Keyboard Shortcuts**:
  - `⌘N` - Create a new note
  - `⌘S` - Save current note
  - `⌘F` - Open search

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later (for building from source)

## Installation

### App Store
Available on the Mac App Store for $4.99 USD (one-time purchase).

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/yourusername/QuickMemo.git
cd QuickMemo
```

2. Open the project in Xcode:
```bash
open QuickMemo.xcodeproj
```

3. Build and run (⌘R)

## Usage

1. After launching, QuickMemo appears in your menu bar as a note icon
2. Click the icon to open the popup window
3. Create a new note with the `+` button or ⌘N
4. Write in Markdown and toggle preview with the eye icon
5. Search across all notes with ⌘F
6. Export notes as .md files using the export button

## Architecture

QuickMemo is built with:
- **SwiftUI** for the user interface
- **AppKit** for menu bar integration
- **MVVM** architecture pattern
- **No external dependencies** - pure Swift implementation

### Project Structure

```
QuickMemo/
├── QuickMemoApp.swift              # App entry point
├── Sources/
│   ├── Models/
│   │   ├── Note.swift              # Note data model
│   │   └── NoteStore.swift         # Note management and persistence
│   ├── Views/
│   │   ├── ContentView.swift       # Main container view
│   │   ├── NoteEditorView.swift    # Note editing interface
│   │   ├── NoteListView.swift      # Note list sidebar
│   │   ├── MarkdownView.swift      # Markdown preview
│   │   ├── SearchView.swift        # Search interface
│   │   └── SettingsView.swift      # Settings panel
│   ├── MenuBar/
│   │   └── MenuBarManager.swift    # Menu bar integration
│   └── Utilities/
│       ├── KeyboardShortcuts.swift # Keyboard shortcut handler
│       ├── MarkdownParser.swift    # Markdown parsing
│       ├── SyntaxHighlighter.swift # Code syntax highlighting
│       └── FileExporter.swift      # Note export functionality
├── Assets.xcassets/                # App icons and assets
└── Info.plist                      # App configuration
```

## Development

### Code Quality
- Pure Swift implementation
- MVVM architecture
- No external dependencies
- Follows Apple's Human Interface Guidelines

### Testing
Build and test the app in Xcode:
```bash
open QuickMemo.xcodeproj
# Press ⌘B to build
# Press ⌘R to run
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with SwiftUI and AppKit
- Markdown parsing and syntax highlighting implemented from scratch
- Icon design uses SF Symbols

## Support

For issues, feature requests, or contributions, please visit the [GitHub repository](https://github.com/yourusername/QuickMemo).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

---

Made with ❤️ by LopodragonDev
