//
//  ReminderView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI

struct ReminderView: View {
  
  @ObservedObject var sessionManager = SessionManager.shared
  var dismissNowAction: () -> Void
  
  @AppStorage("sessionDuration") var sessionDuration = 20
  
  var body: some View {
    ZStack {
      Image("background")
        .resizable()
        .aspectRatio(contentMode: .fill)
      VStack(spacing: 24) {
        Text("You've been staring at this monitor for \(sessionDuration) minutes. It's time to give your eyes a break!")
          .font(.largeTitle)
        Text("For every 20 minutes, shift your eyes to look at an object at least 20 feet away, for at least 20 seconds")
          .multilineTextAlignment(.center)
          .lineLimit(0)
          .font(.title)
          .foregroundStyle(.primary)
          .italic()
        HStack {
          Text("This screen will be dismissed after")
            .font(.title)
            .foregroundStyle(.secondary)
            .fontWeight(.light)
          Text(sessionManager.remainingRelaxSessionTimeString)
            .font(.title)
            .foregroundStyle(.secondary)
            .monospacedDigit()
            .contentTransition(.numericText(countsDown: true))
            .animation(.linear, value: sessionManager.remainingRelaxSessionTimeString)
          Text("seconds")
            .font(.title)
            .foregroundStyle(.secondary)
            .fontWeight(.light)
        }
        Button(action: {
          dismissNowAction()
        }, label: {
          Text("Dismiss now")
        })
      }
      .foregroundStyle(.white)
    }
    .fontDesign(.rounded)
  }
  
}

#Preview {
  ReminderView(dismissNowAction: { })
    .frame(width: 500, height: 500, alignment: .center)
}
