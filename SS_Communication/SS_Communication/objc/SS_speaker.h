//
//  SS_speaker.h
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SS_callback.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@interface SS_speaker : NSObject
- (SS_callback *)callback;
@end
