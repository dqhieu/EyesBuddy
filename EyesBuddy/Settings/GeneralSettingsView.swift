//
//  GeneralSettingsView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 30/10/2023.
//

import SwiftUI
import LaunchAtLogin

struct GeneralSettingsView: View {
  
  @AppStorage("autoStartSessionWhenLaunch") var autoStartSessionWhenLaunch = false
  @AppStorage("autoRestartSessionWhenUnlock") var autoRestartSessionWhenUnlock = true
  @AppStorage("sessionDuration") var sessionDuration = 20 // minutes
  @AppStorage("relaxDuration") var relaxDuration = 20 // seconds
  @AppStorage("inactiveDuration") var inactiveDuration = 5 // minutes
  @AppStorage("inactiveResumeType") var inactiveResumeType = 0
  
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
  
  var body: some View {
    Form {
      Toggle("Start session when app is opened", isOn: $autoStartSessionWhenLaunch)
        .toggleStyle(.switch)
      Toggle("Restart session when screen is unlocked", isOn: $autoRestartSessionWhenUnlock)
        .toggleStyle(.switch)
      Picker("Stop session when mouse is inactive", selection: $inactiveDuration) {
        ForEach(inactiveDurations, id: \.self) { duration in
          if duration == 0 {
            Text("None").tag(duration)
          } else if duration == 1 {
            Text("For \(duration) minute").tag(duration)
          } else {
            Text("For \(duration) minutes").tag(duration)
          }
        }
      }
      .pickerStyle(.menu)
      if inactiveDuration > 0 {
        Picker("When resume from inactivity", selection: $inactiveResumeType) {
          Text("Restart session").tag(0)
          Text("Continue session").tag(1)
        }
        .pickerStyle(.menu)
      }
      Picker("Session duration", selection: $sessionDuration) {
        ForEach(sessionDurations, id: \.self) { duration in
          Text("\(duration) minutes").tag(duration)
        }
      }
      .pickerStyle(.menu)
      Picker("Relax duration", selection: $relaxDuration) {
        ForEach(relaxDurations, id: \.self) { duration in
          Text("\(duration) seconds").tag(duration)
        }
      }
      .pickerStyle(.menu)
      LaunchAtLogin.Toggle()
    }
    .formStyle(.grouped)
    .frame(width: 440, height: 300)
    .scrollDisabled(true)
  }
}

#Preview {
  GeneralSettingsView()
}
