//
//  DeviceLockStatus.h
//  STUGUIN_Prototype
//
//  Created by Paul McCartney on 2016/11/26.
//  Copyright © 2016年 shiba. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DeviceLockStatus : NSObject

@property (strong, nonatomic) id someProperty;

-(void)registerAppForDetectLockState;

@end
