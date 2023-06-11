//
//  ListTableViewCell.swift
//  fashionSNS
//
//  Created by 竹田珠子 on 2023/01/15.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var image2view: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextView.isScrollEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
