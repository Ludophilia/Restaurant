//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Jeffrey on 24/12/2021.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    // MARK: Data
    
    // Note : Most of the data needed to operate this viewController comes from MenuController.shared.
    var orderMinutes = 0
    
    // MARK: General Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
    }
    
    // MARK: TableView Setup (UITableViewDataSource)
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }

    func configureOrderCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]

        var contentConfiguration = cell.defaultContentConfiguration()
        
        contentConfiguration.text = menuItem.name
        contentConfiguration.secondaryText = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            DispatchQueue.main.async {
                if let image = image {
                    contentConfiguration.image = image
                } else {
                    contentConfiguration.image = UIImage(named: "placeholder")
                }
                cell.contentConfiguration = contentConfiguration
            }
        }
        cell.contentConfiguration = contentConfiguration
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)

        configureOrderCell(cell, at: indexPath)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - TableView Setup (UITableViewDlegate)

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: UI Events Response
    
    func uploadOrder() {
        
        let menuIDs = MenuController.shared.order.menuItems.map() { $0.id }
        
        MenuController.shared.submitOrder(forMenuIDs: menuIDs) { minutes in
            DispatchQueue.main.async {
                if let waitingTime = minutes {
                    self.orderMinutes = waitingTime
                    self.performSegue(withIdentifier: "ThanksSegue", sender: nil)
                } else {
                    print("ERROR - SOMETHING WENT WRONG")
                }
            }
        }
    }
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem) {
        
        let priceTotal = MenuController.shared.order.menuItems.reduce(0.0) { subTotal, menuItem in subTotal + menuItem.price
        }
        let formattedPriceTotal = String(format: "$%.2f", priceTotal)
        
        let alertController = UIAlertController(title: nil, message: "Would you like to confirm your order of \(formattedPriceTotal)?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { alertAction in
            self.uploadOrder()
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ThanksSegue", let destination = segue.destination as? OrderConfirmationViewController {
            destination.minutes = self.orderMinutes
        }
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        if segue.identifier == "DissmissConfirmationSegue" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }

}
