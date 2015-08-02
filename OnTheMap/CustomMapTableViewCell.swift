//
//  CustomMapTableViewCell.swift
//  OnTheMap
//
//  Created by Alex on 01.08.15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import UIKit

class CustomMapTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentURLLabel: UILabel!
    @IBOutlet weak var studentLocationLabel: UILabel!
    @IBOutlet weak var studentImage: UIImageView!

    func loadItem(#name: String, url: String, location: String) {
    
        studentNameLabel.text = name
        studentURLLabel.text = url
        studentLocationLabel.text = location
    }
}