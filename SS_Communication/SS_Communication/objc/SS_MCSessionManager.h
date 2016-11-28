//
//  SS_MCSessionManager.h
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "SS_speaker.h"
@interface SS_MCSessionManager : NSObject<MCSessionDelegate>{
    @public
    SS_speaker *ss_speaker;
}
@property (nonatomic,strong) MCSession *session;
@property (nonatomic,strong) MCPeerID *peerID;
@end
