import SwiftUI
import AppKit

struct KeyboardShortcutsModifier: ViewModifier {
    @ObservedObject var noteStore: NoteStore
    @Binding var showingSearch: Bool
    let onSave: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear {
                NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                    return handleKeyEvent(event)
                }
            }
    }

    private func handleKeyEvent(_ event: NSEvent) -> NSEvent? {
        let flags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

        if flags == .command {
            switch event.charactersIgnoringModifiers {
            case "n":
                noteStore.createNote()
                return nil
            case "s":
                onSave()
                return nil
            case "f":
                showingSearch.toggle()
                return nil
            default:
                break
            }
        }

        return event
    }
}

extension View {
    func keyboardShortcuts(noteStore: NoteStore, showingSearch: Binding<Bool>, onSave: @escaping () -> Void) -> some View {
        self.modifier(KeyboardShortcutsModifier(noteStore: noteStore, showingSearch: showingSearch, onSave: onSave))
    }
}
