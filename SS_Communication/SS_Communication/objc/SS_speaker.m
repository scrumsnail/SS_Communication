//
//  SS_speaker.m
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "SS_speaker.h"
#import "SS_define.h"
@implementation SS_speaker{
    //所有委托频道
    NSMutableDictionary *channels;
}
- (instancetype)init{
    if (self = [super init]) {
        SS_callback *defaultCallback = [[SS_callback alloc] init];
        channels = [[NSMutableDictionary alloc]init];
        [channels setObject:defaultCallback forKey:SS_DETAULT_CHANNEL];
    }
    return self;
}

- (SS_callback *)callback{
    return [channels objectForKey:SS_DETAULT_CHANNEL];
}
@end
