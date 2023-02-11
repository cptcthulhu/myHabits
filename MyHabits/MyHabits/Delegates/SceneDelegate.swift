import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var feedTabNavigationController: UINavigationController!
    var profileTabNavigationController: UINavigationController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let tabBarController = UITabBarController()
        
        let habitsTabNavigationController = UINavigationController.init(rootViewController: HabitsViewController())
        let infoTabNavigationController = UINavigationController.init(rootViewController: InfoViewController())
        
        habitsTabNavigationController.modalPresentationStyle = .fullScreen
        
        tabBarController.viewControllers = [habitsTabNavigationController, infoTabNavigationController]
        
        let item1 = UITabBarItem(title: "Привычки", image: UIImage(named: "leftTapBarItem"), tag: 0)
        let item2 = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)
        
        habitsTabNavigationController.tabBarItem = item1
        infoTabNavigationController.tabBarItem = item2
        
        UITabBar.appearance().tintColor = UIColor(named: "Purple")
        UITabBar.appearance().backgroundColor = .white
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}
