//
//  MyFriendsController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 29/01/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import Alamofire

class MyFriendsController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var myFriends: [User] = []
    let vkServices = VKServices<User>()
    
    var myFilteredFriends: [Character:[User]] {
        get {
            var result:[Character:[User]] = [Character:[User]]()
            
            for friend in self.myFriends {
                if let firstChar = friend.fullName.first {
                    if result.index(forKey: firstChar) != nil {
                        result[firstChar]!.append(friend)
                    } else {
                        result[firstChar] = [friend]
                    }
                }
            }
            return result
        }
    }
    
    struct GrouppedFriends {
        var firstChar: Character
        var friends: [User]
    }
    
    var grouppedFriendsArray = [GrouppedFriends]()
    
    var tableData = [GrouppedFriends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vkServices.loadFriends { friends in
            self.myFriends = friends
            
            for (key, value) in self.myFilteredFriends {
                self.grouppedFriendsArray.append(GrouppedFriends(firstChar: key, friends: value.sorted(by: {$0.fullName < $1.fullName})))
            }
            self.grouppedFriendsArray = self.grouppedFriendsArray.sorted(by: {$0.firstChar < $1.firstChar})
            self.tableData = self.grouppedFriendsArray
            self.tableView.reloadData()
        }
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("numberOfSections = \(tableData.count)")
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData[section].friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell

        // Configure the cell...
        let friend = tableData[indexPath.section].friends[indexPath.row]
        cell.name.text = friend.fullName
        print(friend.fullName)
        cell.icon.image = friend.photoImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(tableData[section].firstChar)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendPhoto" {
            let destinationVC = segue.destination as? MyFriendsPhotoController
            let cell = sender as! UITableViewCell
            if let indexPath = self.tableView.indexPath(for: cell) {
                destinationVC?.friendId = tableData[(indexPath.section)].friends[(indexPath.row)].id!
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyFriendsController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.tableData = self.grouppedFriendsArray
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.tableData = self.grouppedFriendsArray
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text?.removeAll()
        self.searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var text = searchBar.text {
            text = text.lowercased()
            if !tableData.isEmpty {
                tableData[0].friends.removeAll(where: {!$0.fullName.lowercased().contains(text)})
            }
        }
        self.tableView.reloadData()

    }
}
