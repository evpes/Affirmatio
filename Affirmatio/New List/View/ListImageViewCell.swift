//
//  ListImageViewCell.swift
//  Affirmatio
//
//  Created by evpes on 12.05.2021.
//

import UIKit

class ListImageViewCell: UICollectionViewCell {
    @IBOutlet weak var listImageView: UIImageView!
    
    override func prepareForReuse() {
        listImageView.frame = contentView.frame
        print("prepareForReuse frame: \(listImageView.frame)")
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        listImageView.frame = contentView.frame
//        print(frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        print("err")
//    }
}
