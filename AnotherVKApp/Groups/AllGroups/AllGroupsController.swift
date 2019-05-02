//
//  AllGroupsController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 29/01/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import Alamofire

class AllGroupsController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    //сделать сортировку + поиск
    var tableData: [Group] = []


    override func viewDidLoad() {
        super.viewDidLoad()
//        let session = Session.instance
//        let vkServices = VKServices<Group>(token: session.token)
//        let method = "groups.search"
//        let parameters: Parameters = [
//            "q":searchQuery,
//            "sort":"0",
//            "count":"20",
//            "access_token":session.token,
//            "v":vkServices.version
//        ]
//        vkServices.loadDataBy(method: method, parameters: parameters, completition: { loadedData in
//            print("loadedData.count = \(loadedData.count)")
//            self.tableData = loadedData
////            self.myGroups = loadedData
////
////            for (key, value) in self.myFilteredGroups {
////                self.grouppedGroupsArray.append(GrouppedGroups(firstChar: key, groups: value.sorted(by: {$0.name! < $1.name!})))
////            }
////            self.grouppedGroupsArray = self.grouppedGroupsArray.sorted(by: {$0.firstChar < $1.firstChar})
////            self.tableData = self.grouppedGroupsArray
////            print("table data count = \(self.tableData.count)")
//            
//            self.loadView()
//        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell

        // Configure the cell...
        let group = tableData[indexPath.row]
        cell.name.text = group.name
        cell.icon.image = group.photoImage

        return cell
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

extension AllGroupsController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.tableData = []
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.tableData = []
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text?.removeAll()
        self.searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var searchQuery = searchBar.text {
            searchQuery = searchQuery.lowercased()
            let session = Session.instance
            let vkServices = VKServices<Group>(token: session.token)
            let method = "groups.search"
            let parameters: Parameters = [
                "q":searchQuery,
                "sort":"0",
                "count":"20",
                "access_token":session.token,
                "v":vkServices.version
            ]
            vkServices.loadDataBy(method: method, parameters: parameters, completition: { loadedData in
                print("loadedData.count = \(loadedData.count)")
                self.tableData = loadedData
                //            self.myGroups = loadedData
                //
                //            for (key, value) in self.myFilteredGroups {
                //                self.grouppedGroupsArray.append(GrouppedGroups(firstChar: key, groups: value.sorted(by: {$0.name! < $1.name!})))
                //            }
                //            self.grouppedGroupsArray = self.grouppedGroupsArray.sorted(by: {$0.firstChar < $1.firstChar})
                //            self.tableData = self.grouppedGroupsArray
                //            print("table data count = \(self.tableData.count)")
                self.tableView.reloadData()
                //self.loadView()
            })
        }
        
        
    }
}

