//
//  MenuTabBarController.swift
//  Restaurant
//
//  Created by Jeffrey on 31/12/2021.
//

import UIKit

class MenuTabBarController: UITabBarController {
    
    var orderTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOrderTabBarItem()
    }
    
    @objc func updateOrderBadge() {
        
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }
    
    func setUpOrderTabBarItem() {
        orderTabBarItem = tabBar.items![1]
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
