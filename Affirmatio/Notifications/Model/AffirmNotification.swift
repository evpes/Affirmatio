//
//  AffirmNotification.swift
//  Affirmatio
//
//  Created by evpes on 18.05.2021.
//

import Foundation

struct AffirmNotification {
    var hour: Int
    var minute: Int
    var weekDays: [Int]
    var groupId: String
    var identifiers: [String]
    var repeatable: Bool {
        get {
            return weekDays.count > 1 && !weekDays.contains(0)
        }
    }
}
