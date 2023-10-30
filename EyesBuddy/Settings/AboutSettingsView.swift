//
//  AboutSettingsView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 30/10/2023.
//

import SwiftUI

struct AboutSettingsView: View {
  var body: some View {
    Form {
      VStack(spacing: 12) {
        Image("MacAppIcon")
          .resizable()
          .scaledToFit()
          .frame(width: 64, height: 64)
        HStack {
          Text("Eyes Buddy")
            .font(.title2)
            .bold()
          Text("Beta")
            .bold()
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(in: .capsule)
        }
        Text("Version \(appVersion)")
          .font(.callout)
        Text("© 2023 Dinh Quang Hieu")
          .font(.callout)
        if let url = URL(string: "https://eyesbuddy.app") {
          Link("eyesbuddy.app", destination: url)
        }
      }
      .frame(width: 440, height: 240)
    }
  }
  
  var appVersion: String {
    let source: String = "D"
    var result = ""
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
      result = appVersion
    }
    if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
      result += " (\(buildNumber + source))"
    }
    
    return result
  }
}

#Preview {
  AboutSettingsView()
}
