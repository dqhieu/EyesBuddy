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

let SESSION_DURATION = 60 * 20 // 5 minutes
let RELAX_DURATION = 20 // 20 seconds

class SessionManager: ObservableObject {
  
  @Published var sessionTimer: Timer?
  @Published var remainingSessionTime = SESSION_DURATION
  @Published var remainingSessionTimeString: String = "20:00"
  
  @Published var relaxTimer: Timer?
  @Published var remainingRelaxTime = RELAX_DURATION
  @Published var remainingRelaxSessionTimeString: String = "20"
    
  var relaxWindow: NSWindow?
  
  static let shared = SessionManager()
  
  func startSession() {
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
    remainingSessionTime = SESSION_DURATION
    remainingRelaxTime = RELAX_DURATION
    calculateRemainingSessionTimeString()
  }
  
  func calculateRemainingSessionTimeString() {
    var minute = "\((remainingSessionTime / 60))"
    if minute.count == 1 {
      minute = "0" + minute
    }
    var second = "\(remainingSessionTime % 60)"
    if second.count == 1 {
      second = "0" + second
    }
    remainingSessionTimeString = minute + ":" + second
  }
  
  func startRelaxSession() {
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
    remainingSessionTime = SESSION_DURATION
    remainingRelaxTime = RELAX_DURATION
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
}
