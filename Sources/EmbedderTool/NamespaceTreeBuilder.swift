import Foundation

struct NamespaceTreeBuilder {
    static let rootNamespaceName = "Embedded"

    func buildTree(from files: [EmbeddableFile]) -> NamespaceNode {
        var root = NamespaceNode(name: Self.rootNamespaceName)
        for file in files {
            insertFile(file, into: &root)
        }
        sortRecursively(&root)
        return root
    }

    private func insertFile(_ file: EmbeddableFile, into root: inout NamespaceNode) {
        placeFile(file, atRemainingPath: file.directoryComponents, within: &root)
    }

    private func placeFile(
        _ file: EmbeddableFile,
        atRemainingPath remainingPath: [String],
        within node: inout NamespaceNode
    ) {
        guard let nextDirectoryName = remainingPath.first else {
            node.files.append(file)
            return
        }
        let childName = IdentifierSanitizer.typeName(from: nextDirectoryName)
        let deeperPath = Array(remainingPath.dropFirst())
        placeFile(file, atPath: deeperPath, inChildNamed: childName, of: &node)
    }

    private func placeFile(
        _ file: EmbeddableFile,
        atPath deeperPath: [String],
        inChildNamed childName: String,
        of parent: inout NamespaceNode
    ) {
        if let existingIndex = parent.subNamespaces.firstIndex(where: { $0.name == childName }) {
            placeFile(file, atRemainingPath: deeperPath, within: &parent.subNamespaces[existingIndex])
        } else {
            var freshChild = NamespaceNode(name: childName)
            placeFile(file, atRemainingPath: deeperPath, within: &freshChild)
            parent.subNamespaces.append(freshChild)
        }
    }

    private func sortRecursively(_ node: inout NamespaceNode) {
        node.files.sort { $0.filename.localizedStandardCompare($1.filename) == .orderedAscending }
        node.subNamespaces.sort { $0.name < $1.name }
        for index in node.subNamespaces.indices {
            sortRecursively(&node.subNamespaces[index])
        }
    }
}
