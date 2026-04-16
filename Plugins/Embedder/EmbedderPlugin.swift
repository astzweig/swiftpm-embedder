import Foundation
import PackagePlugin

@main
struct EmbedderPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) async throws -> [Command] {
        guard let sourceModule = target as? SourceModuleTarget else {
            return []
        }
        return try buildCommands(for: sourceModule, in: context)
    }
}

private extension EmbedderPlugin {
    static let staticInlineDirectoryName = "Static Inline"
    static let generatedFileName = "Embedded.swift"
    static let toolName = "EmbedderTool"

    func buildCommands(
        for target: SourceModuleTarget,
        in context: PluginContext
    ) throws -> [Command] {
        guard let staticInlineDirectory = locateStaticInlineDirectory(in: target) else {
            return []
        }
        let inputFiles = try collectInputFiles(under: staticInlineDirectory)
        guard !inputFiles.isEmpty else {
            return []
        }
        return [
            try makeBuildCommand(
                sourceDirectory: staticInlineDirectory,
                inputFiles: inputFiles,
                context: context
            )
        ]
    }

    func locateStaticInlineDirectory(in target: SourceModuleTarget) -> URL? {
        let candidate = target.directoryURL.appending(path: Self.staticInlineDirectoryName)
        return FileSystem.isDirectory(at: candidate) ? candidate : nil
    }

    func collectInputFiles(under directory: URL) throws -> [URL] {
        try FileSystem.regularFiles(under: directory)
    }

    func makeBuildCommand(
        sourceDirectory: URL,
        inputFiles: [URL],
        context: PluginContext
    ) throws -> Command {
        let tool = try context.tool(named: Self.toolName)
        let outputFile = context.pluginWorkDirectoryURL.appending(path: Self.generatedFileName)
        return .buildCommand(
            displayName: "Embedding files from \(Self.staticInlineDirectoryName)",
            executable: tool.url,
            arguments: [
                sourceDirectory.path(percentEncoded: false),
                outputFile.path(percentEncoded: false)
            ],
            inputFiles: inputFiles,
            outputFiles: [outputFile]
        )
    }
}
