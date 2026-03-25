import Foundation
import AppKit

class MarkdownParser {
    static func parseToAttributedString(_ markdown: String, fontSize: CGFloat = 14) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let lines = markdown.components(separatedBy: .newlines)

        var inCodeBlock = false
        var codeBlockLanguage = ""
        var codeBlockContent = ""

        for line in lines {
            if line.hasPrefix("```") {
                if inCodeBlock {
                    let highlighted = SyntaxHighlighter.highlight(code: codeBlockContent, language: codeBlockLanguage, fontSize: fontSize - 1)
                    attributedString.append(highlighted)
                    attributedString.append(NSAttributedString(string: "\n"))
                    codeBlockContent = ""
                    codeBlockLanguage = ""
                    inCodeBlock = false
                } else {
                    inCodeBlock = true
                    let lang = line.replacingOccurrences(of: "```", with: "").trimmingCharacters(in: .whitespaces)
                    codeBlockLanguage = lang
                }
                continue
            }

            if inCodeBlock {
                codeBlockContent += line + "\n"
                continue
            }

            if line.hasPrefix("# ") {
                let text = line.replacingOccurrences(of: "# ", with: "")
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.boldSystemFont(ofSize: fontSize + 8),
                    .foregroundColor: NSColor.labelColor
                ]
                attributedString.append(NSAttributedString(string: text + "\n", attributes: attrs))
            } else if line.hasPrefix("## ") {
                let text = line.replacingOccurrences(of: "## ", with: "")
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.boldSystemFont(ofSize: fontSize + 6),
                    .foregroundColor: NSColor.labelColor
                ]
                attributedString.append(NSAttributedString(string: text + "\n", attributes: attrs))
            } else if line.hasPrefix("### ") {
                let text = line.replacingOccurrences(of: "### ", with: "")
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.boldSystemFont(ofSize: fontSize + 4),
                    .foregroundColor: NSColor.labelColor
                ]
                attributedString.append(NSAttributedString(string: text + "\n", attributes: attrs))
            } else if line.hasPrefix("- ") || line.hasPrefix("* ") {
                let text = line.replacingOccurrences(of: "^[\\-\\*]\\s+", with: "• ", options: .regularExpression)
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: fontSize),
                    .foregroundColor: NSColor.labelColor
                ]
                attributedString.append(NSAttributedString(string: text + "\n", attributes: attrs))
            } else if line.hasPrefix(">") {
                let text = line.replacingOccurrences(of: ">", with: "").trimmingCharacters(in: .whitespaces)
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: fontSize),
                    .foregroundColor: NSColor.secondaryLabelColor,
                    .obliqueness: 0.1
                ]
                attributedString.append(NSAttributedString(string: "  " + text + "\n", attributes: attrs))
            } else {
                var processedLine = line
                processedLine = parseInlineCode(processedLine, fontSize: fontSize, attributedString: attributedString)
                processedLine = parseBoldItalic(processedLine, fontSize: fontSize, attributedString: attributedString)

                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: fontSize),
                    .foregroundColor: NSColor.labelColor
                ]
                attributedString.append(NSAttributedString(string: processedLine + "\n", attributes: attrs))
            }
        }

        return attributedString
    }

    private static func parseInlineCode(_ text: String, fontSize: CGFloat, attributedString: NSMutableAttributedString) -> String {
        return text
    }

    private static func parseBoldItalic(_ text: String, fontSize: CGFloat, attributedString: NSMutableAttributedString) -> String {
        return text
    }
}
