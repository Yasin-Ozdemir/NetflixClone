//
//  RealmDBModel.swift
//  NetflixClone
//
//  Created by Yasin Özdemir on 6.03.2024.
//

import Foundation
import RealmSwift

class RealmDBModel : Object{
    @objc dynamic var id : Int64 = 0
    @objc dynamic var name : String = ""
    @objc dynamic var poster_path : String = ""
    @objc dynamic var url : String = ""
  
}
