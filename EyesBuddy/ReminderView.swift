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
  
  var body: some View {
    ZStack {
      Image("background")
        .resizable()
        .aspectRatio(contentMode: .fill)
      VStack(spacing: 24) {
        Text("You have been looking at this monitor for 20 minutes straits, it's time for your eyes to rest!")
          .font(.largeTitle)
        Text("The 20-20-20 rule: every 20 minutes, shift your eyes to look at an object at least 20 feet away, for at least 20 seconds")
          .multilineTextAlignment(.center)
          .lineLimit(0)
          .font(.title)
          .foregroundStyle(.primary)
          .fontWeight(.light)
          .italic()
        HStack {
          Text("This screen will dismiss after")
            .font(.title)
            .foregroundStyle(.secondary)
            .fontWeight(.light)
          Text(sessionManager.remainingRelaxSessionTimeString)
            .font(.title)
            .foregroundStyle(.secondary)
            .fontWeight(.light)
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
