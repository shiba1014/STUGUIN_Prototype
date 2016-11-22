//
//  RoomListViewController.swift
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/22.
//  Copyright © 2016年 shiba. All rights reserved.
//

import UIKit

class RoomListViewController: UITableViewController {
    
    var roomArray: [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let room1: Dictionary<String, Any> = ["hostUser" : "Fumi Nikaido",
                                              "targetMinutes" : 30,
                                              "status" : "empty"]
        
        let room2: Dictionary<String, Any> = ["hostUser" : "Sho Sakurai",
                                              "targetMinutes" : 60,
                                              "status" : "empty"]
        
        let room3: Dictionary<String, Any> = ["hostUser" : "Go Ayano",
                                              "targetMinutes" : 60,
                                              "status" : "full"]
        
        roomArray.append(room1)
        roomArray.append(room2)
        roomArray.append(room3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return roomArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let roomInfo: Dictionary = roomArray[indexPath.row]
        let username:String = roomInfo["hostUser"] as! String
        
        cell.textLabel?.text = "Room\(indexPath.row + 1) -> \(username)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let roomInfo: Dictionary = roomArray[indexPath.row]
        let username:String = roomInfo["hostUser"] as! String
        let targetMinutes:Int = roomInfo["targetMinutes"] as! Int
        
        let alert = UIAlertController(title: nil, message: "\(username)さんと\(targetMinutes)分の勉強を始めますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("OK")
            
            let studyVC = StudyViewController()
            studyVC.roomInfo = roomInfo
            self.present(studyVC, animated: true, completion: nil)
            
        })
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}