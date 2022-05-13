import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let temporaryDirectory = URL(string: NSTemporaryDirectory())
        URLCache.shared = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, directory: temporaryDirectory)
        
        MenuController.shared.loadOrder()
        MenuController.shared.loadItems()
        
        MenuController.shared.loadRemoteData()
        
        return true
    }
}

