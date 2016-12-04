//
//  FinishViewController.swift
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/24.
//  Copyright © 2016年 shiba. All rights reserved.
//

import UIKit

class FinishViewController: UIViewController {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var friendNameLabel: UILabel!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var friendImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    
    public var studyTime: Int = 0
    public var isSuccess: Bool = true
    public var roomInfo: Dictionary<String, Any> = [:]
    var username: String = "shiba"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        friendNameLabel.text = roomInfo["hostUser"] as? String
        usernameLabel.text = username
        let second = studyTime % 60
        let minute = (studyTime / 60) % 60
        let hour = studyTime / 60 / 60
        timeLabel.text = String(format: "%02d:%02d:%02d", hour,minute,second)
        
        if isSuccess {
            resultLabel.text = "Congratulation!"
        } else {
            resultLabel.text = "Failed..."
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushedOk() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushedTweet() {
    
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
