//
//  User.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 01/05/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    var id: Int?
    var firstName: String?
    var lastName: String?
    var photo: String?
    var fullName: String = ""
    var photoImage = UIImage(named: "camera_200.png")
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        lastName <- map["last_name"]
        photo <- map["photo"]
        
        if let firstNameUnwrapped = firstName {
            fullName = firstNameUnwrapped
            if let lastNameUnwrapped = lastName {
                fullName += " " + lastNameUnwrapped
            }
        }
        
        VKServices<User>.downloadImageFrom(urlAddress: photo, completion: {image,error in
            if let downloadedImage = image {
                self.photoImage = downloadedImage
            } else {
                print(error as Any)
            }
        })
        
    }
    
    
}
