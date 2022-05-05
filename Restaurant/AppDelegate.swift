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

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
// MARK: State Restoration for Conservatives

//    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
//        return true
//    }
//
//    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
//        return true
//    }

//    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
//        print("Encoding state...")
////        print("category key: \(coder.containsValue(forKey: "category"))")
////        print("menuItemId key: \(coder.containsValue(forKey: "menuItemId"))")
//    }
//
//    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
//        print("state decoded...")
//
//    }

}

