import Foundation

struct EmbedderTool {
    func run(invocation: CommandLineInvocation) throws {
        let discoveredFiles = try FileDiscovery().discoverEmbeddableFiles(in: invocation.sourceDirectory)
        let namespaceTree = NamespaceTreeBuilder().buildTree(from: discoveredFiles)
        let generatedSource = try SwiftCodeGenerator().generate(from: namespaceTree)
        try writeAtomically(generatedSource, to: invocation.outputFile)
    }

    private func writeAtomically(_ contents: String, to file: URL) throws {
        try createParentDirectoryIfNeeded(for: file)
        try contents.write(to: file, atomically: true, encoding: .utf8)
    }

    private func createParentDirectoryIfNeeded(for file: URL) throws {
        let parent = file.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true)
    }
}
