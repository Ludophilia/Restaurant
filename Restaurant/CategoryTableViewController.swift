import UIKit

class CategoryTableViewController: UITableViewController {
    
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCategories), name: MenuController.menuDataUpdatedNotification, object: nil)
        updateCategories()
    }
    
    @objc func updateCategories() {
        categories = MenuController.shared.categories
//        print("categories updated")
        tableView.reloadData() // Is this really needed?
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    private func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let category = self.categories[indexPath.row]

        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = category.capitalized // category.removeFirst().uppercased() + category
        cell.contentConfiguration = contentConfiguration
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIdentifier", for: indexPath)
        
        configure(cell, forItemAt: indexPath)
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue", let menuTableViewController = segue.destination as? MenuTableViewController, let selectedRow = tableView.indexPathForSelectedRow?.row {

            let selectedCategory = categories[selectedRow]
            menuTableViewController.category = selectedCategory
        }
    }
}
