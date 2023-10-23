//
//  MouseActivityDetector.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 20/10/2023.
//

import Foundation
import Cocoa
import SwiftUI

class MouseActivityDetector: NSObject {
  
  @AppStorage("inactiveDuration") var inactiveDuration = 5 // minutes
  @AppStorage("inactiveResumeType") var inactiveResumeType = 0 // 0 restart, 1 continue
  
  var timer: Timer?
  var lastMouseMovedTime: Date?
  var shouldRestartSession = false
  var shouldResumeSession = false
  var monitor: Any?
  
  static let shared = MouseActivityDetector()
  
  override init() {
    super.init()
    startLocalMonitor()
  }
  
  func startGlobalMonitor() {
    guard inactiveDuration > 0 else { return }
//    print("🍾 startGlobalMonitor")
    monitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved, .leftMouseDown, .leftMouseUp]) { [weak self] event in
      self?.lastMouseMovedTime = Date()
      self?.restartSessionIfNeeded()
      self?.resetTimer()
    }
  }
  
  func startLocalMonitor() {
    guard inactiveDuration > 0 else { return }
//    print("🍾 startLocalMonitor")
    monitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved, .leftMouseDown, .leftMouseUp]) { [weak self] event in
      self?.lastMouseMovedTime = Date()
      self?.restartSessionIfNeeded()
      self?.resetTimer()
      return event
    }
  }
  
  func stopMonitoring() {
//    print("🍾 stopMonitoring")
    if let monitor = monitor {
      NSEvent.removeMonitor(monitor)
    }
    
  }
  
  func resetTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(timeInterval: TimeInterval(inactiveDuration * 60), target: self, selector: #selector(self.mouseDidStopMoving), userInfo: nil, repeats: false)
  }
  
  @objc func mouseDidStopMoving() {
    guard inactiveDuration > 0 else { return }
//    print("🍾 Mouse has stopped moving for 5 seconds")
    if inactiveResumeType == 0 {
      SessionManager.shared.stopSession()
      shouldRestartSession = true
    } else if inactiveResumeType == 1 {
      SessionManager.shared.pauseSession()
      shouldResumeSession = true
    }
    
  }
  
  func restartSessionIfNeeded() {
    guard inactiveDuration > 0 else { return }
    if shouldRestartSession {
//      print("🍾 startSession")
      SessionManager.shared.startSession()
    } else if shouldResumeSession {
      SessionManager.shared.resumeSession()
    }
    shouldRestartSession = false
    shouldResumeSession = false
  }
}
