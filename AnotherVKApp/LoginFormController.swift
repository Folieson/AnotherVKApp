//
//  LoginFormController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 28/01/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import KeychainAccess


class LoginFormController: UIViewController {
    @IBOutlet weak var helloLabel: UILabel!
    //let segue = UIStoryboardSegue(identifier: "toTBController", source: self(), destination: <#T##UIViewController#>)
    let keychain = Keychain(service: "new.AnotherVKApp")
    let session = Session.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        if let userName = userDefaults.string(forKey: "userName") {
            session.userName = userName
            print(userName)
            self.helloLabel.text = "Hello, \(userName)!"
        } else {
            self.helloLabel.text = "Hello, you need to log in!"
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let token = try? keychain.getString("token") {
            print("token = \(token)")
            if let userId = try? keychain.getString("userId") {
                print("userId = \(userId)")
                session.token = token
                session.userId = userId
                print("get token from keychain")
            }
            sleep(2)
            self.performSegue(withIdentifier: "toTBController", sender: nil)
        } else {
            sleep(2)
            self.performSegue(withIdentifier: "toWVController", sender: nil)
        }
        
    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        let checkResult = checkUserData()
//
//        if !checkResult {
//            showLoginError()
//        }
////        let session = Session.instance
////        session.token = "someToken"
////        session.userId = 12345
//        return checkResult
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
