import SwiftUI

struct NoteListView: View {
    @ObservedObject var noteStore: NoteStore

    var body: some View {
        VStack(spacing: 0) {
            List(noteStore.notes.sorted(by: { $0.modifiedAt > $1.modifiedAt })) { note in
                NoteRowView(note: note, isSelected: noteStore.selectedNoteId == note.id)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        noteStore.selectNote(note)
                    }
                    .contextMenu {
                        Button("Delete") {
                            noteStore.deleteNote(note)
                        }
                        Button("Export") {
                            FileExporter.exportNote(note) { result in
                                switch result {
                                case .success(let url):
                                    print("Exported to \(url)")
                                case .failure(let error):
                                    print("Export failed: \(error)")
                                }
                            }
                        }
                    }
            }
            .listStyle(.sidebar)
        }
    }
}

struct NoteRowView: View {
    let note: Note
    let isSelected: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(1)

            Text(note.content.prefix(50))
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(2)

            Text(formatDate(note.modifiedAt))
                .font(.system(size: 10))
                .foregroundColor(.tertiary)
        }
        .padding(.vertical, 4)
        .background(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
