//
//  AppDelegate.swift
//  DemoPhotoSearch
//
//  Created by KinWei on 2021/2/24.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let bag = DisposeBag()
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarController = UITabBarController()
        appFlowCoordinator = AppFlowCoordinator(tabBarController: tabBarController, container: appDIContainer)

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        appFlowCoordinator?.start()
            .subscribe()
            .disposed(by: bag)

        return true
    }

}

