import Foundation
import Testing
@testable import EmbedderTool

@Suite("NamespaceTreeBuilder") struct NamespaceTreeBuilderTests {

    @Test("places top-level files directly inside the root namespace")
    func topLevelFiles() {
        let files = [
            makeFile(relativePath: "config.json"),
            makeFile(relativePath: "welcome.html")
        ]
        let tree = NamespaceTreeBuilder().buildTree(from: files)

        #expect(tree.name == "Embedded")
        #expect(tree.files.map(\.filename) == ["config.json", "welcome.html"])
        #expect(tree.subNamespaces.isEmpty)
    }

    @Test("nests subdirectories as child enums")
    func nestedDirectories() {
        let files = [
            makeFile(relativePath: "emails/welcome.html"),
            makeFile(relativePath: "emails/receipt.eml"),
            makeFile(relativePath: "root.json")
        ]
        let tree = NamespaceTreeBuilder().buildTree(from: files)

        #expect(tree.files.map(\.filename) == ["root.json"])
        #expect(tree.subNamespaces.count == 1)
        #expect(tree.subNamespaces[0].name == "Emails")
        #expect(tree.subNamespaces[0].files.map(\.filename) == ["receipt.eml", "welcome.html"])
    }

    @Test("merges multiple files under the same sanitized directory name")
    func mergesSiblingNamespaces() {
        let files = [
            makeFile(relativePath: "user-templates/a.json"),
            makeFile(relativePath: "user-templates/b.json")
        ]
        let tree = NamespaceTreeBuilder().buildTree(from: files)

        #expect(tree.subNamespaces.count == 1)
        #expect(tree.subNamespaces[0].name == "UserTemplates")
        #expect(tree.subNamespaces[0].files.count == 2)
    }

    @Test("preserves deep hierarchies")
    func deepHierarchy() {
        let files = [
            makeFile(relativePath: "api/v2/users/list.json")
        ]
        let tree = NamespaceTreeBuilder().buildTree(from: files)

        #expect(tree.subNamespaces.count == 1)
        #expect(tree.subNamespaces[0].name == "Api")
        #expect(tree.subNamespaces[0].subNamespaces[0].name == "V2")
        #expect(tree.subNamespaces[0].subNamespaces[0].subNamespaces[0].name == "Users")
        #expect(tree.subNamespaces[0].subNamespaces[0].subNamespaces[0].files.map(\.filename) == ["list.json"])
    }

    private func makeFile(relativePath: String) -> EmbeddableFile {
        let components = relativePath.split(separator: "/").map(String.init)
        let absoluteURL = URL(fileURLWithPath: "/fake/Static Inline").appending(path: relativePath)
        return EmbeddableFile(absoluteURL: absoluteURL, relativePathComponents: components)
    }
}
