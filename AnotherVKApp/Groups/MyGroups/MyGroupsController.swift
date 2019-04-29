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
    
    //реализовать сортировку и поиск
    var myGroups = [
        "First Group",
        "Second Group",
        "Third Group"
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let session = Session.instance
        let vkServices = VKServices(token: session.token)
        let method = "groups.get"
        let parameters: Parameters = [
            "extended":"1",
            "access_token":session.token,
            "v":vkServices.version
        ]
        vkServices.printDataBy(method: method, parameters: parameters)
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
        return myGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell

        // Configure the cell...
        cell.name.text = myGroups[indexPath.row]

        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        //Проверяем идентификатор? чтобы убедиться, что это нужный переход
        if segue.identifier == "addGroup" {
            //получаем ссылку на контроллер, с которого осуществляем переход
            let allGroupsController = segue.source as! AllGroupsController
            //получаем индекс выделенной ячейки
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                //получаем город по индексу
                let group = allGroupsController.allGroups[indexPath.row]
                //Проверяем, что такого города нет в списке
                if !myGroups.contains(group) {
                    //добавляем город в список выбранных городов
                    myGroups.append(group)
                    //обновляем таблицу
                    tableView.reloadData()
                }
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
