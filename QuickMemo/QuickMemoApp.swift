import SwiftUI
import AppKit

@main
struct QuickMemoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var menuBarManager: MenuBarManager?
    var noteStore = NoteStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        menuBarManager = MenuBarManager(noteStore: noteStore)

        NSApp.setActivationPolicy(.accessory)
    }

    func applicationWillTerminate(_ notification: Notification) {
    }
}
