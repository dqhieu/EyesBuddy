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
  }
}

#Preview {
  MenuBarView()
}
