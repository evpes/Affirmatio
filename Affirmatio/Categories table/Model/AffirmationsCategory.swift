//
//  AffirmationsCategory.swift
//  Affirmatio
//
//  Created by evpes on 24.04.2021.
//

import Foundation
import RealmSwift

class AffirmationsCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var createdDate: Date = Date()
    var isExpanded = false
    @objc dynamic var premium = 0
    let affirmations = List<Affirmation>()
}
