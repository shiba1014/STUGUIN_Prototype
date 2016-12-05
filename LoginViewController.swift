//
//  LoginViewController.swift
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/12/04.
//  Copyright © 2016年 shiba. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet var addressTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    @IBOutlet var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField?.isSecureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login() {
        indicator.startAnimating()
        let address = addressTextField?.text
        let password = passwordTextField?.text
        PFUser.logInWithUsername(inBackground: address!, password: password!, block:  {
            (user, error) in
            if error != nil{
                print(error ?? "error")
                self.passwordTextField?.text = ""
                let alert = UIAlertController(title: nil, message: "Failed to login", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.indicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
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
