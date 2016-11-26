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
    
    public var roomInfo: Dictionary<String, Any> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        friendNameLabel.text = roomInfo["hostUser"] as? String
        let time: Int = (roomInfo["targetMinutes"] as? Int)!
        timeLabel.text = "\(time) min"
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
