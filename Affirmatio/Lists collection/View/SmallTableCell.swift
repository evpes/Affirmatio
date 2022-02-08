//
//  SmallTableCell.swift
//  Affirmatio
//
//  Created by evpes on 15.01.2022.
//

import UIKit

class SmallTableCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "SmallTableCell"
    
    let name = UILabel()
    let imageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .white
        name.numberOfLines = 0
        
        imageView.layer.cornerRadius = 15
        contentView.addSubview(imageView)
        imageView.addSubview(blurEffectView)
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //name.backgroundColor = .white.withAlphaComponent(0.5)
        blurEffectView.contentView.addSubview(name)
        //blurEffectView.layer.cornerRadius = 5
        blurEffectView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurEffectView.heightAnchor.constraint(equalToConstant: 50),
            name.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: 10),
            name.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor),
            name.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            name.topAnchor.constraint(equalTo: blurEffectView.topAnchor)
        ])
        


        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with item: Item) {
        //name.text = item.name
        if item.name == " + add new list" {
            name.text = ""
            imageView.image = UIImage(systemName: "plus")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            imageView.contentMode = .center
            contentView.layer.opacity = 0.5
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.black.cgColor
            
        } else {
            name.text = item.name
            imageView.contentMode = .scaleAspectFill
            contentView.layer.opacity = 1
            contentView.layer.borderWidth = 0
            imageView.image = UIImage(named: item.imageName)
        }
        contentView.layer.shadowOffset = CGSize(width: 1, height: 1)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.6
        contentView.layer.cornerRadius = 15
        
    }
    
    
}

//import UIKit
//
//
//extension UIImageView {
//    func applyBlurEffect() {
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(blurEffectView)
//    }
//}
