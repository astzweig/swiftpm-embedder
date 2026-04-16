# Embedder

A Swift Package Manager build-tool plugin that compiles every textual file in a
target's `Static Inline` subdirectory into a generated `Embedded` enum with
`static let` properties for each file.

The generated code embeds file contents as raw string literals at build time;
no bundle or runtime I/O is involved.

## Usage

1. Add this package as a dependency:

   ```swift
   .package(url: "https://github.com/astzweig/swiftpm-embedder", from: "1.0.0")
   ```

2. Apply the plugin to your target and exclude the `Static Inline` directory
   from the target's own source scan:

   ```swift
   .target(
       name: "MyApp",
       exclude: ["Static Inline"],
       plugins: [
           .plugin(name: "Embedder", package: "swiftpm-embedder")
       ]
   )
   ```

3. Place your text assets under `Sources/<Target>/Static Inline/`:

   ```
   Sources/<Target>/
       MyApp.swift
       Static Inline/
           config.json
           emails/
               welcome.html
               receipt.eml
   ```

4. Reference the generated constants from your code:

   ```swift
   let welcomeBody: String = Embedded.Emails.welcomeHtml
   let config: String = Embedded.configJson
   ```

## Generated shape

Given the tree above, the plugin produces:

```swift
enum Embedded {
    static let configJson: String = #"""
    {"appName": "Sample"}
    """#

    enum Emails {
        static let receiptEml: String = #"""
        Subject: Your receipt
        """#

        static let welcomeHtml: String = #"""
        <!doctype html>
        ...
        """#
    }
}
```

Subdirectories become nested enums with `UpperCamelCase` names; files become
`lowerCamelCase` `static let` properties. Filenames that start with a digit or
collide with Swift reserved words are escaped automatically.

## Allowed extensions

The plugin only embeds files whose extension is in a curated textual allow-list
(`json`, `yaml`, `yml`, `html`, `htm`, `eml`, `txt`, `md`, `markdown`, `xml`,
`csv`, `tsv`, `svg`, `css`, `js`, `mjs`, `sql`, `graphql`, `gql`, `toml`, `ini`,
`log`, `plist`, `jsonl`). Other files are ignored, so dropping an image or a
font into `Static Inline` is harmless.

## Requirements

- `swift-tools-version: 6.1` or newer
- macOS 13+, iOS 16+, tvOS 16+, or watchOS 9+ for packages that consume the
  plugin
