//
//  MyFriendsPhotoController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 29/01/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import Alamofire

class MyFriendsPhotoController: UICollectionViewController {
    var friendId = 0
    var photos: [Photo] = []
    let vkServices = VKServices<Photo>()
    var collectionData:[Int:(String?,String?)] = [Int:(String?,String?)]()
    var collectionDataArray: [(String?,String?)] = [(String?,String?)]()
    let middleSizePhotoTypes = ["m", "o", "p", "q"]
    let largeSizePhotoTypes = ["x","y","z", "w", "r"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vkServices.loadPhotos(String(friendId)) { loadedPhotos in
            self.photos = loadedPhotos
            initLoop: for photo in self.photos {
                if let photoId = photo.id {
                    self.collectionData[photoId] = (nil,nil)
                    if let photoSizes = photo.sizes {
                        sizesLoop: for photoSize in photoSizes {
                            if let urlString = photoSize.url {
                                if let photoType = photoSize.type {
                                    if self.middleSizePhotoTypes.contains(photoType) {
                                        self.collectionData[photoId]?.0 = urlString
                                    } else if self.largeSizePhotoTypes.contains(photoType) {
                                        self.collectionData[photoId]?.1 = urlString
                                    }
                                    if (self.collectionData[photoId]?.0 != nil) && (self.collectionData[photoId]?.1 != nil) {
                                        continue initLoop
                                    }
                                }
                            }
                        }
                    }
                }
                
                
            }
            
            for (_,value) in self.collectionData{
                self.collectionDataArray.append((value.0,value.1))
            }
            self.collectionView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return collectionDataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyFriendsPhotoCell", for: indexPath) as! MyFriendsPhotoCell
        
        VKServices<User>.downloadImageFrom(urlAddress: collectionDataArray[indexPath.row].0, completion: {image,error in
            if let downloadedImage = image {
                cell.photo.image = downloadedImage
            } else {
                print(error.debugDescription)
            }
        })
        
    
        // Configure the cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLargePhoto"{
            let destinationVC = segue.destination as? PhotoViewController
            guard let cell = sender as? UICollectionViewCell else { return }
            if let indexPath = self.collectionView!.indexPath(for: cell) {
                destinationVC?.url = collectionDataArray[indexPath.row].1
            }
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
extension MyFriendsPhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 3
        var widthRemainingForCellContent = collectionView.bounds.width
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
        }
        let cellWidth = widthRemainingForCellContent / cellsAcross
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}

