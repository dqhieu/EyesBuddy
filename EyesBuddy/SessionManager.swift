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

class SessionManager: ObservableObject {
  
  @Published var sessionTimer: Timer?
  @Published var remainingSessionTime = 60 * 20
  @Published var remainingSessionTimeString: String = "20:00"
  
  @Published var relaxTimer: Timer?
  @Published var remainingRelaxTime = 20
  @Published var remainingRelaxSessionTimeString: String = "20"
  
  @AppStorage("autoRestartSessionWhenUnlock") var autoRestartSessionWhenUnlock = true
  @AppStorage("sessionDuration") var sessionDuration = 20 // minutes
  @AppStorage("relaxDuration") var relaxDuration = 20 // seconds
    
  var relaxWindow: NSWindow?
  
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
    resetRemainingTime()
    sessionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sessionTimerTick), userInfo: nil, repeats: true)
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
  
  func stopSession() {
    sessionTimer?.invalidate()
    sessionTimer = nil
    resetRemainingTime()
    calculateRemainingSessionTimeString()
  }
  
  func calculateRemainingSessionTimeString() {
    remainingSessionTimeString = Utils.calculateRemainingSessionTimeString(remainingSessionTime: remainingSessionTime)
  }
  
  func startRelaxSession() {
    resetRemainingTime()
    relaxTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(relaxTimerTick), userInfo: nil, repeats: true)
  }
  
  @objc func relaxTimerTick() {
    remainingRelaxTime -= 1
    calculateRemainingRelaxSessionTimeString()
    if remainingRelaxTime <= 0 {
      stopRelaxSession()
      dismissReminderWindow()
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
    let vc = NSHostingController(rootView: ReminderView(dismissNowAction: { [weak self] in
      self?.stopRelaxSession()
      self?.dismissReminderWindow()
    }))
    let window = NSWindow(contentViewController: vc)
    
    // Set the window style mask to enable full screen
    window.styleMask = [.borderless, .fullSizeContentView]
    
    // Set the window level to be above all other windows
    window.level = .screenSaver
    
    // Set the window frame to occupy the whole screen
    window.setFrame(NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 500, height: 500), display: true)
    
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
    
    relaxWindow = window
  }
  
  func dismissReminderWindow() {
    NSApplication.shared.presentationOptions = []
    
    NSAnimationContext.runAnimationGroup { context in
      context.duration = 0.5
      relaxWindow?.animator().alphaValue = 0
    } completionHandler: { [weak self] in
      
      self?.relaxWindow?.close()
      self?.relaxWindow = nil
    }
  }
  
  var isBetaExpired: Bool {
    let dateString = "2023/10/26"
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

