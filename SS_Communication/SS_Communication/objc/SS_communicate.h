//
//  SS_communicate.h
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "SS_define.h"
#import "SS_speaker.h"
#import "SS_MCSessionManager.h"
@interface SS_communicate : NSObject<MCBrowserViewControllerDelegate>{
    SS_speaker *ss_speaker;
    @public
    MCSession *session;
}


/**
 单例构造方法

 @return SS_communicate共享实例
 */
+ (instancetype)shareCommunicate;

/**
 创建browser
 */
- (SS_communicate *(^)())setUpBrowser;


/**
 显示browser
 */
- (SS_communicate *(^)(UIViewController *vc))presentBrowserWithViewController;


/**
 断开连接
 */
- (SS_communicate *(^)())disConnect;



/**
 发广播
 */
- (SS_communicate *(^)())advertiser;


/**
 节点改变状态的时候
 三个状态：MCSessionStateConnected , MCSessionStateConnecting  and  MCSessionStateNotConnected
 最后一个状态在节点从连接断开后依然有效
 */
- (void)setBlockOnChangeState:(void (^)(MCSession *session,MCPeerID *peerID,MCSessionState state))block;


/**
 有新数据从节点过来
 消息，流和资源。
 */
- (void)setBlockOnReceiveData:(void (^)(MCSession *session,NSData *ata,MCPeerID *peerID))block;

/**
 开始接收资源
 */
- (void)setBlockOndidStartReceivingResourceWithName:(void (^)(NSString *resourceName,MCPeerID *peerID,NSProgress*progress))blobk;


/**
 资源接收完
 */
- (void)setBlockOndidFinishReceivingResourceWithName:(void (^)(MCSession *session,NSString *resourceName,MCPeerID *peerID,NSURL *localURL,NSError *error))blobk;


/**
 接收流数据
 */
- (void)setBlockOnReceiveStream:(void (^)(MCSession *session,NSInputStream *stream,NSString *streamName,MCPeerID *peerID))block;
@end
