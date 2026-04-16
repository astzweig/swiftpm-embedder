import Foundation

struct NamespaceNode: Equatable {
    var name: String
    var files: [EmbeddableFile]
    var subNamespaces: [NamespaceNode]

    init(
        name: String,
        files: [EmbeddableFile] = [],
        subNamespaces: [NamespaceNode] = []
    ) {
        self.name = name
        self.files = files
        self.subNamespaces = subNamespaces
    }
}
