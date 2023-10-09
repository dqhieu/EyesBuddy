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
      
      Spacer()
        .frame(height: 24)
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
  HomeView()
}
