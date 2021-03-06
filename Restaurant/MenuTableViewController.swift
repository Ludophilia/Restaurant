import UIKit

class MenuTableViewController: UITableViewController {

    // MARK: Data
    
    var category: String! // Since this shouldn't be displayed without category data, make the property an implicitely unwrapped optional.
    var menuItems = [MenuItem]()
    
    // MARK: Setup and Refresh
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: MenuController.menuDataUpdatedNotification, object: nil)
        
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUserActivity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        flushUserActivity()
    }
    
    @objc func updateUI() {
        title = category.capitalized

        menuItems = MenuController.shared.items(forCategory: category) ?? []
        tableView.reloadData()
    }

    // MARK: TableView Setup (UITableViewDataSource)

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    private func configureMenuCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]

        var contentConfiguration = cell.defaultContentConfiguration()
        
        contentConfiguration.text = menuItem.name
        contentConfiguration.secondaryText = String(format: "$%.2f", menuItem.price)

        // Why not rework this piece with async/await ?
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        configureMenuCell(cell, at: indexPath)

        return cell
    }

    // MARK: - TableView Setup (UITableViewDelegate)
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - State Restoration
        
    func updateUserActivity() {
        let currentUserActivity = view.window?.windowScene?.userActivity ?? NSUserActivity(activityType: "com.example.mainActivity")
        currentUserActivity.addUserInfoEntries(from: ["category" : category!])
        view.window?.windowScene?.userActivity = currentUserActivity
    }
    
    func flushUserActivity() {
        if let _ = view.window?.windowScene?.userActivity {
            view.window?.windowScene?.userActivity = nil
        }
    }
        
    func restoreUserActivity(with userActivity: NSUserActivity) -> Bool {
        if let category = userActivity.userInfo?["category"] as? String {
            self.category = category
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Navigation
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MenuDetailSegue", let detailViewController = segue.destination as? MenuItemDetailViewController, let selectedRow = tableView.indexPathForSelectedRow?.row {
            
            detailViewController.menuItem = menuItems[selectedRow]
        }
    }

}
