//
//  Group.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 01/05/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Group: Object, Mappable {
//    static func == (lhs: Group, rhs: Group) -> Bool {
//        if lhs.id == rhs.id {
//            return true
//
//        } else {
//            return false
//        }
//    }
//
//    func hash(into hasher: inout Hasher) {
//
//    }
//    var hashValue: Int {
//        return (unwrapped_id).hashValue
//    }
    
    var id = RealmOptional<Int>()
    //var unwrapped_id = 0
    @objc dynamic var name: String? = nil
    @objc dynamic var photo: String? = nil
    var photoImage = UIImage(named: "camera_200.png")
    
    required convenience init?(map: Map) {
        self.init()
    }
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        id.value <- map["id"]
        name <- map["name"]
        photo <- map["photo_50"]
        
//        if let unwrappedId = id {
//            self.unwrapped_id = unwrappedId
//        }
        
        //нужно оптимизировать загрузку изображений
        //photoImage = VKServices<Group>.getImageFrom(urlAddress: photo)
        
        
    }
    
    
}
