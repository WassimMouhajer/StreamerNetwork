//
//  ChatCell.swift
//  Cx Network
//
//  Created by ElectroZone on 2018-09-10.
//  Copyright © 2018 Wassim Mouhajer. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var messageLbl: UILabel!
    
    func configureChat(chat: CxChat) {
        messageLbl.text = chat.message
    }
    
}
