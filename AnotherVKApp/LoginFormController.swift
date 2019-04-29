//
//  LoginFormController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 28/01/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit



class LoginFormController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "admin" && password == "1111" {
            print("successful login")
        } else {
            print("wrong login/password")
        }
    }
    
    //When keyaboard appears
    @objc func keyboardWasShown(notification: Notification) {
        //getting keyboard size
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        //getting inded that equals to kbSize at the bottom of the UIScrollView
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //When kb dissapears
    @objc func keyboardWillBeHidden(notification:Notification) {
        //set inded equal to 0 at the bottom the UIScrollView
        let contentInsents = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsents
        scrollView?.scrollIndicatorInsets = contentInsents
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //Второе - когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        // Присваиваем его UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let checkResult = checkUserData()
        
        if !checkResult {
            showLoginError()
        }
//        let session = Session.instance
//        session.token = "someToken"
//        session.userId = 12345
        return checkResult
    }
    
    func checkUserData() -> Bool {
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "admin" && password == "1111" {
            return true
        } else {
            //return false
            return true
        }
    }
    
    func showLoginError() {
        // создаем контроллер
        let alertController = UIAlertController(title: "Error", message: "Wrong user data", preferredStyle: .alert)
        //Создаем кнопку ддя UIAlertController
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // добавляем alertAction на alertController
        alertController.addAction(alertAction)
        // показываем alertController
        self.present(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
