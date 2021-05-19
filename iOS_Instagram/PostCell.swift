//
//  PostCell.swift
//  iOS_Instagram
//
//  Created by Sophia Lui on 5/18/21.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var postView: UIImageView!
    @IBOutlet weak var captionLabel: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
