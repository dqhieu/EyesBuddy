//
//  HomeView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI
import AppKit
import Sparkle

struct HomeView: View {
  
  @StateObject var sessionManager = SessionManager.shared
  @AppStorage("autoStartNewSession") var autoStartNewSession = false
  @AppStorage("startAtLogin") var startAtLogin = false
  private let updater: SPUUpdater
  @State private var automaticallyChecksForUpdates: Bool
  @State private var automaticallyDownloadsUpdates: Bool
  
  init(updater: SPUUpdater) {
    self.updater = updater
    self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
    self.automaticallyDownloadsUpdates = updater.automaticallyDownloadsUpdates
  }
  
  var body: some View {
    VStack {
      Spacer()
        .frame(height: 24)
      Text(sessionManager.remainingSessionTimeString)
        .font(.largeTitle)
        .fontDesign(.rounded)
        .fontWeight(.semibold)
        .monospacedDigit()
        .contentTransition(.numericText(countsDown: true))
        .transaction { transaction in
          transaction.animation = .default
        }
        .foregroundStyle(sessionManager.sessionTimer == nil ? .secondary : .primary)
      Button(action: {
        if sessionManager.sessionTimer == nil {
          sessionManager.startSession()
        } else {
          sessionManager.stopSession()
        }
        
      }, label: {
        Text(sessionManager.sessionTimer == nil ? "Start session" : "Stop session")
      })
      VStack(alignment: .leading, content: {
        Toggle("Automatically start new session when the current session ends", isOn: $autoStartNewSession)
        Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
          .onChange(of: automaticallyChecksForUpdates) { newValue in
            updater.automaticallyChecksForUpdates = newValue
          }
        
        Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
          .disabled(!automaticallyChecksForUpdates)
          .onChange(of: automaticallyDownloadsUpdates) { newValue in
            updater.automaticallyDownloadsUpdates = newValue
          }
      })
      
      Spacer()
        .frame(height: 24)
      Button(action: {
        sessionManager.stopSession()
        sessionManager.showReminderWindow()
        sessionManager.startRelaxSession()
      }, label: {
        Text("Show reminder")
      })
      Button(action: {
        NSApplication.shared.terminate(nil)
      }, label: {
        Text("Quit")
      })
      Spacer()
    }
    .frame(width: 400, height: 240, alignment: .center)
  }
}

#Preview {
  HomeView(updater: SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil).updater)
}
