//
//  PhotoViewController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 02/05/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var largePhoto: UIImageView!
    var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        largePhoto?.image = img

        // Do any additional setup after loading the view.
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
