//
//  MenuTabBarController.swift
//  Restaurant
//
//  Created by Jeffrey on 31/12/2021.
//

import UIKit

class MenuTabBarController: UITabBarController {
    
    // MARK: TabBar UI Elements

    var orderTabBarItem: UITabBarItem!
    
    // MARK: Setup

    func setUpOrderTabBarItem() {
        orderTabBarItem = tabBar.items![1]
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpOrderTabBarItem()
    }
    
    // MARK: TabBar State Refresh
    
    @objc func updateOrderBadge() {
        
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }

}
