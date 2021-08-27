import SwiftUI

@main
struct renameApp: App {
  @State var args: ProgramArgs = ProgramArgs.parseFromCommandLine()

  var body: some Scene {
    WindowGroup {
      ContentView(
        files: args.files
      )
      .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: hideWindowButtons)
    }
    .windowStyle(HiddenTitleBarWindowStyle())
    .windowToolbarStyle(DefaultWindowToolbarStyle())
  }

  private func hideWindowButtons(_ _: Any?) {
    for window in NSApplication.shared.windows {
      window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
      window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
      window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
      window.titlebarAppearsTransparent = true
    }
  }
}
