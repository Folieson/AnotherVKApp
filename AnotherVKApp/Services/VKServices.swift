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
    private let token: String
    
    private let baseURL = "https://api.vk.com/method/"
    public let version = "5.95"
    
    
    
    init(token: String) {
        self.token = token
    }
    
    public func loadDataBy(method: String, parameters: Parameters, completition: @escaping (_ loadedData:[T])->()){
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
                    Alamofire.download(url).downloadProgress(closure: {progress in print(progress)}).responseData(completionHandler: {response in
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
        //print("response count = \(count)")
        items <- map["items"]
        //print("items count = \(items?.count)")
    }
    
    
}
