import SwiftUI
import AppKit

struct ContentView: View {
    @ObservedObject var noteStore: NoteStore
    var popover: NSPopover?
    @State private var showingSearch = false
    @State private var showingSettings = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("QuickMemo")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: { showingSearch.toggle() }) {
                    Image(systemName: "magnifyingglass")
                }
                .buttonStyle(.borderless)
                .help("Search (⌘F)")

                Button(action: { noteStore.createNote() }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
                .help("New Note (⌘N)")

                Button(action: { showingSettings.toggle() }) {
                    Image(systemName: "gear")
                }
                .buttonStyle(.borderless)
                .help("Settings")
            }
            .padding(8)
            .background(Color(NSColor.controlBackgroundColor))

            Divider()

            if showingSearch {
                SearchView(noteStore: noteStore, isPresented: $showingSearch)
                    .transition(.move(edge: .top))
            }

            HSplitView {
                NoteListView(noteStore: noteStore)
                    .frame(minWidth: 150, maxWidth: 250)

                if noteStore.selectedNote != nil {
                    NoteEditorView(noteStore: noteStore)
                } else {
                    VStack {
                        Image(systemName: "note.text")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)
                        Text("No note selected")
                            .foregroundColor(.secondary)
                        Text("Create a new note or select one from the list")
                            .font(.caption)
                            .foregroundColor(.tertiary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .frame(width: noteStore.windowSize.width, height: noteStore.windowSize.height)
        .keyboardShortcuts(noteStore: noteStore, showingSearch: $showingSearch, onSave: {})
        .sheet(isPresented: $showingSettings) {
            SettingsView(noteStore: noteStore)
        }
        .onChange(of: noteStore.windowSize) { oldValue, newValue in
            popover?.contentSize = newValue
        }
    }
}
