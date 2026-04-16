import Foundation

struct EmbeddableFile: Equatable {
    let absoluteURL: URL
    let relativePathComponents: [String]
}

extension EmbeddableFile {
    var filename: String {
        relativePathComponents.last ?? absoluteURL.lastPathComponent
    }

    var directoryComponents: [String] {
        Array(relativePathComponents.dropLast())
    }

    var relativePath: String {
        relativePathComponents.joined(separator: "/")
    }
}
