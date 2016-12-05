//
//  RoomListViewController.swift
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/22.
//  Copyright © 2016年 shiba. All rights reserved.
//

import UIKit
import Parse

class RoomListViewController: UITableViewController {
    
    var roomArray: [Dictionary<String, Any>] = []
    let waitingView: UIView = UIView()
    var username: String = ""
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if PFUser.current() == nil {
            let loginVC = LoginViewController()
            self.present(loginVC, animated: true, completion: nil)
            return
        }
        
        let query = PFQuery(className: "RoomObject")
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object:PFObject in objects! {
                    var room: Dictionary<String, Any> = [:]
                    room["hostUsername"] = object["hostUsername"]
                    room["targetMinutes"] = object["targetMinutes"]
                    room["isEmpty"] = object["isEmpty"]
                    self.roomArray.append(room)
                }
                self.tableView.reloadData()
            }
        }
        
        let usernameQuery = PFQuery(className: "UserInfomationObject")
        let user = PFUser.current()
        usernameQuery.whereKey("user", equalTo: user!)
        usernameQuery.getFirstObjectInBackground { (object, error) in
            if error == nil {
                self.username = object?["usernameForUser"] as! String
            }
        }
        
//        let room1: Dictionary<String, Any> = ["hostUser" : "Fumi Nikaido",
//                                              "targetMinutes" : 1,
//                                              "status" : "empty"]
//        
//        let room2: Dictionary<String, Any> = ["hostUser" : "Sho Sakurai",
//                                              "targetMinutes" : 60,
//                                              "status" : "full"]
//        
//        let room3: Dictionary<String, Any> = ["hostUser" : "Go Ayano",
//                                              "targetMinutes" : 60,
//                                              "status" : "empty"]
//        
//        roomArray.append(room1)
//        roomArray.append(room2)
//        roomArray.append(room3)
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
        let friendName: String = roomInfo["hostUsername"] as! String
        let targetMinutes:Int = roomInfo["targetMinutes"] as! Int
        let isEmpty: Bool = roomInfo["isEmpty"] as! Bool

        
        cell.textLabel?.text = "Room\(indexPath.row + 1) -> \(friendName) \(targetMinutes) min"
        
        if(!isEmpty){
            cell.backgroundColor = UIColor.red
            cell.textLabel?.textColor = UIColor.white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var roomInfo: Dictionary = roomArray[indexPath.row]
        let friendName: String = roomInfo["hostUsername"] as! String
        let targetMinutes:Int = roomInfo["targetMinutes"] as! Int
        let isEmpty: Bool = roomInfo["isEmpty"] as! Bool
        
        if(!isEmpty){
            let alert = UIAlertController(title: nil, message: "このルームは埋まっています", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let alert = UIAlertController(title: nil, message: "\(friendName)さんと\(targetMinutes)分の勉強を始めますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("OK")
            
            let studyVC = StudyViewController.sharedInstance
            studyVC.roomInfo = roomInfo
            studyVC.username = self.username
            studyVC.friendName = friendName
            self.present(studyVC, animated: true, completion: nil)
            
            roomInfo["isEmpty"] = false
            let query = PFQuery(className: "RoomObject")
            query.whereKey("hostUsername", equalTo: friendName)
            query.getFirstObjectInBackground(block: { (object, error) in
                object?["isEmpty"] = false
                object?["isSuccess"] = true
                object?["guestUsername"] = self.username
                object?.saveInBackground()
            })
            self.roomArray.remove(at: indexPath.row)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pushedPlus() {
        let alert:UIAlertController = UIAlertController(title:nil,
                                                        message: "新しいルームを作ります",
                                                        preferredStyle: .alert)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: .cancel,
                                                       handler:nil)
        let okAction:UIAlertAction = UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler:{
                                                            (action:UIAlertAction!) -> Void in
                                                            print("OK")
                                                            let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                                                            if textFields != nil {
                                                                let textField = textFields?[0]
                                                                var roomInfo: Dictionary<String, Any> = [:]
                                                                roomInfo["hostUsername"] = self.username
                                                                roomInfo["targetMinutes"] = Int((textField?.text)!)
                                                                roomInfo["isEmpty"] = true
                                                                
                                                                let object = PFObject(className: "RoomObject")
                                                                object["hostUsername"] = self.username
                                                                object["targetMinutes"] = Int((textField?.text)!)
                                                                object["isEmpty"] = true
                                                                object.saveInBackground()
                                                                self.roomArray.append(roomInfo)
                                                                self.tableView.reloadData()
                                                                self.createWaitingView()
                                                            }
        })
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
            text.placeholder = "設定時間（分）"
            text.keyboardType = .numberPad
        })
        present(alert, animated: true, completion: nil)
    }
    
    func createWaitingView() {
        waitingView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        waitingView.backgroundColor = UIColor.orange
        self.navigationController?.view.addSubview(waitingView)
        let statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        statusLabel.text = "Waiting..."
        statusLabel.textColor = UIColor.white
        statusLabel.center = waitingView.center
        waitingView.addSubview(statusLabel)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        cancelButton.setTitle("Delete Room", for: .normal)
        cancelButton.center = CGPoint(x: waitingView.center.x, y: waitingView.center.y + 50)
        cancelButton.addTarget(self, action: #selector(RoomListViewController.deleteView), for: .touchUpInside)
        waitingView.addSubview(cancelButton)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(RoomListViewController.checkParse), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func deleteView() {
        timer.invalidate()
        waitingView.removeFromSuperview()
        for i in 0..<roomArray.count {
            let roomInfo = roomArray[i]
            let hostUser: String = roomInfo["hostUsername"] as! String
            if(hostUser == username){
                roomArray.remove(at: i)
                self.tableView.reloadData()
                break
            }
            
            let query = PFQuery(className: "RoomObject")
            query.whereKey("hostUsername", equalTo: username)
            query.getFirstObjectInBackground(block: { (object, error) in
                if error == nil {
                    object?.deleteInBackground()
                }
            })
        }
    }
    

    
    func checkParse() {
        print("check")
        let query = PFQuery(className: "RoomObject")
        query.whereKey("hostUsername", equalTo: username)
        do{
            let object = try query.getFirstObject()
            if object["isEmpty"] as! Bool == false {
                let studyVC = StudyViewController.sharedInstance
                var roomInfo: Dictionary<String, Any> = [:]
                roomInfo["hostUsername"] = object["hostUsername"]
                roomInfo["targetMinutes"] = object["targetMinutes"]
                roomInfo["isEmpty"] = object["isEmpty"]
                studyVC.roomInfo = roomInfo
                studyVC.username = self.username
                studyVC.friendName = object["guestUsername"] as! String
                self.present(studyVC, animated: true, completion: nil)
                timer.invalidate()
                waitingView.removeFromSuperview()
                for i in 0..<roomArray.count {
                    let roomInfo = roomArray[i]
                    let hostUser: String = roomInfo["hostUsername"] as! String
                    if(hostUser == username){
                        roomArray.remove(at: i)
                        self.tableView.reloadData()
                        break
                    }
                }
            }
        } catch {
            print("no result")
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
