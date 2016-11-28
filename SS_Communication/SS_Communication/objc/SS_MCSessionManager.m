//
//  SS_MCSessionManager.m
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "SS_MCSessionManager.h"
#define callbackBlock(...) if ([[ss_speaker callback] __VA_ARGS__])   [[ss_speaker callback] __VA_ARGS__ ]
@implementation SS_MCSessionManager

- (instancetype)init{
    if (self = [super init]) {
        _peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        _session = [[MCSession alloc] initWithPeer:_peerID];
        _session.delegate = self;
    }
    return self;
}
#pragma mark - MCSession Delegate method implementation
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    callbackBlock(blockOnChangeState)(session,peerID,state);
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    callbackBlock(blockOnReceiveData)(session,data,peerID);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    callbackBlock(blockOnStartReceivingResource)(resourceName,peerID,progress);
    dispatch_async(dispatch_get_main_queue(), ^{

    });
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    callbackBlock(blockOnFinishReceivingResource)(session,resourceName,peerID,localURL,error);
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    callbackBlock(blockOnReceiveStream)(session,stream,streamName,peerID);
}
@end
