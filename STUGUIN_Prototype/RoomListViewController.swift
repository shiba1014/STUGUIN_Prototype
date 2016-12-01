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
    let waitingView: UIView = UIView()
    var username: String = "shiba"
    
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
                                              "status" : "full"]
        
        let room3: Dictionary<String, Any> = ["hostUser" : "Go Ayano",
                                              "targetMinutes" : 60,
                                              "status" : "empty"]
        
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
        let username: String = roomInfo["hostUser"] as! String
        let targetMinutes: Int = roomInfo["targetMinutes"] as! Int
        let status: String = roomInfo["status"] as! String
        
        cell.textLabel?.text = "Room\(indexPath.row + 1) -> \(username) \(targetMinutes) min"
        
        if(status == "full"){
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
        let username: String = roomInfo["hostUser"] as! String
        let targetMinutes:Int = roomInfo["targetMinutes"] as! Int
        let status: String = roomInfo["status"] as! String
        
        if(status == "full"){
            let alert = UIAlertController(title: nil, message: "このルームは埋まっています", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: nil, message: "\(username)さんと\(targetMinutes)分の勉強を始めますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            print("OK")
            
            let studyVC = StudyViewController()
            studyVC.roomInfo = roomInfo
            self.present(studyVC, animated: true, completion: nil)
            
            roomInfo["status"] = "full"
            self.roomArray[indexPath.row] = roomInfo
            
            
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
                                                                roomInfo["hostUser"] = self.username
                                                                roomInfo["targetMinutes"] = Int((textField?.text)!)
                                                                roomInfo["status"] = "empty"
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
//        view.translatesAutoresizingMaskIntoConstraints = false
        self.navigationController?.view.addSubview(waitingView)
        let statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        statusLabel.text = "Waiting..."
        statusLabel.textColor = UIColor.white
        statusLabel.center = waitingView.center
//        statusLabel.translatesAutoresizingMaskIntoConstraints = true
//        statusLabel.addConstraints([NSLayoutConstraint(item: statusLabel,
//                                                      attribute: .centerX,
//                                                      relatedBy: .equal,
//                                                      toItem: view,
//                                                      attribute: .centerX,
//                                                      multiplier: 1.0,
//                                                      constant: 0.0),
//                                   
//                                   NSLayoutConstraint(item: statusLabel,
//                                                      attribute: .centerY,
//                                                      relatedBy: .equal,
//                                                      toItem: view,
//                                                      attribute: .centerY,
//                                                      multiplier: 1.0,
//                                                      constant: 0.0)]
//        )
        
        waitingView.addSubview(statusLabel)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        cancelButton.setTitle("Delete Room", for: .normal)
        cancelButton.center = CGPoint(x: waitingView.center.x, y: waitingView.center.y + 50)
        cancelButton.addTarget(self, action: #selector(RoomListViewController.deleteView), for: .touchUpInside)
//        cancelButton.translatesAutoresizingMaskIntoConstraints = true
//        cancelButton.addConstraints([
//            NSLayoutConstraint(item: cancelButton,
//                               attribute: .top,
//                               relatedBy: .equal,
//                               toItem: statusLabel,
//                               attribute: .bottom,
//                               multiplier: 1.0,
//                               constant: 8.0),
//            
//            NSLayoutConstraint(item: cancelButton,
//                               attribute: .centerX,
//                               relatedBy: .equal,
//                               toItem: statusLabel,
//                               attribute: .centerX,
//                               multiplier: 1.0,
//                               constant: 0.0)
//            ])
        waitingView.addSubview(cancelButton)
        
    }
    
    func deleteView() {
        waitingView.removeFromSuperview()
        for i in 0..<roomArray.count {
            let roomInfo = roomArray[i]
            let hostUser: String = roomInfo["hostUser"] as! String
            if(hostUser == username){
                roomArray.remove(at: i)
                self.tableView.reloadData()
                break
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
