import Foundation
import AppKit

class SyntaxHighlighter {
    static func highlight(code: String, language: String, fontSize: CGFloat = 13) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()

        let backgroundColor = NSColor(white: 0.95, alpha: 1.0)
        let backgroundColorDark = NSColor(white: 0.15, alpha: 1.0)
        let bgColor = NSApp.effectiveAppearance.name == .darkAqua ? backgroundColorDark : backgroundColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 4
        paragraphStyle.lineSpacing = 2

        let baseAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: NSColor.labelColor,
            .backgroundColor: bgColor,
            .paragraphStyle: paragraphStyle
        ]

        let lines = code.components(separatedBy: .newlines)

        for (index, line) in lines.enumerated() {
            let highlightedLine = highlightLine(line, language: language, fontSize: fontSize, baseAttrs: baseAttrs)
            attributedString.append(highlightedLine)
            if index < lines.count - 1 {
                attributedString.append(NSAttributedString(string: "\n", attributes: baseAttrs))
            }
        }

        return attributedString
    }

    private static func highlightLine(_ line: String, language: String, fontSize: CGFloat, baseAttrs: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        var currentIndex = line.startIndex

        let keywords = getKeywords(for: language)
        let commentPattern = getCommentPattern(for: language)

        if let commentRange = line.range(of: commentPattern, options: .regularExpression) {
            if commentRange.lowerBound > currentIndex {
                let beforeComment = String(line[currentIndex..<commentRange.lowerBound])
                attributedString.append(highlightTokens(beforeComment, keywords: keywords, fontSize: fontSize, baseAttrs: baseAttrs))
            }

            let comment = String(line[commentRange])
            var commentAttrs = baseAttrs
            commentAttrs[.foregroundColor] = NSColor.systemGreen.withAlphaComponent(0.8)
            attributedString.append(NSAttributedString(string: comment, attributes: commentAttrs))

            currentIndex = commentRange.upperBound
        }

        if currentIndex < line.endIndex {
            let remaining = String(line[currentIndex...])
            attributedString.append(highlightTokens(remaining, keywords: keywords, fontSize: fontSize, baseAttrs: baseAttrs))
        }

        if attributedString.length == 0 {
            attributedString.append(NSAttributedString(string: line, attributes: baseAttrs))
        }

        return attributedString
    }

    private static func highlightTokens(_ text: String, keywords: Set<String>, fontSize: CGFloat, baseAttrs: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()

        let stringPattern = "(\"[^\"]*\"|'[^']*')"
        let numberPattern = "\\b\\d+(\\.\\d+)?\\b"

        var remainingText = text
        var currentPosition = 0

        while !remainingText.isEmpty {
            var matched = false

            if let stringRange = remainingText.range(of: stringPattern, options: .regularExpression) {
                if stringRange.lowerBound == remainingText.startIndex {
                    let string = String(remainingText[stringRange])
                    var stringAttrs = baseAttrs
                    stringAttrs[.foregroundColor] = NSColor.systemRed.withAlphaComponent(0.8)
                    attributedString.append(NSAttributedString(string: string, attributes: stringAttrs))
                    remainingText.removeSubrange(stringRange)
                    matched = true
                    continue
                }
            }

            if let numberRange = remainingText.range(of: numberPattern, options: .regularExpression) {
                if numberRange.lowerBound == remainingText.startIndex {
                    let number = String(remainingText[numberRange])
                    var numberAttrs = baseAttrs
                    numberAttrs[.foregroundColor] = NSColor.systemOrange.withAlphaComponent(0.8)
                    attributedString.append(NSAttributedString(string: number, attributes: numberAttrs))
                    remainingText.removeSubrange(numberRange)
                    matched = true
                    continue
                }
            }

            let wordPattern = "\\b\\w+\\b"
            if let wordRange = remainingText.range(of: wordPattern, options: .regularExpression) {
                if wordRange.lowerBound == remainingText.startIndex {
                    let word = String(remainingText[wordRange])

                    if keywords.contains(word) {
                        var keywordAttrs = baseAttrs
                        keywordAttrs[.foregroundColor] = NSColor.systemPurple.withAlphaComponent(0.9)
                        keywordAttrs[.font] = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .semibold)
                        attributedString.append(NSAttributedString(string: word, attributes: keywordAttrs))
                    } else {
                        attributedString.append(NSAttributedString(string: word, attributes: baseAttrs))
                    }

                    remainingText.removeSubrange(wordRange)
                    matched = true
                    continue
                }
            }

            if !matched {
                let char = String(remainingText.prefix(1))
                attributedString.append(NSAttributedString(string: char, attributes: baseAttrs))
                remainingText.removeFirst()
            }
        }

        return attributedString
    }

    private static func getKeywords(for language: String) -> Set<String> {
        switch language.lowercased() {
        case "swift":
            return ["import", "class", "struct", "enum", "protocol", "func", "var", "let", "if", "else", "for", "while", "return", "guard", "switch", "case", "default", "break", "continue", "init", "deinit", "extension", "private", "public", "internal", "static", "final", "override", "mutating", "throws", "try", "catch", "do", "async", "await"]
        case "python":
            return ["def", "class", "if", "elif", "else", "for", "while", "return", "import", "from", "as", "try", "except", "finally", "with", "lambda", "pass", "break", "continue", "global", "nonlocal", "yield", "async", "await"]
        case "javascript", "js", "typescript", "ts":
            return ["const", "let", "var", "function", "class", "if", "else", "for", "while", "return", "import", "export", "from", "async", "await", "try", "catch", "finally", "throw", "new", "this", "super", "extends", "static", "default", "switch", "case", "break", "continue"]
        case "go":
            return ["func", "package", "import", "var", "const", "type", "struct", "interface", "if", "else", "for", "range", "return", "go", "defer", "switch", "case", "default", "break", "continue", "goto", "fallthrough", "select", "chan", "map"]
        case "rust":
            return ["fn", "let", "mut", "const", "static", "struct", "enum", "trait", "impl", "if", "else", "for", "while", "loop", "match", "return", "break", "continue", "use", "mod", "pub", "crate", "super", "self", "async", "await", "unsafe"]
        case "java", "c", "cpp", "c++":
            return ["class", "interface", "public", "private", "protected", "static", "final", "void", "int", "float", "double", "boolean", "char", "if", "else", "for", "while", "return", "new", "this", "super", "extends", "implements", "import", "package", "try", "catch", "finally", "throw", "throws"]
        default:
            return []
        }
    }

    private static func getCommentPattern(for language: String) -> String {
        switch language.lowercased() {
        case "python", "ruby":
            return "#.*$"
        case "html", "xml":
            return "<!--.*?-->"
        default:
            return "//.*$"
        }
    }
}
