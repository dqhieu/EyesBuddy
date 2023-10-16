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
  
  let sessionManager = SessionManager.shared
  
  private let updater: SPUUpdater
  @State private var automaticallyChecksForUpdates: Bool
  @State private var automaticallyDownloadsUpdates: Bool
  
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
  
  init(updater: SPUUpdater) {
    self.updater = updater
    self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
    self.automaticallyDownloadsUpdates = updater.automaticallyDownloadsUpdates
  }
  
  var body: some View {
    TabView {
      VStack(alignment: .leading) {
        Toggle("Automatically start session when app is opened", isOn: $autoStartSessionWhenLaunch)
        Toggle("Automatically restart session when screen is unlocked", isOn: $autoRestartSessionWhenUnlock)
        Picker("Session duration", selection: $sessionDuration) {
          ForEach(sessionDurations, id: \.self) { duration in
            Text("\(duration) minutes").tag(duration)
              
          }
        }
        .frame(width: 240)
        Picker("Relax duration", selection: $relaxDuration) {
          ForEach(relaxDurations, id: \.self) { duration in
            Text("\(duration) seconds").tag(duration)
          }
        }
        .frame(width: 240)
      }
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
      VStack(alignment: .leading) {
        Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
          .onChange(of: automaticallyChecksForUpdates) { newValue in
            updater.automaticallyChecksForUpdates = newValue
          }
        
        Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
          .disabled(!automaticallyChecksForUpdates)
          .onChange(of: automaticallyDownloadsUpdates) { newValue in
            updater.automaticallyDownloadsUpdates = newValue
          }
      }
      .tabItem {
        Label("Updates", systemImage: "arrow.triangle.2.circlepath.circle")
      }
      
      VStack(spacing: 12) {
        Image("MacAppIcon")
          .resizable()
          .scaledToFit()
          .frame(width: 64, height: 64)
        Text("Eyes Buddy")
          .font(.title2)
          .bold()
        Text("Version \(appVersion)")
          .font(.callout)
        Text("© 2023 Dinh Quang Hieu")
          .font(.callout)
        if let url = URL(string: "https://eyesbuddy.app") {
          Link("eyesbuddy.app", destination: url)
        }
      }
      .padding(.bottom)
      .tabItem {
        Label("About", systemImage: "info.circle")
      }
#if DEBUG
      VStack {
        
        Button(action: {
          sessionManager.stopSession()
          sessionManager.showReminderWindow()
          sessionManager.startRelaxSession()
        }, label: {
          Text("Show reminder")
        })
        Button {
          // we use -n to open a new instance, to avoid calling applicationShouldHandleReopen
          // we use Bundle.main.bundlePath in case of multiple AltTab versions on the machine
          Process.launchedProcess(launchPath: "/usr/bin/open", arguments: ["-n", Bundle.main.bundlePath])
          NSApplication.shared.terminate(self)
        } label: {
          Text("Reset settings")
        }
        
      }
      .tabItem {
        Label("DEBUG", systemImage: "hammer")
      }
#endif
    }
    .padding()
    .frame(width: 400)
  }
  
  var appVersion: String {
    let source: String = "D"
    var result = ""
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      result = appVersion
    }
    if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
      result += " (\(buildNumber + source))"
    }
    
    return result
  }
}

#Preview {
  SettingsView(updater: SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil).updater)
}
