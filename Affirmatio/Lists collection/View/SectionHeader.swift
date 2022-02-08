//
//  SectionHeader.swift
//  TestTableWithCollections
//
//  Created by evpes on 12.01.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
        static let reuseIdentifier = "SectionHeader"
    
    let title = UILabel()
    let subtitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let separator = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel
        
        title.textColor = .white
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))
        subtitle.textColor = .lightGray
        subtitle.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 18, weight: .light))
        subtitle.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [separator, title, subtitle])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        stackView.setCustomSpacing(10, after: separator)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
