//
//  ListTableViewCell.swift
//  Lulu
//
//  Created by Rohan Aurora on 8/28/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    //MARK:- Constant
    static let cellID:String = "ListTableViewCell"
    static let nibName:String = "ListTableViewCell"
    
    var itemsDatasource: Garment? {
        didSet { self.updateView() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemLabel.text = ""
    }
    
    private func updateView() {
        if let name = itemsDatasource {
            itemLabel.text = name.itemName
        }
    }
}
