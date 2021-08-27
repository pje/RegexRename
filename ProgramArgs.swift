import Foundation

struct ProgramArgs {
  public var files: [URL] = []

  static func parseFromCommandLine() -> ProgramArgs {
    ProgramArgs(
      files: CommandLine
        .arguments
        .dropFirst()
        .filter { FileManager.default.fileExists(atPath: $0) }
        .map { URL(string: $0)! }
    )
  }
}
