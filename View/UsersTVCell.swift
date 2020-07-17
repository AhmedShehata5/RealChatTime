//
//  UsersTVCell.swift
//  RealZagChat
//
//  Created by Mohamed Arafa on 3/9/20.
//  Copyright © 2020 SolxFy. All rights reserved.
//

import UIKit

class UsersTVCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var emailLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
