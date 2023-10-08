//
//  MenuBarView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI

struct MenuBarView: View {
  
  @ObservedObject var sessionManager = SessionManager.shared
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
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
      HStack {
        Button(action: {}, label: {
          Image(systemName: "gear")
        })
        .buttonStyle(PlainButtonStyle())
        Spacer()
          .frame(width: 100)
        Button(action: {}, label: {
          Image(systemName: "power")
        })
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding()
  }
}

#Preview {
  MenuBarView()
}
