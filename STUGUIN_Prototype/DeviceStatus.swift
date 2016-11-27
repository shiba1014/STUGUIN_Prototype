//
//  DeviceStatus.swift
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/27.
//  Copyright © 2016年 shiba. All rights reserved.
//

import UIKit

class DeviceStatus: NSObject {
    func locked(){
        print("device locked") // Handle Device Locked events here.
    }
    
    func unlocked(){
        print("device unlocked") //Handle Device Unlocked events here.
    }
}
