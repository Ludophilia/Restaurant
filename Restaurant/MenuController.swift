import Foundation
import UIKit

class MenuController {
    
    static var shared = MenuController()
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    static let menuDataUpdatedNotification = Notification.Name("MenuController.menuDataUpdated")
    
    private let baseURL = URL(string: "http://127.0.0.1:8090")!
    
    private var itemsByID = [Int:MenuItem]()
    private var itemsByCategory = [String:[MenuItem]]()
    
    var categories: [String] {
        return itemsByCategory.keys.sorted()
    }
    var order = Order() {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
            }
        }
    }
    
    func item(withID itemID: Int) -> MenuItem? {
        return itemsByID[itemID]
    }
    
    func items(forCategory category: String) -> [MenuItem]? {
        return itemsByCategory[category]
    }
    
    private func process(_ items: [MenuItem]) {
        itemsByID.removeAll()
        itemsByCategory.removeAll()
        
        for item in items {
            itemsByID[item.id] = item
            itemsByCategory[item.category, default: []].append(item) // WARNING : This Syntax adds to the dictionary itemsByCategory a new entry [item] at the key item.category if it doesn't exist !
        }
        
        NotificationCenter.default.post(name: MenuController.menuDataUpdatedNotification, object: nil) // Do we need the dispatchQueue async ? Not for now uh?
    }
    
    func loadRemoteData() {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        
        let loadRemoteDataTask = URLSession.shared.dataTask(with: initialMenuURL) { data, response, error in
            if let data = data, let menuItems = try? JSONDecoder().decode(MenuItems.self, from: data) {
                self.process(menuItems.items)
            } else {
                print("Something went wrong while fetching the items.")
            }
        }
        loadRemoteDataTask.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {

        let fetchImageTask = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        fetchImageTask.resume()
    }
    
    func saveItems() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let menuItemsURL = documentDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")
        let menuItems = Array(itemsByID.values)
        if let menuItemsData = try? JSONEncoder().encode(menuItems) {
            do {
                try menuItemsData.write(to: menuItemsURL)
            } catch {
                print("Something went wrong while wrinting the data ")
            }
        }
    }
    func loadItems() {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let menuItemsURL = documentDirectoryURL.appendingPathComponent("menuItems").appendingPathExtension("json")
        
        if let menuItemsData = try? Data(contentsOf: menuItemsURL), let menuItems = try? JSONDecoder().decode(Array<MenuItem>.self, from: menuItemsData) {
            process(menuItems)
        } else {
            print("Something went wrong while loading the Items")
        }
    }
    
    func loadOrder() {

        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let orderURL = documentURL.appendingPathComponent("order").appendingPathExtension(".json")
        
        if let orderData = try? Data(contentsOf: orderURL), let order = try? JSONDecoder().decode(Order.self, from: orderData) {
            self.order = order
        } else {
            self.order = Order(menuItems: [])
        }
    }
    
    func saveOrder() {
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let orderURL = documentURL.appendingPathComponent("order").appendingPathExtension(".json")
        
        if let orderData = try? JSONEncoder().encode(self.order) {
            do {
                try orderData.write(to: orderURL)
            } catch {
                print("Something went wrong while saving the order")
            }
        } else {
            print("Unable to save the order(s)")
        }
    }
    
    func submitOrder(forMenuIDs menuIds: [Int], completion: @escaping (Int?) -> Void) {
        
        let orderURL = baseURL.appendingPathComponent("order")
        
        var orderRequest = URLRequest(url: orderURL)
        orderRequest.httpMethod = "POST"
        orderRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonData = try? JSONEncoder().encode(data)
        orderRequest.httpBody = jsonData
        
        let submitOrderTask = URLSession.shared.dataTask(with: orderRequest) {
            data, response, error in

            if let data = data, let preparationTime = try? JSONDecoder().decode(PreparationTime.self, from: data) {
                completion(preparationTime.preparationTime)
            } else {
                completion(nil)
            }
        }
        submitOrderTask.resume()
    }
    

}
