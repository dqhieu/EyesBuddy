//
//  SettingsView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 09/10/2023.
//

import SwiftUI
import Sparkle

struct SettingsView: View {
    
  private let updater: SPUUpdater
    
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
