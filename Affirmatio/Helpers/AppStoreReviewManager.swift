//
//  AppStoreReviewManager.swift
//  Affirmatio
//
//  Created by evpes on 07.08.2021.
//

import StoreKit

enum AppStoreReviewManager {
    
    static let minimumReviewWorthyActionCount = 3

    static func requestReviewIfAppropriate() {
      let defaults = UserDefaults.standard
      let bundle = Bundle.main

      var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
      actionCount += 1
      defaults.set(actionCount, forKey: .reviewWorthyActionCount)

      guard actionCount >= minimumReviewWorthyActionCount else {
        return
      }

      let bundleVersionKey = kCFBundleVersionKey as String
      let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
      let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)

      guard lastVersion == nil || lastVersion != currentVersion else {
        return
      }

        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }

      defaults.set(0, forKey: .reviewWorthyActionCount)
      defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}
