//
//  MainTabBarViewController.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 20.02.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    let homeVC = UINavigationController(rootViewController: HomeVC())
    let upcomingVC = UINavigationController(rootViewController: UpcomingVC())
    let searchVC = UINavigationController(rootViewController: SearchVC())
    let downloadsVC = UINavigationController(rootViewController: DownloadsVC())
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar(){
        setViewControllers([homeVC , upcomingVC , searchVC , downloadsVC], animated: true)
        setTabBarImages()
        setTabBarTitles()
        tabBar.tintColor = .label
    }
    
    func setTabBarImages(){
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadsVC.tabBarItem.image = UIImage(systemName: "square.and.arrow.down")
    }
    
    func setTabBarTitles(){
        homeVC.tabBarItem.title = "Home"
        upcomingVC.tabBarItem.title = "Coming Soon"
        searchVC.tabBarItem.title = "Top Search"
        downloadsVC.tabBarItem.title = "Downloads"
    }

}

