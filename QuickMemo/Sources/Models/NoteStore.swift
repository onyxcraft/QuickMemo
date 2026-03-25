import Foundation
import Combine

class NoteStore: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedNoteId: UUID?
    @Published var searchText: String = ""
    @Published var windowSize: CGSize = CGSize(width: 600, height: 500)

    private let saveKey = "QuickMemo_Notes"
    private let sizeKey = "QuickMemo_WindowSize"
    private var cancellables = Set<AnyCancellable>()

    var selectedNote: Note? {
        get {
            guard let id = selectedNoteId else { return nil }
            return notes.first { $0.id == id }
        }
    }

    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes.sorted { $0.modifiedAt > $1.modifiedAt }
        }
        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.content.localizedCaseInsensitiveContains(searchText)
        }.sorted { $0.modifiedAt > $1.modifiedAt }
    }

    init() {
        loadNotes()
        loadWindowSize()

        $notes
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveNotes()
            }
            .store(in: &cancellables)

        $windowSize
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] size in
                self?.saveWindowSize(size)
            }
            .store(in: &cancellables)
    }

    func createNote() {
        let newNote = Note()
        notes.append(newNote)
        selectedNoteId = newNote.id
    }

    func deleteNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
            if selectedNoteId == note.id {
                selectedNoteId = notes.first?.id
            }
        }
    }

    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        }
    }

    func selectNote(_ note: Note) {
        selectedNoteId = note.id
    }

    func exportNote(_ note: Note, to url: URL) throws {
        var markdown = "# \(note.title)\n\n"
        markdown += note.content
        markdown += "\n\n---\n"
        markdown += "Created: \(formatDate(note.createdAt))\n"
        markdown += "Modified: \(formatDate(note.modifiedAt))\n"

        try markdown.write(to: url, atomically: true, encoding: .utf8)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
            if !notes.isEmpty {
                selectedNoteId = notes.first?.id
            }
        } else {
            let welcomeNote = Note(
                title: "Welcome to QuickMemo",
                content: """
# Welcome to QuickMemo

QuickMemo is your menu bar sticky notes app with Markdown support.

## Features

- **Markdown Support**: Write notes in Markdown with live preview
- **Code Highlighting**: Syntax highlighting for code blocks
- **Quick Access**: Lives in your menu bar for instant access
- **Search**: Find notes quickly with ⌘F
- **Export**: Save notes as .md files
- **Keyboard Shortcuts**:
  - ⌘N - New Note
  - ⌘S - Save
  - ⌘F - Search

## Example Code Block

```swift
func greet() {
    print("Hello from QuickMemo!")
}
```

Start writing your notes now!
""",
                createdAt: Date(),
                modifiedAt: Date()
            )
            notes = [welcomeNote]
            selectedNoteId = welcomeNote.id
        }
    }

    private func saveWindowSize(_ size: CGSize) {
        let dict: [String: CGFloat] = ["width": size.width, "height": size.height]
        UserDefaults.standard.set(dict, forKey: sizeKey)
    }

    private func loadWindowSize() {
        if let dict = UserDefaults.standard.dictionary(forKey: sizeKey) as? [String: CGFloat],
           let width = dict["width"],
           let height = dict["height"] {
            windowSize = CGSize(width: width, height: height)
        }
    }
}
