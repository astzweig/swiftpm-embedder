import Foundation

struct FileContentReader {
    func readTextContent(of file: EmbeddableFile) throws -> String {
        do {
            return try String(contentsOf: file.absoluteURL, encoding: .utf8)
        } catch {
            throw FileContentReaderError.couldNotDecodeAsUTF8(
                path: file.absoluteURL.path,
                underlying: error
            )
        }
    }
}

enum FileContentReaderError: Error, CustomStringConvertible {
    case couldNotDecodeAsUTF8(path: String, underlying: Error)

    var description: String {
        switch self {
        case .couldNotDecodeAsUTF8(let path, let underlying):
            return "failed to read \(path) as UTF-8: \(underlying.localizedDescription)"
        }
    }
}
