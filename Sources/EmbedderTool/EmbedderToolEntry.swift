import Foundation

@main
enum EmbedderToolEntry {
    static func main() {
        do {
            let invocation = try CommandLineInvocation.parse(CommandLine.arguments)
            try EmbedderTool().run(invocation: invocation)
        } catch {
            reportFailure(error)
            exit(1)
        }
    }

    private static func reportFailure(_ error: Error) {
        FileHandle.standardError.write(Data("EmbedderTool: \(error)\n".utf8))
    }
}
