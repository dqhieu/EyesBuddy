//
//  UpdateSettingsView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 30/10/2023.
//

import SwiftUI
import Sparkle

struct UpdateSettingsView: View {
  
  private let updater: SPUUpdater
  @State private var automaticallyChecksForUpdates: Bool
  @State private var automaticallyDownloadsUpdates: Bool
  
  init(updater: SPUUpdater) {
    self.updater = updater
    self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
    self.automaticallyDownloadsUpdates = updater.automaticallyDownloadsUpdates
  }
  
  var body: some View {
    Form {
      Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
        .onChange(of: automaticallyChecksForUpdates) { newValue in
          updater.automaticallyChecksForUpdates = newValue
        }
        .toggleStyle(.switch)
      Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
        .disabled(!automaticallyChecksForUpdates)
        .onChange(of: automaticallyDownloadsUpdates) { newValue in
          updater.automaticallyDownloadsUpdates = newValue
        }
        .toggleStyle(.switch)
      HStack {
        Spacer()
        Button {
          updater.checkForUpdates()
        } label: {
          Text("Check for Updates")
        }
        Spacer()
      }
    }
    .formStyle(.grouped)
    .frame(width: 440, height: 155)
    .scrollDisabled(true)
  }
}

#Preview {
  UpdateSettingsView(updater: SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil).updater)
}
