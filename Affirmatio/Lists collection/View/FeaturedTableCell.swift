//
//  FeaturedTableCell.swift
//  Affirmatio
//
//  Created by evpes on 17.01.2022.
//


import UIKit

class FeaturedTableCell: UICollectionViewCell, SelfConfiguringCell {
    static var reuseIdentifier: String = "FeaturedTableCell"
    
    let name = UILabel()
    let subbtitle = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        name.font = UIFont.preferredFont(forTextStyle: .headline)
        name.textColor = .white
        name.numberOfLines = 0
        subbtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subbtitle.textColor = .lightGray
        subbtitle.numberOfLines = 0
        
        imageView.layer.cornerRadius = 15
        contentView.addSubview(imageView)
        imageView.addSubview(blurEffectView)
        contentView.addSubview(name)
        contentView.addSubview(subbtitle)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        subbtitle.translatesAutoresizingMaskIntoConstraints = false
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
            blurEffectView.heightAnchor.constraint(equalToConstant: 60),
            name.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: 10),
            name.heightAnchor.constraint(equalToConstant: 20),
            name.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            name.topAnchor.constraint(equalTo: blurEffectView.topAnchor),
            subbtitle.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor, constant: 10),
            subbtitle.heightAnchor.constraint(equalToConstant: 40),
            subbtitle.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor),
            subbtitle.bottomAnchor.constraint(equalTo: blurEffectView.bottomAnchor)
        ])
        


        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with item: Item) {
        name.text = item.name
        subbtitle.text = item.subtitle
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
