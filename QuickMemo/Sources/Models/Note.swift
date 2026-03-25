import Foundation

struct Note: Identifiable, Codable {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var modifiedAt: Date

    init(id: UUID = UUID(), title: String = "Untitled Note", content: String = "", createdAt: Date = Date(), modifiedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    mutating func updateContent(_ newContent: String) {
        self.content = newContent
        self.modifiedAt = Date()

        if title == "Untitled Note" || title.isEmpty {
            self.title = extractTitle(from: newContent)
        }
    }

    mutating func updateTitle(_ newTitle: String) {
        self.title = newTitle
        self.modifiedAt = Date()
    }

    private func extractTitle(from content: String) -> String {
        let lines = content.components(separatedBy: .newlines)
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if !trimmed.isEmpty {
                let title = trimmed.replacingOccurrences(of: "^#+\\s*", with: "", options: .regularExpression)
                return String(title.prefix(50))
            }
        }
        return "Untitled Note"
    }
}
