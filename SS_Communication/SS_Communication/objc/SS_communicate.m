//
//  SS_communicate.m
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "SS_communicate.h"

@implementation SS_communicate{
    MCPeerID *peerID;
    MCBrowserViewController *browser;
    MCAdvertiserAssistant *advertiser;
    SS_MCSessionManager *sessionManager;
}
//单例模式
+ (instancetype)shareCommunicate{
    static SS_communicate *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[SS_communicate alloc] init];

    });
    return share;
}

//全局初始化
- (instancetype)init{
    if (self = [super init]) {
        sessionManager = [[SS_MCSessionManager alloc] init];
        ss_speaker = [[SS_speaker alloc] init];
        sessionManager->ss_speaker = ss_speaker;
        session = sessionManager.session;
    }
    return self;
}

//生成browser
- (SS_communicate *(^)())setUpBrowser{
    return ^SS_communicate *(){
        browser = [[MCBrowserViewController alloc] initWithServiceType:DETAULT_SERVICE_TYPE session:session];
        browser.delegate = self;
        return self;
    };
}

//发广播
- (SS_communicate *(^)())advertiser{
    return ^SS_communicate *(){
        advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:DETAULT_SERVICE_TYPE discoveryInfo:nil session:session];
        [advertiser start];
        return self;
    };
}

//显示browser
- (SS_communicate *(^)(UIViewController *))presentBrowserWithViewController{
    return ^SS_communicate *(UIViewController *vc){
        [vc presentViewController:browser animated:YES completion:nil];
        return self;
    };
}

//断开连接
- (SS_communicate *(^)())disConnect{
    return ^SS_communicate *(){
        if (session) {
            [session disconnect];
        }
        return self;
    };
}

#pragma mark -- MCSessionBlock
//节点改变状态的时候委托
- (void)setBlockOnChangeState:(void (^)(MCSession *, MCPeerID *, MCSessionState))block{
    [[ss_speaker callback] setBlockOnChangeState:block];
}
//有新数据从节点过来委托
- (void)setBlockOnReceiveData:(void (^)(MCSession *, NSData *, MCPeerID *))block{
    [[ss_speaker callback] setBlockOnReceiveData:block];
}

//开始接收资源委托
- (void)setBlockOndidStartReceivingResourceWithName:(void (^)(NSString *, MCPeerID *, NSProgress *))blobk{
    [[ss_speaker callback] setBlockOnStartReceivingResource:blobk];
}

//资源接收完委托
- (void)setBlockOndidFinishReceivingResourceWithName:(void (^)(MCSession *,NSString *, MCPeerID *, NSURL *, NSError *))blobk{
    [[ss_speaker callback] setBlockOnFinishReceivingResource:blobk];
}

// 接收流数据委托
- (void)setBlockOnReceiveStream:(void (^)(MCSession *,NSInputStream *, NSString *, MCPeerID *))block{
    [[ss_speaker callback] setBlockOnReceiveStream:block];
}

#pragma mark -- MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [browser dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [browser dismissViewControllerAnimated:YES completion:nil];
}

 
@end
