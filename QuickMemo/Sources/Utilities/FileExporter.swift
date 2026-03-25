import Foundation
import AppKit

class FileExporter {
    static func exportNote(_ note: Note, completion: @escaping (Result<URL, Error>) -> Void) {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.init(filenameExtension: "md")!]
        savePanel.nameFieldStringValue = "\(note.title).md"
        savePanel.title = "Export Note"
        savePanel.message = "Choose where to save the markdown file"

        savePanel.begin { response in
            guard response == .OK, let url = savePanel.url else {
                completion(.failure(NSError(domain: "FileExporter", code: -1, userInfo: [NSLocalizedDescriptionKey: "Export cancelled"])))
                return
            }

            do {
                var markdown = "# \(note.title)\n\n"
                markdown += note.content
                markdown += "\n\n---\n"
                markdown += "Created: \(formatDate(note.createdAt))\n"
                markdown += "Modified: \(formatDate(note.modifiedAt))\n"

                try markdown.write(to: url, atomically: true, encoding: .utf8)
                completion(.success(url))
            } catch {
                completion(.failure(error))
            }
        }
    }

    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
