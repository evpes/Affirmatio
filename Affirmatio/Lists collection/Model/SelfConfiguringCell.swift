//
//  SelfConfiguringCell.swift
//  Affirmatio
//
//  Created by evpes on 14.01.2022.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: Item)
}
