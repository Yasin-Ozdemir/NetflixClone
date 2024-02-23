//
//  NavigationController+Extension.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 21.02.2024.
//

import Foundation
import UIKit

extension UINavigationController{
    func setupNavBar(backgroundColor :UIColor , textColor :UIColor , tintColor :UIColor){
        var apperance = UINavigationBarAppearance()
        apperance.backgroundColor = backgroundColor
                apperance.titleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold) , NSAttributedString.Key.foregroundColor : textColor]
        self.navigationBar.tintColor = tintColor
        
        self.navigationBar.standardAppearance = apperance
        self.navigationBar.scrollEdgeAppearance = apperance
        self.navigationBar.compactAppearance = apperance
    }
}
