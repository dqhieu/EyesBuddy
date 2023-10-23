//
//  SessionManager.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 08/10/2023.
//

import Foundation
import AppKit
import Cocoa
import SwiftUI
import TelemetryClient

enum SessionState {
  case started
  case paused
  case idle
}

class SessionManager: ObservableObject {
  
  @Published var sessionTimer: Timer?
  @Published var remainingSessionTime = 60 * 20
  @Published var remainingSessionTimeString: String = "20:00"
  @Published var sessionState: SessionState = .idle
  
  @Published var relaxTimer: Timer?
  @Published var remainingRelaxTime = 20
  @Published var remainingRelaxSessionTimeString: String = "20"
  
  @AppStorage("autoRestartSessionWhenUnlock") var autoRestartSessionWhenUnlock = true
  @AppStorage("sessionDuration") var sessionDuration = 20 // minutes
  @AppStorage("relaxDuration") var relaxDuration = 20 // seconds
    
  var relaxWindows: [NSWindow] = []
  
  static let shared = SessionManager()
  
  let dnc = DistributedNotificationCenter.default()
  
  init() {
    dnc.addObserver(forName: .init("com.apple.screenIsLocked"), object: nil, queue: .main) { [weak self] _ in
      NSLog("Screen Locked")
      guard let this = self else { return }
      this.stopSession()
    }
    
    dnc.addObserver(forName: .init("com.apple.screenIsUnlocked"), object: nil, queue: .main) { [weak self] _ in
      NSLog("Screen Unlocked")
      guard let this = self else { return }
      if this.autoRestartSessionWhenUnlock {
        this.startSession()
      }
    }
    resetRemainingTime()
  }
  
  func resetRemainingTime() {
    remainingSessionTime = sessionDuration * 60
    remainingRelaxTime = relaxDuration
    remainingSessionTimeString = Utils.calculateRemainingSessionTimeString(remainingSessionTime: remainingSessionTime)
    remainingRelaxSessionTimeString = "\(remainingRelaxTime)"
  }
  
  func startSession() {
    TelemetryManager.send("startSession", with: [
      "sessionDuration": "\(sessionDuration)",
      "relaxDuration": "\(relaxDuration)"
    ])
    resetRemainingTime()
    sessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sessionTimerTick), userInfo: nil, repeats: true)
    sessionState = .started
  }
  
  @objc func sessionTimerTick() {
    remainingSessionTime -= 1
    calculateRemainingSessionTimeString()
    if remainingSessionTime <= 0 {
      stopSession()
      showReminderWindow()
      startRelaxSession()
    }
  }
  
  func pauseSession() {
    sessionState = .paused
    sessionTimer?.invalidate()
    sessionTimer = nil
  }
  
  func resumeSession() {
    sessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sessionTimerTick), userInfo: nil, repeats: true)
    sessionState = .started
  }
  
  func stopSession() {
    sessionState = .idle
    sessionTimer?.invalidate()
    sessionTimer = nil
    resetRemainingTime()
    calculateRemainingSessionTimeString()
  }
  
  func calculateRemainingSessionTimeString() {
    remainingSessionTimeString = Utils.calculateRemainingSessionTimeString(remainingSessionTime: remainingSessionTime)
  }
  
  func startRelaxSession() {
    TelemetryManager.send("startRelaxSession", with: [
      "sessionDuration": "\(sessionDuration)",
      "relaxDuration": "\(relaxDuration)"
    ])
    resetRemainingTime()
    relaxTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(relaxTimerTick), userInfo: nil, repeats: true)
  }
  
  @objc func relaxTimerTick() {
    remainingRelaxTime -= 1
    calculateRemainingRelaxSessionTimeString()
    if remainingRelaxTime <= 0 {
      stopRelaxSession()
      dismissReminderWindows()
    }
  }
  
  func stopRelaxSession() {
    relaxTimer?.invalidate()
    relaxTimer = nil
    resetRemainingTime()
    calculateRemainingRelaxSessionTimeString()
    startSession()
  }
  
  func calculateRemainingRelaxSessionTimeString() {
    remainingRelaxSessionTimeString = "\(remainingRelaxTime)"
  }
  
  
  func showReminderWindow() {
    TelemetryManager.send("showReminderWindow", with: [
      "sessionDuration": "\(sessionDuration)",
      "relaxDuration": "\(relaxDuration)",
      "screenCount": "\(NSScreen.screens.count)"
    ])
    relaxWindows = []
    for screen in NSScreen.screens {
      let vc = NSHostingController(rootView: ReminderView(dismissNowAction: { [weak self] in
        self?.dismissReminderWindows()
        self?.stopRelaxSession()
      }))
      let window = NSWindow(contentViewController: vc)
      
      // Set the window style mask to enable full screen
      window.styleMask = [.borderless, .fullSizeContentView]
      
      // Set the window level to be above all other windows
      window.level = .screenSaver
      window.collectionBehavior = [.canJoinAllSpaces, .canJoinAllApplications]
      
      // Set the window frame to occupy the whole screen
      window.setFrame(screen.frame, display: true)
      
      NSApplication.shared.presentationOptions = [
        .hideMenuBar,
        .hideDock
      ]
      
      window.alphaValue = 0
      
      NSAnimationContext.runAnimationGroup { context in
        context.duration = 0.5
        window.animator().alphaValue = 1
      } completionHandler: {
        
      }
      
      // Show the window
      window.orderFront(nil)
      relaxWindows.append(window)
    }
  }
  
  func dismissReminderWindows() {
    TelemetryManager.send("dismissReminderWindows", with: [
      "sessionDuration": "\(sessionDuration)",
      "relaxDuration": "\(relaxDuration)",
      "screenCount": "\(NSScreen.screens.count)"
    ])
    NSApplication.shared.presentationOptions = []
    
    NSAnimationContext.runAnimationGroup { [weak self] context in
      context.duration = 0.5
      
      self?.relaxWindows.forEach { $0.animator().alphaValue = 0 }
    } completionHandler: { [weak self] in
      self?.relaxWindows.forEach { $0.close() }
      self?.relaxWindows = []
    }
  }
  
  var isBetaExpired: Bool {
    let dateString = "2023/11/01"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let date = dateFormatter.date(from: dateString) ?? Date()
    return date <= .now
  }
}

class Utils {
  static func calculateRemainingSessionTimeString(remainingSessionTime: Int) -> String {
    var minute = "\((remainingSessionTime / 60))"
    if minute.count == 1 {
      minute = "0" + minute
    }
    var second = "\(remainingSessionTime % 60)"
    if second.count == 1 {
      second = "0" + second
    }
    return minute + ":" + second
  }
}

