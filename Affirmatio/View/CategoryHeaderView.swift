//
//  CategoryHeaderView.swift
//  Affirmatio
//
//  Created by evpes on 02.05.2021.
//

import UIKit

class CategoryHeaderView: UITableViewHeaderFooterView {
    
    let title = UILabel()
    var image = UIImageView()
    let button = UIButton()
    var container = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContent() {
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
                
        container.layer.cornerRadius = 13.0
        container.layer.borderWidth = 0.0
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        container.layer.shadowRadius = 3.0
        container.layer.shadowOpacity = 0.6
        container.layer.masksToBounds = false
        
        contentView.addSubview(container)
        container.addSubview(image)
        container.addSubview(title)
        container.addSubview(button)
        
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            container.widthAnchor.constraint(equalTo: contentView.layoutMarginsGuide.widthAnchor),
            container.heightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.heightAnchor),
            container.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            image.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            image.widthAnchor.constraint(equalTo: container.widthAnchor),
            image.heightAnchor.constraint(equalTo: container.heightAnchor),
            image.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            image.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            title.heightAnchor.constraint(equalToConstant: 30),
            title.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 30),
            button.widthAnchor.constraint(equalToConstant: 30),
            button.trailingAnchor.constraint(equalTo: container.layoutMarginsGuide.trailingAnchor, constant: 0)
        ])
    }
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}