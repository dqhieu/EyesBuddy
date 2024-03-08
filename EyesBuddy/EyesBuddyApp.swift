//
//  EyesBuddyApp.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI
import Sparkle
import TelemetryClient
import SettingsAccess

@main
struct EyesBuddyApp: App {
  
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  @AppStorage("autoStartSessionWhenLaunch") var autoStartSessionWhenLaunch = false
  
  private let updaterController: SPUStandardUpdaterController
  let detector = MouseActivityDetector.shared
  
  
  init() {
    
    // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
    // This is where you can also pass an updater delegate if you need one
    updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    let configuration = TelemetryManagerConfiguration(appID: "YOUR_TELEMETRY_ID")
    TelemetryManager.initialize(with: configuration)
    if autoStartSessionWhenLaunch, SessionManager.shared.sessionState == .idle {
      SessionManager.shared.startSession()
    }
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView()
        .openSettingsAccess()
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
        .openSettingsAccess()
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
    MouseActivityDetector.shared.stopMonitoring()
    MouseActivityDetector.shared.startGlobalMonitor()
    NSApp.setActivationPolicy(.accessory)
    return false
  }
  
  func applicationWillFinishLaunching(_ notification: Notification) {
    NSWindow.allowsAutomaticWindowTabbing = false
  }
  
  func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    NSApp.setActivationPolicy(.regular)
    MouseActivityDetector.shared.stopMonitoring()
    MouseActivityDetector.shared.startLocalMonitor()
    return true
  }
  
}
