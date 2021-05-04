//
//  Affirmation.swift
//  Affirmatio
//
//  Created by evpes on 24.04.2021.
//

import Foundation
import RealmSwift

class Affirmation: Object {
    @objc dynamic var affitmText: String = ""
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var soundPath: String = ""
    @objc dynamic var checked: Bool = false
    var parentCategory = LinkingObjects(fromType: AffirmationsCategory.self, property: "affirmations")
    var parentList = LinkingObjects(fromType: AffirmationsList.self, property: "affirmations")
}
