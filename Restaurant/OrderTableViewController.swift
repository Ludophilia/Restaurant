//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Jeffrey on 24/12/2021.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var orderMinutes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
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
        
        let priceTotal = MenuController.shared.order.menuItems.reduce(0.0) { initialNumber, menuItem in
            initialNumber + menuItem.price
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)

        configureOrderCell(cell, at: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
