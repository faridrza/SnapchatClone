//
//  CellVC.swift
//  SnapchatClone
//
//  Created by Farid Rzayev on 24.01.22.
//

import UIKit

class CellVC: UITableViewCell {

    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
