//
//  LicenseManager.swift
//  EyesBuddy
//
//  Created by Dinh Quang Hieu on 24/10/2023.
//

import Foundation
import SwiftUI

struct LicenseActivateModel: Decodable {
  
  struct LicenseKey: Decodable {
    let expires_at: String?
  }
  
  struct Instance: Decodable {
    let id: String
  }
  
  let activated: Bool
  let error: String?
  let license_key: LicenseKey
  let instance: Instance?
}

struct LicenseValidateModel: Decodable {
  struct LicenseKey: Decodable {
    let expires_at: String?
  }
  
  let valid: Bool
  let error: String?
  let license_key: LicenseKey?
}

@MainActor
class LicenseManager: ObservableObject {
  @AppStorage("isLicenseValid") var isValid = false
  @AppStorage("licenseKey") var licenseKey = ""
  @AppStorage("instanceId") var instanceId = ""
  @AppStorage("expiryDate") var expiryDate = ""
  
  @Published var isActivating = false
  @Published var error = ""
  
  static let shared = LicenseManager()
  
  func activate(key: String) async {
    isActivating = true
    licenseKey = key
    error = ""
    let baseUrlString = "https://api.lemonsqueezy.com/v1/licenses/activate"
    let instanceName = getDeviceModelName() ?? "Default"
    
    var urlComponents = URLComponents(string: baseUrlString)!
    urlComponents.queryItems = [
      URLQueryItem(name: "license_key", value: key),
      URLQueryItem(name: "instance_name", value: instanceName)
    ]
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let model = try JSONDecoder().decode(LicenseActivateModel.self, from: data)
      isValid = model.activated
      instanceId = model.instance?.id ?? ""
      expiryDate = model.license_key.expires_at ?? ""
      error = model.error ?? ""
      isActivating = false
    } catch {
      self.error = error.localizedDescription
      isActivating = false
    }
  }
  
  func validate() async throws -> Bool {
    let baseUrlString = "https://api.lemonsqueezy.com/v1/licenses/validate"
    
    var urlComponents = URLComponents(string: baseUrlString)!
    urlComponents.queryItems = [
      URLQueryItem(name: "license_key", value: licenseKey),
      URLQueryItem(name: "instance_id", value: instanceId)
    ]
    var request = URLRequest(url: urlComponents.url!)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let model = try JSONDecoder().decode(LicenseValidateModel.self, from: data)
      isValid = model.valid
      if let expires_at = model.license_key?.expires_at {
        expiryDate = expires_at
      }
      return isValid
    } catch {
      throw error
    }
  }
  
  func getDeviceModelName() -> String? {
    var size: Int = 0
    sysctlbyname("hw.model", nil, &size, nil, 0)
    
    var model = [CChar](repeating: 0, count: Int(size))
    sysctlbyname("hw.model", &model, &size, nil, 0)
    
    return String(cString: model)
  }
}
