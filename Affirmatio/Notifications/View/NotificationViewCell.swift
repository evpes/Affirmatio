//
//  NotificationViewCell.swift
//  Affirmatio
//
//  Created by evpes on 19.05.2021.
//

import UIKit

class NotificationViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var notificationView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationView.layer.cornerRadius = 15
        notificationView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        backgroundColor = .clear
        notificationView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        notificationView.layer.shadowColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
