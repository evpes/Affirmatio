//
//  AffirmationsList.swift
//  Affirmatio
//
//  Created by evpes on 24.04.2021.
//

import Foundation
import RealmSwift

class AffirmationsList: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var createdDate: Date = Date()
    @objc dynamic var picture: String = ""
    var affirmations = List<Affirmation>()
}
