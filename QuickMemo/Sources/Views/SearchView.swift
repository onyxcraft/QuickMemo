import SwiftUI

struct SearchView: View {
    @ObservedObject var noteStore: NoteStore
    @Binding var isPresented: Bool
    @State private var searchQuery: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField("Search notes...", text: $searchQuery)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        performSearch()
                    }

                if !searchQuery.isEmpty {
                    Button(action: {
                        searchQuery = ""
                        noteStore.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.borderless)
                }

                Button("Done") {
                    isPresented = false
                    noteStore.searchText = ""
                    searchQuery = ""
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(12)
            .background(Color(NSColor.controlBackgroundColor))

            if !searchQuery.isEmpty {
                Divider()

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(noteStore.filteredNotes) { note in
                            SearchResultRow(note: note, query: searchQuery)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    noteStore.selectNote(note)
                                    isPresented = false
                                    searchQuery = ""
                                    noteStore.searchText = ""
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
                                )
                        }
                    }
                    .padding(12)
                }
                .frame(maxHeight: 200)
            }
        }
        .onChange(of: searchQuery) { oldValue, newValue in
            noteStore.searchText = newValue
        }
    }

    private func performSearch() {
        noteStore.searchText = searchQuery
    }
}

struct SearchResultRow: View {
    let note: Note
    let query: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)

            Text(getMatchingSnippet())
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
    }

    private func getMatchingSnippet() -> String {
        let content = note.content
        if let range = content.range(of: query, options: .caseInsensitive) {
            let start = content.index(range.lowerBound, offsetBy: -30, limitedBy: content.startIndex) ?? content.startIndex
            let end = content.index(range.upperBound, offsetBy: 30, limitedBy: content.endIndex) ?? content.endIndex
            let snippet = content[start..<end]
            return "...\(snippet)..."
        }
        return String(content.prefix(80))
    }
}
