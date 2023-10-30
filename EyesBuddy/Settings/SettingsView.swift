//
//  SettingsView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 09/10/2023.
//

import SwiftUI
import Sparkle

struct SettingsView: View {
  
  @AppStorage("autoStartSessionWhenLaunch") var autoStartSessionWhenLaunch = false
  @AppStorage("autoRestartSessionWhenUnlock") var autoRestartSessionWhenUnlock = true
  @AppStorage("sessionDuration") var sessionDuration = 20 // minutes
  @AppStorage("relaxDuration") var relaxDuration = 20 // seconds
  @AppStorage("inactiveDuration") var inactiveDuration = 5 // minutes
  @AppStorage("inactiveResumeType") var inactiveResumeType = 0
  
  let sessionManager = SessionManager.shared
  
  private let updater: SPUUpdater
  
  var sessionDurations: [Int] {
    #if DEBUG
    return [1, 10, 20, 30, 45, 60]
    #endif
    return [10, 20, 30, 45, 60]
  }
  
  var relaxDurations: [Int] {
    #if DEBUG
    return [20, 30, 45, 60]
    #endif
    return [10, 20, 30, 45, 60]
  }
  
  var inactiveDurations: [Int] {
    return [0, 1, 2, 3, 5, 10]
  }
  
  init(updater: SPUUpdater) {
    self.updater = updater
  }
  
  var body: some View {
    TabView {
      GeneralSettingsView()
      .tabItem {
        Label("General", systemImage: "gearshape")
      }
//      VStack {
//        Picker("Start timer sound", selection: .constant("")) {
//          Text("one")
//          Text("two")
//        }
//        .frame(width: 250)
//        Text("Coming soon")
//      }
//      .tabItem {
//        Label("Sound", systemImage: "speaker.wave.2")
//      }
      UpdateSettingsView(updater: updater)
      .tabItem {
        Label("Updates", systemImage: "arrow.triangle.2.circlepath.circle")
      }
      
//      GroupBox {
//        LicenseView()
//        .padding(8)
//      }
//      .tabItem {
//        Label("License", systemImage: "key.viewfinder")
//      }
      
      
      AboutSettingsView()
      .tabItem {
        Label("About", systemImage: "info.circle")
      }
    }
  }
}

#Preview {
  SettingsView(updater: SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil).updater)
}
