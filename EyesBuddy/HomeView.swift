//
//  HomeView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI
import AppKit
import LaunchAtLogin

struct HomeView: View {
  
  @StateObject var sessionManager = SessionManager.shared
  @AppStorage("autoStartNewSession") var autoStartNewSession = false
  @AppStorage("startAtLogin") var startAtLogin = false
  
  
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
        Toggle("Auto start new session when the current session ends", isOn: $autoStartNewSession)
        LaunchAtLogin.Toggle()
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
    .frame(width: 400, height: 300, alignment: .center)
  }
}

#Preview {
  HomeView()
}
