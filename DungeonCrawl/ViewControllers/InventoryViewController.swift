//
//  InventoryViewController.swift
//  DungeonCrawl
//
//  Created by Thomas Aylesworth on 5/24/20.
//  Copyright © 2020 Thomas H Aylesworth. All rights reserved.
//

import UIKit

protocol DismissibleViewControllerDelegate: class {
    
    func dismiss(viewController: UIViewController)
}

struct InventoryViewModel {
    
    var items: [ItemViewModel]
    
    struct ItemViewModel {
        var name: String
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
        let itemText = inventory?.items[indexPath.row].name ?? "???"
        cell.textLabel?.text = itemText
        return cell
    }
}

fileprivate extension Selector {
    
    static let closeButtonTapped = #selector(InventoryViewController.closeButtonTapped)
}
