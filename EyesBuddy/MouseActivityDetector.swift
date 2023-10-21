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
  
  var timer: Timer?
  var lastMouseMovedTime: Date?
  var shouldRestartSession = false
  var monitor: Any?
  
  static let shared = MouseActivityDetector()
  
  override init() {
    super.init()
    startLocalMonitor()
  }
  
  func startGlobalMonitor() {
//    print("🍾 startGlobalMonitor")
    monitor = NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
      self?.lastMouseMovedTime = Date()
      self?.restartSessionIfNeeded()
      self?.resetTimer()
    }
  }
  
  func startLocalMonitor() {
//    print("🍾 startLocalMonitor")
    monitor = NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) { [weak self] event in
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
//    print("🍾 Mouse has stopped moving for 5 seconds")
    SessionManager.shared.stopSession()
    shouldRestartSession = true
  }
  
  func restartSessionIfNeeded() {
    if shouldRestartSession {
//      print("🍾 startSession")
      SessionManager.shared.startSession()
    }
    shouldRestartSession = false
  }
}
