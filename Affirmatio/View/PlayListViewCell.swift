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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
