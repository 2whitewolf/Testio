//
//  TabBarViewController.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.unselectedItemTintColor = .black
        tabBar.tintColor = UIColor.appBlue
        setupVCs()
    }
    
    
    func setupVCs() {
        viewControllers = [
            //               createNavController(for: TestsViewController(), image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: TestsViewController(),title: "Test list", image: UIImage(named: "list")!),
            createNavController(for: BatteryViewController(),title: "Battery" , image: UIImage(named: "battery")!)
        ]
        
        
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                                                               title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        //            navController.navigationBar.prefersLargeTitles = true
//                    rootViewController.navigationItem.title = title
        return navController
    }
    
}
