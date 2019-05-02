//
//  Group.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 01/05/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import ObjectMapper

class Group: Mappable, Hashable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        if lhs.id == rhs.id {
            return true
            
        } else {
            return false
        }
    }
    func hash(into hasher: inout Hasher) {
        
    }
//    var hashValue: Int {
//        return (unwrapped_id).hashValue
//    }
    
    var id: Int?
    //var unwrapped_id = 0
    var name: String?
    var photo: String?
    var photoImage = UIImage(named: "camera_200.png")
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        photo <- map["photo_50"]
        
//        if let unwrappedId = id {
//            self.unwrapped_id = unwrappedId
//        }
        
        //нужно оптимизировать загрузку изображений
        //photoImage = VKServices<Group>.getImageFrom(urlAddress: photo)
        
        VKServices<Group>.downloadImageFrom(urlAddress: photo, completion: {image,error in
            if let downloadedImage = image {
                self.photoImage = downloadedImage
            } else {
                print(error as Any)
            }
        })
    }
    
    
}
