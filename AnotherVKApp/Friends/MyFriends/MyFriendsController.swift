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
    
    
    let myFriends = [
        "Masha",
        "Sasha",
        "Denis",
        "Andrey"
    ]
    
    var myFilteredFriends: [Character:[String]] {
        get {
            var result:[Character:[String]] = [Character:[String]]()
            
            for friend in self.myFriends {
                //friend.first
                if let firstChar = friend.first {
                    if result.index(forKey: firstChar) != nil {
                        result[firstChar]!.append(friend)
                        //result[index].value.append(friend)
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
        var friends: [String]
    }
    
    var grouppedFriendsArray = [GrouppedFriends]()
    
    var tableData = [GrouppedFriends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (key, value) in myFilteredFriends {
            grouppedFriendsArray.append(GrouppedFriends(firstChar: key, friends: value.sorted(by: {$0 < $1})))
        }
        grouppedFriendsArray = grouppedFriendsArray.sorted(by: {$0.firstChar < $1.firstChar})
        tableData = grouppedFriendsArray
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let session = Session.instance
        let vkServices = VKServices(token: session.token)
        let method = "friends.get"
        let parameters: Parameters = [
                    "user_id":session.userId,
                    "order":"name",
                    "fields":"name",
                    "access_token":session.token,
                    "v":vkServices.version
        ]
        vkServices.loadDataBy(method: method, parameters: parameters)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData[section].friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell

        // Configure the cell...
        cell.name.text = tableData[indexPath.section].friends[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(tableData[section].firstChar)
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
            tableData.removeAll(where: {Character(String($0.firstChar).lowercased()) != text.first})
            if !tableData.isEmpty {
                tableData[0].friends.removeAll(where: {!$0.lowercased().contains(text)})
            }
        }
        self.tableView.reloadData()

    }
}
