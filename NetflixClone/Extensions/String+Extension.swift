//
//  String+Extension.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 21.02.2024.
//

import Foundation
extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
