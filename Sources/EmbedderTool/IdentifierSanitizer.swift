import Foundation

enum IdentifierSanitizer {
    static func propertyName(fromFilename filename: String) -> String {
        let words = words(from: filename)
        let camelCased = joinAsLowerCamelCase(words)
        return escapeForSwift(camelCased)
    }

    static func typeName(from directoryName: String) -> String {
        let words = words(from: directoryName)
        let pascalCased = joinAsUpperCamelCase(words)
        return escapeForSwift(pascalCased)
    }
}

private extension IdentifierSanitizer {
    static func words(from rawString: String) -> [String] {
        let segments = splitOnNonAlphanumerics(rawString)
        return segments.flatMap(splitCamelCaseBoundaries)
    }

    static func splitOnNonAlphanumerics(_ string: String) -> [String] {
        string
            .split(whereSeparator: { !$0.isLetter && !$0.isNumber })
            .map(String.init)
    }

    static func splitCamelCaseBoundaries(_ word: String) -> [String] {
        var results: [String] = []
        var currentWord = ""
        for character in word {
            if shouldStartNewWord(at: character, currentWord: currentWord) {
                results.append(currentWord)
                currentWord = String(character)
            } else {
                currentWord.append(character)
            }
        }
        if !currentWord.isEmpty {
            results.append(currentWord)
        }
        return results
    }

    static func shouldStartNewWord(at character: Character, currentWord: String) -> Bool {
        guard !currentWord.isEmpty, let lastCharacter = currentWord.last else {
            return false
        }
        return lastCharacter.isLowercase && character.isUppercase
    }

    static func joinAsLowerCamelCase(_ words: [String]) -> String {
        guard let firstWord = words.first else { return "" }
        let remainingWords = words.dropFirst().map(capitalizeFirstLetter)
        return firstWord.lowercased() + remainingWords.joined()
    }

    static func joinAsUpperCamelCase(_ words: [String]) -> String {
        words.map(capitalizeFirstLetter).joined()
    }

    static func capitalizeFirstLetter(_ word: String) -> String {
        guard let firstCharacter = word.first else { return "" }
        return firstCharacter.uppercased() + word.dropFirst().lowercased()
    }

    static func escapeForSwift(_ identifier: String) -> String {
        let nonEmpty = fallbackIfEmpty(identifier)
        let leadingDigitSafe = prefixIfStartsWithDigit(nonEmpty)
        return wrapInBackticksIfReservedKeyword(leadingDigitSafe)
    }

    static func fallbackIfEmpty(_ identifier: String) -> String {
        identifier.isEmpty ? "_" : identifier
    }

    static func prefixIfStartsWithDigit(_ identifier: String) -> String {
        guard let first = identifier.first, first.isNumber else {
            return identifier
        }
        return "_" + identifier
    }

    static func wrapInBackticksIfReservedKeyword(_ identifier: String) -> String {
        SwiftReservedKeywords.all.contains(identifier) ? "`\(identifier)`" : identifier
    }
}

private enum SwiftReservedKeywords {
    static let all: Set<String> = [
        "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
        "func", "import", "init", "inout", "internal", "let", "open", "operator",
        "private", "precedencegroup", "protocol", "public", "rethrows", "static",
        "struct", "subscript", "typealias", "var",
        "break", "case", "catch", "continue", "default", "defer", "do", "else",
        "fallthrough", "for", "guard", "if", "in", "repeat", "return", "throw",
        "switch", "where", "while",
        "Any", "as", "false", "is", "nil", "self", "Self", "super", "throws",
        "true", "try"
    ]
}
