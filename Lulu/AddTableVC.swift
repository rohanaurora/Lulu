//
//  AddTableVC.swift
//  Lulu
//
//  Created by Rohan Aurora on 8/31/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import UIKit

protocol ItemsDelegate: class {
    func refreshList()
}

class AddTableVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var itemTextField: UITextField!
    
    weak var delegate: ItemsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Titles.add
        errorLabel.isHidden = true
        itemTextField.delegate = self
        itemTextField.becomeFirstResponder()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let item = itemTextField.text, !item.isEmptyString() {
            dismiss(animated: true) {
                self.updateTableWithItem(item)
                self.delegate?.refreshList()
            }
        } else {
            errorLabel.isHidden = false
        }
    }
    
    /// Adds new item to the database.
    private func updateTableWithItem(_ item:String) {
        let year = Calendar.current.component(.year, from: Date())
        let id = Int.random(in: 1...9999)
        DataManager().insertItem(id: id, name: item, date: year)
    }
}


