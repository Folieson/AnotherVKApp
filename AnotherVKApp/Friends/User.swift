//
//  User.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 01/05/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import ObjectMapper
import RealmSwift

class User: Object, Mappable {
    var id = RealmOptional<Int>()
    @objc dynamic var firstName: String? = nil
    @objc dynamic var lastName: String? = nil
    @objc dynamic var photo: String? = nil
    @objc dynamic var fullName: String = ""
    var photoImage = UIImage(named: "camera_200.png")
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id.value <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        photo <- map["photo"]
        
        if let firstNameUnwrapped = firstName {
            fullName = firstNameUnwrapped
            if let lastNameUnwrapped = lastName {
                fullName += " " + lastNameUnwrapped
            }
        }
        
        
        
    }
    
    
}
