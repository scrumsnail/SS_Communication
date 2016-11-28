//
//  SS_callback.h
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

//节点改变状态的时候委托
typedef void (^SSChangeStateBlock)(MCSession *session,MCPeerID *peerID,MCSessionState state);
//有新数据从节点过来委托
typedef void (^SSReceiveDataBlock)(MCSession *session,NSData *ata,MCPeerID *peerID);
//开始接收资源委托
typedef void (^SSStartReceivingResourceBlock)(NSString *resourceName,MCPeerID *peerID,NSProgress*progress);
//资源接收完委托
typedef void (^SSFinishReceivingResourceBlock)(MCSession *session,NSString *resourceName,MCPeerID *peerID,NSURL *localURL,NSError *error);
// 接收流数据委托
typedef void (^SSReceiveStreamBlock)(MCSession *session,NSInputStream *stream,NSString *streamName,MCPeerID *peerID);

@interface SS_callback : NSObject

#pragma mark - callback block
//节点改变状态block
@property (nonatomic, copy) SSChangeStateBlock blockOnChangeState;
//有新数据从节点过来block
@property (nonatomic, copy) SSReceiveDataBlock blockOnReceiveData;
//开始接收资源block
@property (nonatomic, copy) SSStartReceivingResourceBlock blockOnStartReceivingResource;
//资源接收完block
@property (nonatomic, copy) SSFinishReceivingResourceBlock blockOnFinishReceivingResource;
// 接收流数据委托block
@property (nonatomic, copy) SSReceiveStreamBlock blockOnReceiveStream;
@end
