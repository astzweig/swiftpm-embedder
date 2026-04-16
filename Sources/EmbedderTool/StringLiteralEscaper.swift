import Foundation

enum StringLiteralEscaper {
    static func rawTripleQuotedLiteral(from content: String) -> String {
        let hashDelimiter = makeHashDelimiter(avoidingCollisionsIn: content)
        return assembleLiteral(content: content, hashDelimiter: hashDelimiter)
    }
}

private extension StringLiteralEscaper {
    static let tripleQuote = "\"\"\""

    static func assembleLiteral(content: String, hashDelimiter: String) -> String {
        let opening = "\(hashDelimiter)\(tripleQuote)\n"
        let closing = "\n\(tripleQuote)\(hashDelimiter)"
        return opening + content + closing
    }

    static func makeHashDelimiter(avoidingCollisionsIn content: String) -> String {
        let minimumHashCount = longestHashRunFollowingTripleQuote(in: content) + 1
        return String(repeating: "#", count: minimumHashCount)
    }

    static func longestHashRunFollowingTripleQuote(in content: String) -> Int {
        var longestRun = 0
        var cursor = content.startIndex
        while let tripleQuoteRange = content.range(of: tripleQuote, range: cursor..<content.endIndex) {
            let hashRun = consecutiveHashCount(in: content, startingAt: tripleQuoteRange.upperBound)
            longestRun = max(longestRun, hashRun)
            cursor = advance(from: tripleQuoteRange.lowerBound, in: content)
        }
        return longestRun
    }

    static func consecutiveHashCount(in content: String, startingAt startIndex: String.Index) -> Int {
        var count = 0
        var index = startIndex
        while index < content.endIndex, content[index] == "#" {
            count += 1
            index = content.index(after: index)
        }
        return count
    }

    static func advance(from index: String.Index, in content: String) -> String.Index {
        content.index(after: index)
    }
}
