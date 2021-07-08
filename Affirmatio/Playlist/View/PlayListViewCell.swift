//
//  PlayListViewCell.swift
//  Affirmatio
//
//  Created by evpes on 11.05.2021.
//

import UIKit

class PlayListViewCell: UITableViewCell {

    
    @IBOutlet weak var affirmImageView: UIImageView!
    @IBOutlet weak var affirmLabel: UILabel!
    @IBOutlet weak var affirmView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cornerRadius : CGFloat = 15
        affirmView.layer.cornerRadius = cornerRadius
        affirmView.layer.shadowOffset = CGSize(width: 3, height: 3)
        affirmView.layer.shadowColor = UIColor.darkGray.cgColor
        affirmView.layer.shadowOpacity = 0.7
        affirmImageView.layer.cornerRadius = cornerRadius
        affirmImageView.clipsToBounds = true
        backgroundColor = .clear
        affirmLabel.textColor = .white
        affirmLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        affirmLabel.shadowColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
