//
//  WidgetContent.swift
//  Affirmatio
//
//  Created by evpes on 23.05.2021.
//

import Foundation
import WidgetKit

struct WidgetContent : TimelineEntry, Codable {
    var date = Date()
    let affirmText: String
}
