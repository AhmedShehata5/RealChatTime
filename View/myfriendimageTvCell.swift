//
//  myfriendimageTvCell.swift
//  RealChatTestProject
//
//  Created by Ahmed on 4/8/20.
//  Copyright © 2020 AHMED. All rights reserved.
//

import UIKit

class myfriendimageTvCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImageView: UIImageView!{
        didSet{
                 avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
             }
    }
    
    
    @IBOutlet weak var dateLBL: UILabel!
    
    
    @IBOutlet weak var myfriendimagesend: UIImageView!{
        didSet{
                 myfriendimagesend.layer.cornerRadius =  10
             }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
