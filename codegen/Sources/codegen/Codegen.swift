import ArgumentParser
import Foundation

@main
struct Codegen: ParsableCommand {
    enum Error: LocalizedError {
        case invalidFolderURL

        var errorDescription: String? {
            switch self {
            case .invalidFolderURL:
                return "The specified path must be a valid directory."
            }
        }
    }

    @Argument(help: "The folder path to emit *.generated.swift files",
              transform: URL.init(fileURLWithPath:))
    var folderURL: URL

    func generatedFile(named name: String) -> URL {
        folderURL.appending(path: "\(name).generated.swift", directoryHint: .notDirectory)
    }

    func validate() throws {
        var isDirectory: ObjCBool = false
        let fileExists = FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDirectory)
        guard fileExists, isDirectory.boolValue else {
            throw Error.invalidFolderURL
        }
    }

    mutating func run() throws {
        let params = 10
        try TypedFunction.generate(maxParams: params).result().write(to: generatedFile(named: "TypedFunction"), atomically: true, encoding: .utf8)
        try ThreadsafeTypedFunction.generate(maxParams: params).result().write(to: generatedFile(named: "ThreadsafeTypedFunction"), atomically: true, encoding: .utf8)
        try Method.generate(maxParams: params).result().write(to: generatedFile(named: "MethodDescriptor"), atomically: true, encoding: .utf8)
        try InstanceMethod.generate(maxParams: params).result().write(to: generatedFile(named: "InstanceMethodDescriptor"), atomically: true, encoding: .utf8)
        try ObjectReferenceMethods.generate(maxParams: params).result().write(to: generatedFile(named: "ObjectReferenceMethods"), atomically: true, encoding: .utf8)
        try EventEmitter.generate(maxParams: params).result().write(to: generatedFile(named: "EventEmitter"), atomically: true, encoding: .utf8)
        try IPCMain.generate(maxParams: params).result().write(to: generatedFile(named: "IPCMain"), atomically: true, encoding: .utf8)
        try WebContents.generate(maxParams: params).result().write(to: generatedFile(named: "WebContents"), atomically: true, encoding: .utf8)
    }
}

enum Types {
    static let valueConvertible = "ValueConvertible"
}
