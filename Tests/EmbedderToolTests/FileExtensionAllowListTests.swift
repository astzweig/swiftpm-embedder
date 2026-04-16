import Testing
@testable import EmbedderTool

@Suite("FileExtensionAllowList") struct FileExtensionAllowListTests {

    @Test("permits common textual formats")
    func permitsTextual() {
        let textual = ["json", "yaml", "yml", "html", "eml", "txt", "md", "xml", "csv", "svg"]
        for fileExtension in textual {
            #expect(FileExtensionAllowList.permits(fileExtension))
        }
    }

    @Test("ignores letter casing")
    func caseInsensitive() {
        #expect(FileExtensionAllowList.permits("JSON"))
        #expect(FileExtensionAllowList.permits("Html"))
    }

    @Test("rejects known binary extensions")
    func rejectsBinary() {
        let binary = ["png", "jpg", "jpeg", "pdf", "zip", "gif", "ttf", "woff", "mp3", "mp4"]
        for fileExtension in binary {
            #expect(!FileExtensionAllowList.permits(fileExtension))
        }
    }

    @Test("rejects files without an extension")
    func rejectsMissingExtension() {
        #expect(!FileExtensionAllowList.permits(""))
    }
}
