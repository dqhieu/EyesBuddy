//
//  EyesBuddyApp.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI
import Sparkle
import TelemetryClient

@main
struct EyesBuddyApp: App {
  
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @AppStorage("autoStartSessionWhenLaunch") var autoStartSessionWhenLaunch = false
  
  private let updaterController: SPUStandardUpdaterController
  
  init() {
    // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
    // This is where you can also pass an updater delegate if you need one
    updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    let configuration = TelemetryManagerConfiguration(appID: "2E6FCBEB-E2B0-4675-81D6-E74BF1ECB09E")
    TelemetryManager.initialize(with: configuration)
    if autoStartSessionWhenLaunch, SessionManager.shared.sessionTimer == nil {
      SessionManager.shared.startSession()
    }
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
    .commands {
      CommandGroup(replacing: .newItem, addition: { })
      CommandGroup(after: .appInfo) {
        CheckForUpdatesView(updater: updaterController.updater)
      }
    }
    MenuBarExtra {
      MenuBarView()
    } label: {
      Label("MyApp", systemImage: "eyes")
    }
    .menuBarExtraStyle(.window)
    Settings {
      SettingsView(updater: updaterController.updater)
    }
  }
}

class AppDelegate: NSObject, NSApplicationDelegate {
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    TelemetryManager.send("applicationDidFinishLaunching")
  }
  
  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    NSApp.setActivationPolicy(.accessory)
    return false
  }
  
  func applicationWillFinishLaunching(_ notification: Notification) {
    NSWindow.allowsAutomaticWindowTabbing = false
  }
  
}
