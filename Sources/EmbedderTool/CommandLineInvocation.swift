import Foundation

struct CommandLineInvocation {
    let sourceDirectory: URL
    let outputFile: URL
}

extension CommandLineInvocation {
    static func parse(_ arguments: [String]) throws -> CommandLineInvocation {
        guard arguments.count == 3 else {
            throw CommandLineInvocationError.wrongNumberOfArguments(received: arguments.count - 1)
        }
        return CommandLineInvocation(
            sourceDirectory: URL(fileURLWithPath: arguments[1]),
            outputFile: URL(fileURLWithPath: arguments[2])
        )
    }
}

enum CommandLineInvocationError: Error, CustomStringConvertible {
    case wrongNumberOfArguments(received: Int)

    var description: String {
        switch self {
        case .wrongNumberOfArguments(let received):
            return "expected 2 arguments (source directory, output file); received \(received)"
        }
    }
}
