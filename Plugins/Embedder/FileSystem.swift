import Foundation

enum FileSystem {
	static func isDirectory(at url: URL) -> Bool {
		let resourceValues = try? url.resourceValues(forKeys: [.isDirectoryKey])
		return resourceValues?.isDirectory == true
	}

	static func regularFiles(under directory: URL) throws -> [URL] {
		guard let enumerator = FileManager.default.enumerator(
			at: directory,
			includingPropertiesForKeys: [.isRegularFileKey],
			options: [.skipsHiddenFiles]
		) else {
			return []
		}
		return enumerator
			.compactMap { $0 as? URL }
			.filter(isRegularFile)
	}

	private static func isRegularFile(_ url: URL) -> Bool {
		(try? url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true
	}
}
