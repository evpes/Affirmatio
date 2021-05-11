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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
