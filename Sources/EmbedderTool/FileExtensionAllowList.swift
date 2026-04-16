import Foundation

enum FileExtensionAllowList {
    static let textualExtensions: Set<String> = [
        "css",
        "csv",
        "eml",
        "gql",
        "graphql",
        "htm",
        "html",
        "ini",
        "js",
        "json",
        "jsonl",
        "log",
        "markdown",
        "md",
        "mjs",
        "plist",
        "sql",
        "svg",
        "toml",
        "tsv",
        "txt",
        "xml",
        "yaml",
        "yml"
    ]

    static func permits(_ fileExtension: String) -> Bool {
        textualExtensions.contains(fileExtension.lowercased())
    }
}
