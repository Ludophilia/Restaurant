import UIKit

class MenuItemDetailViewController: UIViewController {
    
    var menuItem: MenuItem!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailTextLabel: UILabel!
    @IBOutlet var addToOrderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUserActivity()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        flushUserActivity()
    }
    
    private func updateUI() {
        titleLabel.text = menuItem.name
        priceLabel.text = String(format:"$ %.2f", menuItem.price)
        detailTextLabel.text = menuItem.itemDescription
        
        MenuController.shared.fetchImage(url: menuItem.imageURL) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.imageView.image = image
                } else {
                    self.imageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    @IBAction func orderButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // It works, strangely enough.
            self.addToOrderButton.setTitle("Added", for: .normal)

        } completion: { _ in
            self.addToOrderButton.setTitle("Add To Order", for: .normal)
        }
        MenuController.shared.order.menuItems.append(menuItem)
    }
    
    // MARK: - State Restoration
        
    func updateUserActivity() {
        let currentUserActivity = view.window?.windowScene?.userActivity ?? NSUserActivity(activityType: "com.example.mainActivity")
        currentUserActivity.addUserInfoEntries(from: ["menuItemId" : menuItem.id])
        view.window?.windowScene?.userActivity = currentUserActivity
    }
    
    func flushUserActivity() {
        if let _ = view.window?.windowScene?.userActivity {
            view.window?.windowScene?.userActivity = nil
        }
    }
        
    func restoreUserActivity(with userActivity: NSUserActivity) -> Bool {
        if let menuItemID = userActivity.userInfo?["menuItemId"] as? Int,
           let menuItem = MenuController.shared.item(withID: menuItemID) {
            self.menuItem = menuItem
            return true
        } else {
            return false
        }
    }

    // MARK: - State Restoration for Conservatives
    
//    override func encodeRestorableState(with coder: NSCoder) {
//        super.encodeRestorableState(with: coder)
//        print("MenuItemDetailViewController encodeRestorableState")
//
//        coder.encode(menuItem.id, forKey: "menuItemId")
//    }
//
//    override func decodeRestorableState(with coder: NSCoder) {
//        super.decodeRestorableState(with: coder)
//        print("MenuItemDetailViewController decoderestorableState")
//        let menuItemID = coder.decodeInteger(forKey: "menuItemId")
//
//        if let menuItem = MenuController.shared.item(withID: menuItemID) {
//            self.menuItem = menuItem
//            updateUI()
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
