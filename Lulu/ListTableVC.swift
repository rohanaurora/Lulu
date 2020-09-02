//
//  ListTableVC.swift
//  Lulu
//
//  Created by Rohan Aurora on 8/28/20.
//  Copyright © 2020 Rohan Aurora. All rights reserved.
//

import UIKit

class ListTableVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var currentState: OrderState = OrderState.name
    let refreshControl = UIRefreshControl()
    
    private var datasource: [Garment] = []
    private let garmentHeaderHeight: CGFloat = 65.0

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
    }
    
    private func prepareViews() {
        title = Titles.list
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItems = [add]
        fetchData()
        prepareTableView()
    }
    
    private func prepareTableView() {
        let nibCell = UINib(nibName: ListTableViewCell.nibName, bundle: nil)
        let nibHeader = UINib(nibName: GarmentHeaderView.nibName, bundle: nil)
        
        tableView.register(nibCell, forCellReuseIdentifier: ListTableViewCell.cellID)
        tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: GarmentHeaderView.headerID)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: garmentHeaderHeight))
        tableView.contentInset = UIEdgeInsets(top: -garmentHeaderHeight, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - Reload table view
    private func fetchData() {
        datasource = DataManager().sortByDate(currentState)
        tableView.reloadData()
    }
}

// MARK: - Table view datasource and delegate
extension ListTableVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as? ListTableViewCell else {
            fatalError("Failed to dequeue a ListTableViewCell.")
        }
        
        cell.itemsDatasource = datasource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: GarmentHeaderView.headerID) as! GarmentHeaderView
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return garmentHeaderHeight
    }
}

// MARK: Navigation
extension ListTableVC: ItemsDelegate {
    @objc func addTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: SegueIdentifiers.addItem, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.addItem {
            let addVC = segue.destination as! AddTableVC
            addVC.delegate = self
        }
    }
    
    // Refresh via delegate
    internal func refreshList() {
        fetchData()
    }
}

// MARK: Action
extension ListTableVC: SortDelegate {
    /// This method sorts datasource based on segment's new state.
    internal func sortBy(state: OrderState) {
        currentState = state
        datasource = DataManager().sortByDate(currentState)
        tableView.reloadData()
    }
}
