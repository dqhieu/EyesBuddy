//
//  MenuBarView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI

struct MenuBarView: View {
  
  @Environment(\.dismiss) var dismiss
  @ObservedObject var sessionManager = SessionManager.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      HStack {
        Text(sessionManager.remainingSessionTimeString)
          .font(.largeTitle)
          .fontDesign(.rounded)
          .fontWeight(.semibold)
          .monospacedDigit()
          .contentTransition(.numericText(countsDown: true))
          .transaction { transaction in
            transaction.animation = .default
          }
        Spacer()
        Button(action: {
          if sessionManager.sessionTimer == nil {
            sessionManager.startSession()
          } else {
            sessionManager.stopSession()
          }
        }, label: {
          if #available(macOS 14, *) {
            Image(systemName: sessionManager.sessionTimer == nil ? "play.circle" : "stop.circle.fill")
              .imageScale(.large)
              .contentTransition(.symbolEffect(.replace))
          } else {
            Image(systemName: sessionManager.sessionTimer == nil ? "play.circle" : "stop.circle.fill")
              .imageScale(.large)
          }
        })
        .buttonStyle(PlainButtonStyle())
      }
      HStack {
        Button(action: {
          dismiss()
          let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
          let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
          let task = Process()
          task.launchPath = "/usr/bin/open"
          task.arguments = [path]
          task.launch()
        }, label: {
          Image(systemName: "gear")
            .imageScale(.large)
        })
        .buttonStyle(PlainButtonStyle())
        Spacer()
        Button(action: {
          NSApplication.shared.terminate(nil)
        }, label: {
          Image(systemName: "power")
            .imageScale(.large)
        })
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding()
    .frame(width: 140)
  }
}

#Preview {
  MenuBarView()
}
