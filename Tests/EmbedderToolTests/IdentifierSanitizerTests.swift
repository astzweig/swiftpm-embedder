import Testing
@testable import EmbedderTool

@Suite("IdentifierSanitizer") struct IdentifierSanitizerTests {

    @Test("converts a simple filename with extension to lowerCamelCase")
    func simpleFilename() {
        #expect(IdentifierSanitizer.propertyName(fromFilename: "welcome.html") == "welcomeHtml")
        #expect(IdentifierSanitizer.propertyName(fromFilename: "config.json") == "configJson")
    }

    @Test("normalizes uppercase and mixed case extensions")
    func uppercaseExtension() {
        #expect(IdentifierSanitizer.propertyName(fromFilename: "welcome.HTML") == "welcomeHtml")
        #expect(IdentifierSanitizer.propertyName(fromFilename: "Data.Yaml") == "dataYaml")
    }

    @Test("splits snake_case, kebab-case and camelCase into words")
    func splitWords() {
        #expect(IdentifierSanitizer.propertyName(fromFilename: "user_profile.json") == "userProfileJson")
        #expect(IdentifierSanitizer.propertyName(fromFilename: "email-template.eml") == "emailTemplateEml")
        #expect(IdentifierSanitizer.propertyName(fromFilename: "fooBar.json") == "fooBarJson")
    }

    @Test("prefixes an underscore when a filename starts with a digit")
    func digitPrefix() {
        #expect(IdentifierSanitizer.propertyName(fromFilename: "404.html") == "_404Html")
    }

    @Test("escapes Swift reserved keywords with backticks")
    func reservedKeyword() {
        #expect(IdentifierSanitizer.propertyName(fromFilename: "class") == "`class`")
        #expect(IdentifierSanitizer.propertyName(fromFilename: "return") == "`return`")
    }

    @Test("collapses runs of non-alphanumeric characters")
    func multipleSeparators() {
        #expect(IdentifierSanitizer.propertyName(fromFilename: "user--profile__v2.json") == "userProfileV2Json")
    }

    @Test("produces UpperCamelCase type names for directories")
    func typeNames() {
        #expect(IdentifierSanitizer.typeName(from: "emails") == "Emails")
        #expect(IdentifierSanitizer.typeName(from: "user-templates") == "UserTemplates")
        #expect(IdentifierSanitizer.typeName(from: "api_v2") == "ApiV2")
    }

    @Test("returns an underscore fallback when the identifier would be empty")
    func emptyFallback() {
        #expect(IdentifierSanitizer.propertyName(fromFilename: "---") == "_")
        #expect(IdentifierSanitizer.typeName(from: "") == "_")
    }
}
