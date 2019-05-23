//
//  Photo.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 02/05/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Photo: Object, Mappable {
    var id = RealmOptional<Int>()
    let sizes = List<PhotoSizes>()
    
    required convenience init?(map: Map) {
        self.init()
    }
//    override static func primaryKey() -> String? {
//        return "id"
//    }
    
    func mapping(map: Map) {
        var sizesArray:[PhotoSizes]?
        id.value <- map["id"]
        sizesArray <- map["sizes"]
        if let sizesUnwrappedArray = sizesArray {
            for size in sizesUnwrappedArray {
                sizes.append(size)
            }
        }
    }
    
    
}

class PhotoSizes: Object, Mappable {
    @objc dynamic var type: String? = nil
    @objc dynamic var url: String? = nil
    //var img:UIImage?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        url <- map["url"]
        
    }
    
    
}
