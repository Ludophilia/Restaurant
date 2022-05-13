//
//  OrderConfirmation.swift
//  Restaurant
//
//  Created by Jeffrey on 03/01/2022.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    // MARK: Data
    
    var minutes: Int!

    // MARK: UI Components
    
    @IBOutlet var timeRemainingLabel: UILabel!
    
    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Your order will be ready in \(minutes!) minutes"
    }
}
