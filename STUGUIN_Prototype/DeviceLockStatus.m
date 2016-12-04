//
//  DeviceLockStatus.m
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/26.
//  Copyright © 2016年 shiba. All rights reserved.
//

#import "DeviceLockStatus.h"
#import "notify.h"
#import "STUGUIN_Prototype-Swift.h"

@implementation DeviceLockStatus

-(void)registerAppForDetectLockState{
    int notifyToken;
    notify_register_dispatch("com.apple.springboard.lockstate", &notifyToken, dispatch_get_main_queue(), ^(int token){
        uint64_t state = UINT64_MAX;
        notify_get_state(token, &state);
        
        DeviceStatus *object = [DeviceStatus sharedInstance];  //DeviceStatus is .swift file
        
        if(state == 0) {
            [object unlocked];
        } else {
            [object locked];
        }
    });
}

@end
