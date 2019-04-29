//
//  VKServices.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 29/04/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import Alamofire

final class VKServices {
    private let token: String
    
    private let baseURL = "https://api.vk.com/method/"
    //private var method = ""
   // private var parameters: Parameters = [:]
    public let version = "5.95"
    
    
    init(token: String) {
        self.token = token
    }
    
    public func printDataBy(method: String, parameters: Parameters){
        let url = baseURL+method
        //var responseValue:Data
        Alamofire.request(url, parameters: parameters).validate().responseJSON(completionHandler: {response in
            switch response.result{
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        })
    }
    
}
