import Foundation

struct FileDiscovery {
    func discoverEmbeddableFiles(in rootDirectory: URL) throws -> [EmbeddableFile] {
        let rootComponents = standardizedComponents(of: rootDirectory)
        return try enumerateRegularFiles(under: rootDirectory)
            .filter(hasAllowedExtension)
            .map { fileURL in
                makeEmbeddableFile(at: fileURL, relativeToRootComponents: rootComponents)
            }
            .sorted(by: byRelativePath)
    }

    private func enumerateRegularFiles(under directory: URL) throws -> [URL] {
        guard let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }
        return enumerator.compactMap { $0 as? URL }.filter(isRegularFile)
    }

    private func isRegularFile(_ url: URL) -> Bool {
        (try? url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true
    }

    private func hasAllowedExtension(_ url: URL) -> Bool {
        FileExtensionAllowList.permits(url.pathExtension)
    }

    private func makeEmbeddableFile(
        at fileURL: URL,
        relativeToRootComponents rootComponents: [String]
    ) -> EmbeddableFile {
        let fileComponents = standardizedComponents(of: fileURL)
        let relativeComponents = Array(fileComponents.dropFirst(rootComponents.count))
        return EmbeddableFile(absoluteURL: fileURL, relativePathComponents: relativeComponents)
    }

    private func standardizedComponents(of url: URL) -> [String] {
        url.standardizedFileURL.resolvingSymlinksInPath().pathComponents
    }

    private func byRelativePath(_ lhs: EmbeddableFile, _ rhs: EmbeddableFile) -> Bool {
        lhs.relativePath.localizedStandardCompare(rhs.relativePath) == .orderedAscending
    }
}
