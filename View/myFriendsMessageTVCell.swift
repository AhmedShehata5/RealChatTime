//
//  myfriendmessageCell.swift
//  RealChatTestProject
//
//  Created by Ahmed on 4/6/20.
//  Copyright © 2020 AHMED. All rights reserved.
//

import UIKit


class myFriendsMessageTVCell: UITableViewCell {

    @IBOutlet weak var messageLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!{
        didSet{
                  avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
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
