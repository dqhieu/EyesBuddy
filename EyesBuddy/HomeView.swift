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
  
  @ObservedObject var sessionManager = SessionManager.shared
  @Namespace var namespace
  
  var body: some View {
    VStack(spacing: 8) {
      HStack {
        if sessionManager.sessionTimer != nil {
          Text(sessionManager.remainingSessionTimeString)
            .font(.largeTitle)
            .fontDesign(.rounded)
            .fontWeight(.semibold)
            .monospacedDigit()
            .contentTransition(.numericText(countsDown: true))
            .transaction { transaction in
              transaction.animation = .default
            }
          Button(action: {
            withAnimation {
              sessionManager.stopSession()
            }
          }, label: {
            if #available(macOS 14, *) {
              Image(systemName: "stop.circle")
                .imageScale(.large)
                .contentTransition(.symbolEffect(.replace))
            } else {
              Image(systemName: "stop.circle")
                .imageScale(.large)
            }
          })
          .buttonStyle(PlainButtonStyle())
          .matchedGeometryEffect(id: "button", in: namespace)
        } else {
          Button(action: {
            withAnimation {
              sessionManager.startSession()
            }
          }, label: {
            HStack {
              if #available(macOS 14, *) {
                Image(systemName: "play.circle")
                  .imageScale(.large)
                  .contentTransition(.symbolEffect(.replace))
                  .matchedGeometryEffect(id: "button", in: namespace)
              } else {
                Image(systemName: "play.circle")
                  .imageScale(.large)
                  .matchedGeometryEffect(id: "button", in: namespace)
              }
              Text("Start session")
                .font(.title3)
            }
          })
          .buttonStyle(PlainButtonStyle())
        }
      }
      .frame(width: 140, height: 40)
      .padding(8)
      .background(in: .rect(cornerRadius: 24, style: .continuous))
      HStack {
        if #available(macOS 14.0, *) {
          SettingsLink{
            Image(systemName: "gearshape")
              .imageScale(.large)
          }
          .keyboardShortcut(",", modifiers: .command)
          
          .buttonStyle(PlainButtonStyle())
        } else {
          Button(action: {
            //          let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
            //          let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
            //          let task = Process()
            //          task.launchPath = "/usr/bin/open"
            //          task.arguments = [path]
            //          task.launch()
            if #available(macOS 13, *) {
              NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
            } else {
              NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
            }
            
          }, label: {
            Image(systemName: "gearshape")
              .imageScale(.large)
          })
          .buttonStyle(PlainButtonStyle())
        }
        Spacer()
        Button(action: {
          NSApplication.shared.terminate(nil)
        }, label: {
          Image(systemName: "power")
            .imageScale(.large)
        })
        .buttonStyle(PlainButtonStyle())
      }
      .foregroundStyle(.secondary)
    }
    .padding()
    .frame(width: 180)
    .fontDesign(.rounded)
  }
}

#Preview {
  HomeView()
}
