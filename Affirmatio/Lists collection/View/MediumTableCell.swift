//
//  MediumTableCell.swift
//  Affirmatio
//
//  Created by evpes on 14.01.2022.
//

import UIKit

class MediumTableCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "MediumTableCell"
    
    let name = UILabel()
    let imageView = UIImageView()
    let lockImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .white
        name.numberOfLines = 0
        
        imageView.layer.cornerRadius = 15
        
        lockImage.image = UIImage(systemName: "lock.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        lockImage.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        contentView.addSubview(lockImage)
        imageView.addSubview(blurEffectView)
        contentView.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lockImage.translatesAutoresizingMaskIntoConstraints = false
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
            lockImage.heightAnchor.constraint(equalToConstant: 30),
            lockImage.widthAnchor.constraint(equalToConstant: 30),
            lockImage.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            lockImage.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            blurEffectView.heightAnchor.constraint(equalToConstant: 30),
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
        if !item.lock {
            lockImage.layer.opacity = 0
        } else {
            lockImage.layer.opacity = 1
        }
        name.text = item.name
        imageView.image = UIImage(named: item.imageName)
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
