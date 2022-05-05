import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // MARK: - Scene Delegate Lifecycle
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene), let userActivity = session.stateRestorationActivity else { return }
                
        if restoreViewControllers(with: userActivity) {
            scene.userActivity = userActivity
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        MenuController.shared.saveOrder()
        MenuController.shared.saveItems()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        MenuController.shared.saveOrder()
        MenuController.shared.saveItems()
    }
    
    // MARK: - State Restoration
    
    func restoreViewControllers(with userActivity: NSUserActivity) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if let menuTableViewController = storyboard.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController,
           let menuItemDetailViewController = storyboard.instantiateViewController(withIdentifier: "MenuItemDetailViewController") as? MenuItemDetailViewController,
            let tabBarController = window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers,
            let navigationController = viewControllers.first as? UINavigationController {
                        
            if menuTableViewController.restoreUserActivity(with: userActivity) {
                navigationController.pushViewController(menuTableViewController, animated: false)
            } else if menuItemDetailViewController.restoreUserActivity(with: userActivity) {
                navigationController.pushViewController(menuItemDetailViewController, animated: false)
            }
            return true
        } else {
            return false
        }
    }
        
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
}
