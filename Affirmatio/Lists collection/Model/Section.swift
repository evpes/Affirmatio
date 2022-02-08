//
//  Section.swift
//  Affirmatio
//
//  Created by evpes on 13.01.2022.
//

import Foundation

struct Section: Hashable {
    let title: String
    let subtitle: String
    var items: [Item]
    let type: String
}
