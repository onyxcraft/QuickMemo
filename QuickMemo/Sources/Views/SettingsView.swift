import SwiftUI

struct SettingsView: View {
    @ObservedObject var noteStore: NoteStore
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)

            Form {
                Section("Window Size") {
                    HStack {
                        Text("Width:")
                        TextField("Width", value: Binding(
                            get: { noteStore.windowSize.width },
                            set: { newWidth in
                                noteStore.windowSize.width = max(400, min(1200, newWidth))
                            }
                        ), format: .number)
                        .frame(width: 80)

                        Text("Height:")
                        TextField("Height", value: Binding(
                            get: { noteStore.windowSize.height },
                            set: { newHeight in
                                noteStore.windowSize.height = max(300, min(900, newHeight))
                            }
                        ), format: .number)
                        .frame(width: 80)
                    }

                    Button("Reset to Default") {
                        noteStore.windowSize = CGSize(width: 600, height: 500)
                    }
                }

                Section("Keyboard Shortcuts") {
                    VStack(alignment: .leading, spacing: 8) {
                        ShortcutRow(key: "⌘N", description: "New Note")
                        ShortcutRow(key: "⌘S", description: "Save Note")
                        ShortcutRow(key: "⌘F", description: "Search")
                    }
                }

                Section("About") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("QuickMemo")
                            .font(.headline)
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("A menu bar sticky notes app with Markdown support")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("© 2026 LopodragonDev")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .formStyle(.grouped)

            HStack {
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 400, height: 450)
    }
}

struct ShortcutRow: View {
    let key: String
    let description: String

    var body: some View {
        HStack {
            Text(key)
                .font(.system(.body, design: .monospaced))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(4)

            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()
        }
    }
}
