# Changelog

All notable changes to QuickMemo will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-25

### Added
- Initial release of QuickMemo
- Menu bar integration for quick access
- Multiple notes management with list view
- Full Markdown support with live preview
- Code syntax highlighting for common languages:
  - Swift
  - Python
  - JavaScript/TypeScript
  - Go
  - Rust
  - Java
  - C/C++
- Auto-save functionality on close
- Full-text search across all notes (⌘F)
- Export notes as .md files
- Adjustable popup window size
- Dark mode support
- Keyboard shortcuts:
  - ⌘N - New note
  - ⌘S - Save note
  - ⌘F - Search
- Settings panel for customization
- Persistent storage using UserDefaults
- Welcome note with usage instructions
- Professional UI following macOS Human Interface Guidelines

### Technical Details
- Built with SwiftUI and AppKit
- MVVM architecture
- No external dependencies
- macOS 14.0+ compatible
- Bundle ID: com.lopodragon.quickmemo

---

## Future Plans

### Planned Features
- iCloud sync
- Note folders/categories
- Tags for better organization
- Rich text formatting toolbar
- Custom themes
- Note templates
- Password protection for sensitive notes
- Note sharing
- Quick note capture with global hotkey
- Image embedding
- Note linking
- Version history

### Under Consideration
- iOS companion app
- Browser extension
- Spotlight integration
- Note collaboration
- Import from other note apps
