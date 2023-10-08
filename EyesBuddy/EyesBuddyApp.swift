//
//  EyesBuddyApp.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI
import Sparkle

@main
struct EyesBuddyApp: App {
  
  private let updaterController: SPUStandardUpdaterController
  
  init() {
    // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
    // This is where you can also pass an updater delegate if you need one
    updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
  }
  
  var body: some Scene {
    WindowGroup {
      HomeView(updater: updaterController.updater)
    }
    .windowStyle(.hiddenTitleBar)
    .windowResizability(.contentSize)
    .commands {
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
  }
}
