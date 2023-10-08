//
//  EyesBuddyApp.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import SwiftUI

@main
struct EyesBuddyApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    MenuBarExtra {
      MenuBarView()
      Button(action: {}, label: {
        Text("Button")
      })
    } label: {
      Label("MyApp", systemImage: "eyes")
    }
    .menuBarExtraStyle(.window)
  }
}
