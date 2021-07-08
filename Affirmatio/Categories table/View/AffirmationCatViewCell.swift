//
//  AffirmationCatViewCell.swift
//  Affirmatio
//
//  Created by evpes on 29.05.2021.
//

import UIKit

class AffirmationCatViewCell: UITableViewCell {
    @IBOutlet weak var affirmView: UIView!
    @IBOutlet weak var affirmLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    var check: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        affirmView.layer.cornerRadius = 15
        affirmView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        affirmLabel.shadowOffset = CGSize(width: 1.0, height: 1.0)
        affirmLabel.shadowColor = .black
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
         super.layoutSubviews()
//         let insetRL: CGFloat = 12.0 // Let's assume the space you want is 10
//        let insetUD: CGFloat = 3.0 // Let's assume the space you want is 10
//         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: insetUD, left: insetRL, bottom: insetUD, right: insetRL))
    }
    
}
