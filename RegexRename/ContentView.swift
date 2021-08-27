import Foundation
import SwiftUI
import OSAKit
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

struct ContentView: View {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var fileManager: FileManager = FileManager.default
  var files: [URL] = [ URL(fileURLWithPath: "") ]
  @State var findPattern: String = ""
  @State var replacePattern: String = ""
  @State var compiledFindRegex: NSRegularExpression? = nil
  @State var findPatternIsValid: Bool = true
  @State var isEditing: Bool = false

  private func validateFindPattern() -> Void {
    self.compiledFindRegex = ContentView.tryCompileRegex(findPattern)
    self.findPatternIsValid = (compiledFindRegex != nil)
  }

  static func tryCompileRegex(_ regex: String) -> NSRegularExpression? {
    try? NSRegularExpression(pattern: regex)
  }

  private static func RegexRenameFile(_ filePathFrom: String, _ filePathTo: String) -> Result<Void, Error> {
    return Result { try FileManager.default.moveItem(atPath: filePathFrom, toPath: filePathTo) }
  }

  private func doRegexRename(_ files: [URL], _ regex: NSRegularExpression, _ replacePattern: String) -> Void {
    files.forEach { (file) in
      let (from, to) = (file.absoluteString, file.absoluteString.replace(regex, replacePattern))
      let result = ContentView.RegexRenameFile(from, to)

      switch result {
        case .success(_):
          return;
        case .failure(let e):
          print("error moving file: \"\(from)\" to \"\(to)\" ::: \(e)");
          return;
      }
    }

    return;
  }

  private func doRegexRename(_ files: URL..., regex: NSRegularExpression, replace: String) -> Void {
    doRegexRename(files, regex, replace)
  }

  var body: some View {
    let fileNamePreviews = files.compactMap { NSURL(string: $0.relativePath)?.lastPathComponent }

    let diff = ScrollView {
      HStack {
        LazyVStack(alignment: .leading) {
          ForEach(fileNamePreviews, id: \.self) { file in
            Text(file)
          }
        }
        LazyVStack(alignment: .leading) {
          ForEach(fileNamePreviews, id: \.self) { file in
            Text(
              compiledFindRegex == nil
                ? file
                : file.replace(compiledFindRegex!, replacePattern)
            )
          }
        }
      }
      .font(.system(.body, design: .monospaced))
    }
    .frame(
      minWidth: 0,
      idealWidth: 100,
      maxWidth: .infinity,
      minHeight: 0,
      idealHeight: 200,
      maxHeight: .infinity,
      alignment: .center
    )

    let findField = TextField(
      "find",
      text: $findPattern,
      onCommit: { validateFindPattern() }
    )
    .onChange(of: findPattern, perform: { s in validateFindPattern() })
    .disableAutocorrection(true)

    let replaceField = TextField(
      "replace",
      text: $replacePattern
    )
    .disableAutocorrection(true)

    let confirmButton = Button(
      "Replace",
      action: {
        compiledFindRegex.map { re in
          doRegexRename(files, re, replacePattern)
          close()
        }
      }
    )
//    .background(Color(.controlAccentColor))
//    .cornerRadius(5)
    .disabled(isButtonDisabled)

    let cancelButton = Button("Cancel", action: close)
      .onExitCommand(perform: close)

    let findAndReplace = Group {
      findField
      replaceField
    }.frame(
      minWidth: 100,
      idealWidth: 100,
      maxWidth: nil,
      minHeight: nil,
      idealHeight: nil,
      maxHeight: nil,
      alignment: .center
    )
    .padding(.horizontal, 10)

    let cancelAndConfirm = HStack {
      cancelButton
      confirmButton
    }.padding(10)

    return VStack {
      diff
      findAndReplace
      cancelAndConfirm
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 10)
    .onExitCommand(perform: close)
  }

  private func close() -> Void {
    NSApplication.shared.windows.forEach { window in
      window.close()
    }
  }

  var isButtonDisabled: Bool { !findPatternIsValid || findPattern.isEmpty }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      files: ProgramArgs.parseFromCommandLine().files,
      findPattern: #"\d"#,
      replacePattern: "x",
      compiledFindRegex: ContentView.tryCompileRegex("x")
    ).previewLayout(.sizeThatFits)
  }
}
