import SwiftUI

struct NoteEditorView: View {
    @ObservedObject var noteStore: NoteStore
    @State private var editedContent: String = ""
    @State private var showPreview = false

    var body: some View {
        VStack(spacing: 0) {
            if let note = noteStore.selectedNote {
                HStack {
                    TextField("Note Title", text: Binding(
                        get: { note.title },
                        set: { newTitle in
                            if var updatedNote = noteStore.selectedNote {
                                updatedNote.updateTitle(newTitle)
                                noteStore.updateNote(updatedNote)
                            }
                        }
                    ))
                    .textFieldStyle(.plain)
                    .font(.system(size: 18, weight: .semibold))

                    Spacer()

                    Toggle(isOn: $showPreview) {
                        Image(systemName: showPreview ? "eye.fill" : "eye")
                    }
                    .toggleStyle(.button)
                    .buttonStyle(.borderless)
                    .help("Toggle Preview")

                    Button(action: {
                        FileExporter.exportNote(note) { result in
                            switch result {
                            case .success(let url):
                                print("Exported to \(url)")
                            case .failure(let error):
                                print("Export failed: \(error)")
                            }
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .buttonStyle(.borderless)
                    .help("Export Note")
                }
                .padding(12)
                .background(Color(NSColor.controlBackgroundColor))

                Divider()

                if showPreview {
                    MarkdownView(content: note.content)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    TextEditor(text: Binding(
                        get: { note.content },
                        set: { newContent in
                            if var updatedNote = noteStore.selectedNote {
                                updatedNote.updateContent(newContent)
                                noteStore.updateNote(updatedNote)
                            }
                        }
                    ))
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .background(Color(NSColor.textBackgroundColor))
                }
            }
        }
        .onAppear {
            if let note = noteStore.selectedNote {
                editedContent = note.content
            }
        }
    }
}
