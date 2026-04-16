import Testing
@testable import EmbedderTool

@Suite("StringLiteralEscaper") struct StringLiteralEscaperTests {

    @Test("wraps plain content with a single hash delimiter")
    func plainContent() {
        let literal = StringLiteralEscaper.rawTripleQuotedLiteral(from: "hello")
        #expect(literal == "#\"\"\"\nhello\n\"\"\"#")
    }

    @Test("uses two hashes when content contains a triple-quote followed by one hash")
    func escalatesForSingleHashCollision() {
        let literal = StringLiteralEscaper.rawTripleQuotedLiteral(from: "before\"\"\"#after")
        #expect(literal == "##\"\"\"\nbefore\"\"\"#after\n\"\"\"##")
    }

    @Test("escalates hash count past the longest run seen in content")
    func escalatesForLongerHashRun() {
        let literal = StringLiteralEscaper.rawTripleQuotedLiteral(from: "x\"\"\"####y")
        #expect(literal.hasPrefix("#####\"\"\""))
        #expect(literal.hasSuffix("\"\"\"#####"))
    }

    @Test("accepts empty content")
    func emptyContent() {
        let literal = StringLiteralEscaper.rawTripleQuotedLiteral(from: "")
        #expect(literal == "#\"\"\"\n\n\"\"\"#")
    }

    @Test("leaves triple-quotes without trailing hashes untouched")
    func tripleQuotesWithoutHashes() {
        let literal = StringLiteralEscaper.rawTripleQuotedLiteral(from: "a\"\"\"b")
        #expect(literal.hasPrefix("#\"\"\""))
        #expect(literal.hasSuffix("\"\"\"#"))
    }
}
