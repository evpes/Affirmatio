//
//  LandscapeManager.swift
//  Affirmatio
//
//  Created by evpes on 12.05.2021.
//

import Foundation

class LandscapeManager {
    static let shared = LandscapeManager()
    
    var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
    
    var isFirstLaunchUpdate: Bool {
        get {
            !UserDefaults.standard.bool(forKey: #function)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: #function)
        }
    }
}
