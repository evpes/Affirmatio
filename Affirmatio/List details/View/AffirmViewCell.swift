//
//  AffirmViewCell.swift
//  Affirmatio
//
//  Created by evpes on 08.05.2021.
//

import UIKit

class AffirmViewCell: UITableViewCell {

    
    
    @IBOutlet weak var affirmView: UIView!
    
    @IBOutlet weak var affirmLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        affirmView.layer.cornerRadius = 15
        affirmView.backgroundColor = .black
        affirmView.alpha = 0.2
        backgroundColor = .clear
        affirmLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        affirmLabel.shadowColor = .black
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
