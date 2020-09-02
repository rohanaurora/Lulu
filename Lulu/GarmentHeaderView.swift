//
//  GarmentHeader.swift
//  Lulu
//
//  Created by Rohan Aurora on 8/31/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import UIKit

protocol SortDelegate: class {
    func sortBy(state:OrderState)
}

class GarmentHeaderView: UITableViewHeaderFooterView {
    
    //MARK:- Constant
    static let headerID:String = "GarmentHeaderView"
    static let nibName:String = "GarmentHeaderView"
    
    //MARK:- Outlet
    @IBOutlet weak var garmentSegmentControl: UISegmentedControl!
    weak var delegate: SortDelegate?

    @IBAction func sortTapped(_ sender: Any) {
        if garmentSegmentControl.selectedSegmentIndex == 0 {
            delegate?.sortBy(state: .name)
        } else {
            delegate?.sortBy(state: .date)
        }
    }
}

