//
//  VKServices.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 29/04/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

let imageCache = NSCache<NSString, UIImage>()

final class VKServices<T:Mappable> {
    
    
    private let session = Session.instance
    
    private let baseURL = "https://api.vk.com/method/"
    public let version = "5.95"
    
    private func loadDataBy(method: String, parameters: Parameters, completition: @escaping (_ loadedData:[T])->()){
        let url = baseURL+method
        Alamofire.request(url, parameters: parameters).responseObject(queue: .main, keyPath: nil, mapToObject: nil, context: nil, completionHandler: { (response: DataResponse<VKApiInitResponse<T>>) in
            if let vkApiInitResponse = response.result.value {
                if let vkApiResponse = vkApiInitResponse.response {
                    if let result = vkApiResponse.items {
                        print("func result = \(result.count)")
                        completition(result)
                    }
                }
            }
        })
    }
    
    public func loadFriends(completition: @escaping (_ friends:[User])->()){
        let method = "friends.get"
        let parameters: Parameters = [
            "user_id":self.session.userId,
            "order":"name",
            "fields":"name,photo",
            "access_token":self.session.token,
            "v":self.version
        ]
        loadDataBy(method: method, parameters: parameters, completition: {loadedData in
            completition(loadedData as! [User])
        })
        
    }
    
    public func loadUser(completition: @escaping (_ users:[User])->()){
        print("try to get username")
        let method = "users.get"
        let parameters: Parameters = [
            "user_ids":self.session.userId,
            "fields":"name,photo",
            "access_token":self.session.token,
            "v":self.version
        ]
        
        
        let url = baseURL+method
        Alamofire.request(url, parameters: parameters).responseObject(queue: .main, keyPath: nil, mapToObject: nil, context: nil, completionHandler: { (response: DataResponse<UserGetResponse>) in
            if let userGetTesponse = response.result.value {
                if let result = userGetTesponse.response {
                    print("func loadUser result = \(result.count)")
                    completition(result)
                }
            }
        })        
    }
    
    public func loadUserGroups(completition: @escaping (_ groups:[Group])->()){
        let method = "groups.get"
        let parameters: Parameters = [
            "user_id":self.session.userId,
            "extended":"1",
            "fields":"name,photo",
            "access_token":self.session.token,
            "v":self.version
        ]
        loadDataBy(method: method, parameters: parameters, completition: {loadedData in
            completition(loadedData as! [Group])
        })
        
    }
    
    public func loadGroupsBy(searchQuery: String, completition: @escaping (_ groups:[Group])->()){
        let method = "groups.search"
        let parameters: Parameters = [
            "q":searchQuery,
            "sort":"0",
            "count":"20",
            "access_token":self.session.token,
            "v":self.version
        ]
        loadDataBy(method: method, parameters: parameters, completition: {loadedData in
            completition(loadedData as! [Group])
        })
        
    }
    
    public func loadPhotos(_ friendId: String, completition: @escaping (_ photos:[Photo])->()){
        let method = "photos.get"
        let parameters: Parameters = [
            "owner_id":friendId,
            "album_id":"profile",
            "photo_sizes":"1",
            "access_token":self.session.token,
            "v":self.version
        ]
        loadDataBy(method: method, parameters: parameters, completition: {loadedData in
            completition(loadedData as! [Photo])
        })
        
    }
    
    
    //Необходима оптимизация загрузки изображений
//    public static func getImageFrom(urlAddress:String?) -> UIImage?{
//        var result: UIImage? = UIImage(named: "camera_200.png")
//        if let photoStringUnwrapped = urlAddress {
//            if let url = URL(string: photoStringUnwrapped) {
//                do {
//                    try result = UIImage(data: Data(contentsOf: url))
//                } catch {
//                    print(error)
//                }
//            }
//        }
//        return result
//    }
    
    //не всегда подгружаются изображения, необходимо найти ошибку
    public static func downloadImageFrom(urlAddress: String?, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let unwrappedString = urlAddress {
            if let url = URL(string: unwrappedString) {
                if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                    completion(cachedImage, nil)
                } else {
                    Alamofire.download(url).responseData(completionHandler: {response in
                        if let data = response.result.value {
                            if let newImage = UIImage(data: data) {
                                imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                                completion(newImage,nil)
                            }
                        } else {
                            completion(nil,response.error)
                        }
                        
                    })
                }
            }
        }
    }
}


class UserGetResponse:Mappable {
    var response: [User]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        response <- map["response"]
    }
    
    
}
class VKApiInitResponse<T:Mappable>:Mappable {
    var response: VKApiResoponse<T>?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        response <- map["response"]
    }
}
class VKApiResoponse<T:Mappable>: Mappable {
    var count: Int?
    var items: [T]?
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        items <- map["items"]
    }
    
    
}
