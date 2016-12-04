//
//  DeviceStatus.swift
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/27.
//  Copyright © 2016年 shiba. All rights reserved.
//

import UIKit

class DeviceStatus: NSObject {
    
    class var sharedInstance: DeviceStatus {
        struct Singleton {
            static let instance: DeviceStatus = DeviceStatus()
        }
        return Singleton.instance
    }
    
    dynamic var isLocked: Bool = false
    
    func locked(){
        print("device locked") // Handle Device Locked events here.
        self.isLocked = true
    }
    
    func unlocked(){
        print("device unlocked") //Handle Device Unlocked events here.
        self.isLocked = false
    }
}
