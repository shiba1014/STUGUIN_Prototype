//
//  StudyViewController.swift
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/22.
//  Copyright © 2016年 shiba. All rights reserved.
//

import UIKit
import Parse

class StudyViewController: UIViewController {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var friendNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var friendImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    var time: Int = 0
    var isStudying:Bool = false
    var isLocked: Bool = false
    var timer: Timer!
    public var username: String = ""
    public var friendName: String = ""
    public var roomInfo: Dictionary<String, Any> = [:]
    
    class var sharedInstance: StudyViewController {
        struct Singleton {
            static let instance: StudyViewController = StudyViewController()
        }
        return Singleton.instance
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isStudying = true
        
        usernameLabel.text = username
        friendNameLabel.text = friendName
        
        let targetMinutes:Int = roomInfo["targetMinutes"] as! Int
        time = targetMinutes * 60
        let second = time % 60
        let minute = (time / 60) % 60
        let hour = time / 60 / 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hour,minute,second)
        
        Timer.scheduledTimer(timeInterval: 1.0,
                             target: self,
                             selector: #selector(countUp),
                             userInfo: nil,
                             repeats: true)
        
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(RoomListViewController.checkParse),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()
        
        let deviceStatus = DeviceLockStatus()
        deviceStatus.registerAppForDetectLockState()
        
        DeviceStatus.sharedInstance.addObserver(self, forKeyPath: "isLocked", options: .new, context: nil)
    }

    func countUp() {
        time -= 1
        let second = time % 60
        let minute = (time / 60) % 60
        let hour = time / 60 / 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hour,minute,second)
        if(time == 0){
            finish()
        }
    }
    
    public func finish() {
        isStudying = false
        timer.invalidate()
        let finishVC = FinishViewController()
        finishVC.roomInfo = roomInfo
        let studyTime: Int = (roomInfo["targetMinutes"] as? Int)!
        finishVC.studyTime = studyTime * 60 - time
        if time == 0 {
            finishVC.isSuccess = true
        } else {
            finishVC.isSuccess = false
            let query = PFQuery(className: "RoomObject")
            query.whereKey("hostUsername", equalTo: roomInfo["hostUsername"] as! String)
            query.getFirstObjectInBackground(block: { (object, error) in
                object?["isSuccess"] = false
                object?.saveInBackground()
            })
        }
        finishVC.username = username
        finishVC.friendName = friendName
        self.present(finishVC, animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "isLocked"){
            isLocked = DeviceStatus.sharedInstance.isLocked
            print("isLocked == \(isLocked)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkParse() {
        let query = PFQuery(className: "RoomObject")
        query.whereKey("hostUsername", equalTo: roomInfo["hostUsername"] as! String)
        query.getFirstObjectInBackground(block: { (object, error) in
            if object?["isSuccess"] as! Bool == false {
                self.finish()
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
