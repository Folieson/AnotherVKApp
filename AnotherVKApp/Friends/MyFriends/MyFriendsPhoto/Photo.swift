//
//  Photo.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 02/05/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import ObjectMapper

class Photo: Mappable {
    var id: Int?
    var sizes: [PhotoSizes]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        sizes <- map["sizes"]
    }
    
    
}

class PhotoSizes: Mappable {
    var type: String?
    var url: String?
    //var img:UIImage?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        url <- map["url"]
        
    }
    
    
}
