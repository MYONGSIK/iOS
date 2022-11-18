//
//  TabBarViewController.swift
//  MYONGSIK
//
//  Created by gomin on 2022/10/30.
//

import UIKit

// MARK: 하단바 Custom
class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .white
        
       // 인스턴스화
        let resVC = RestaurantMainViewController()
        let mainVC = MainViewController()
        let heartVC = HeartViewController()
        
        resVC.tabBarItem.image = UIImage.init(named: "res")
        mainVC.tabBarItem.image = UIImage.init(named: "todayFood")
        heartVC.tabBarItem.image = UIImage.init(named: "heart")
        
        resVC.tabBarItem.title = "명지맛집"
        mainVC.tabBarItem.title = "오늘의 학식"
        heartVC.tabBarItem.title = "찜꽁리스트"
        
        self.tabBar.tintColor = .signatureBlue
        let fontAttributes = [NSAttributedString.Key.font: UIFont.NotoSansKR(size: 10, family: .Regular)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
       // navigationController의 root view 설정
        let nav1 = UINavigationController(rootViewController: resVC)
        let nav2 = UINavigationController(rootViewController: mainVC)
        let nav3 = UINavigationController(rootViewController: heartVC)
    
        setViewControllers([nav1, nav2, nav3], animated: false)
        
        self.selectedIndex = 1
    }
}
