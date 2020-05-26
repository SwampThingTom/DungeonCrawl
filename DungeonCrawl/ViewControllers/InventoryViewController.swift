//
//  InventoryViewController.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/24/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import UIKit

protocol DismissibleViewControllerDelegate: class {
    
    /// Dismiss the inventory view controller.
    func dismiss(viewController: UIViewController)
}

struct InventoryViewModel {
    
    typealias ActionHandler = (_ itemID: UInt) -> InventoryViewModel
    
    struct Action {
        var name: String
        var handler: ActionHandler
    }
    
    var items: [ItemViewModel]
    
    struct ItemViewModel {
        var itemID: UInt
        var name: String
        var actions: [Action]
    }
}

class InventoryViewController: UITableViewController {
    
    weak var dismissingDelegate: DismissibleViewControllerDelegate?
    var inventory: InventoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = "Inventory"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: .closeButtonTapped)
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "inventoryCell")
    }
    
    // MARK: - Dismissible
    
    @objc func closeButtonTapped() {
        dismissingDelegate?.dismiss(viewController: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventory?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inventoryCell", for: indexPath)
        cell.textLabel?.text = inventory?.items[indexPath.row].name ?? "???"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = inventory?.items[indexPath.row] else { return }
        guard !selectedItem.actions.isEmpty else { return }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        selectedItem.actions.forEach { action in
            let equipAction = UIAlertAction(title: action.name, style: .default) { _ in
                self.inventory = action.handler(selectedItem.itemID)
                tableView.reloadData()
            }
            alertController.addAction(equipAction)
        }
        
        self.present(alertController, animated: true)
    }
}

fileprivate extension Selector {
    
    static let closeButtonTapped = #selector(InventoryViewController.closeButtonTapped)
}
