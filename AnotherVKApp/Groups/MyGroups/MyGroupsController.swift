//
//  MyGroupsController.swift
//  AnotherVKApp
//
//  Created by Андрей Понамарчук on 29/01/2019.
//  Copyright © 2019 Андрей Понамарчук. All rights reserved.
//

import UIKit
import Alamofire

class MyGroupsController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!

    var myGroups: [Group] = []
    let vkServices = VKServices<Group>()

    var myFilteredGroups: [Character:[Group]] {
        get {
            var result:[Character:[Group]] = [Character:[Group]]()
    
            for group in self.myGroups {
                if let firstChar = group.name?.first {
                    if result.index(forKey: firstChar) != nil {
                        result[firstChar]!.append(group)
                    } else {
                        result[firstChar] = [group]
                    }
                }
            }
            return result
        }
    }
    
    struct GrouppedGroups {
        var firstChar: Character
        var groups: [Group]
    }
    
    var grouppedGroupsArray = [GrouppedGroups]()
    
    var tableData = [GrouppedGroups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vkServices.loadUserGroups { groups in
            self.myGroups = groups
            for (key, value) in self.myFilteredGroups {
                self.grouppedGroupsArray.append(GrouppedGroups(firstChar: key, groups: value.sorted(by: {$0.name! < $1.name!})))
            }
            self.grouppedGroupsArray = self.grouppedGroupsArray.sorted(by: {$0.firstChar < $1.firstChar})
            self.tableData = self.grouppedGroupsArray
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
        return tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableData[section].groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell

        // Configure the cell...
        let group = tableData[indexPath.section].groups[indexPath.row]
        cell.name.text = group.name
        cell.icon.image = group.photoImage

        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        //Проверяем идентификатор? чтобы убедиться, что это нужный переход
//        if segue.identifier == "addGroup" {
//            //получаем ссылку на контроллер, с которого осуществляем переход
//            let allGroupsController = segue.source as! AllGroupsController
//            //получаем индекс выделенной ячейки
//            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
//                //получаем группу по индексу
//                let group = allGroupsController.allGroups[indexPath.row]
//                //Проверяем, что такой группы нет в списке
//                if !myGroups.contains(group) {
//                    //добавляем группу в список моих групп
//                    myGroups.append(group)
//                    //обновляем таблицу
//                    tableView.reloadData()
//                }
//            }
//        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            myGroups.remove(at: indexPath.row)
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
    

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

extension MyGroupsController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
        self.tableData = self.grouppedGroupsArray
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.tableData = self.grouppedGroupsArray
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
                tableData[0].groups.removeAll(where: {!$0.name!.lowercased().contains(text)})
            }
        }
        self.tableView.reloadData()
        
    }
}
