//
//  LicenseView.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 25/10/2023.
//

import SwiftUI

struct LicenseView: View {
  
  @ObservedObject var licenseManager = LicenseManager.shared
  @State var licenseKey = ""
  
  var body: some View {
    VStack(alignment: .leading) {
      if licenseManager.isValid {
        HStack(spacing: 0) {
          Text("License status")
          Spacer()
          Image(systemName: "checkmark.seal.fill").foregroundStyle(.green)
          Text(" Valid")
        }
        Divider()
        HStack(spacing: 0) {
          Text("License expiry date")
          Spacer()
          Text("2024/10/24")
        }
      } else {
        HStack(spacing: 8) {
          TextField("Enter your license key", text: $licenseKey)
            .disabled(licenseManager.isActivating)
          if licenseManager.isActivating {
            ProgressView()
              .controlSize(.small)
          } else {
            Button {
              Task {
                await licenseManager.activate(key: licenseKey)
              }
            } label: {
              Text("Activate")
            }
          }
        }
        if !licenseManager.error.isEmpty {
          Text(licenseManager.error)
            .foregroundStyle(.red)
        }
      }
    }
  }
}

#Preview {
  LicenseView()
}
