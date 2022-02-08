//
//  Item.swift
//  Affirmatio
//
//  Created by evpes on 13.01.2022.
//

import Foundation

struct Item {
    let id = UUID()
    let name: String
    let subtitle: String
    let imageName: String
    let lock: Bool
}

extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: Item, rhs: Item) -> Bool {
            return lhs.id == rhs.id
    }
}
