//
//  ConnectionsViewController.m
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/24.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "ConnectionsViewController.h"
#import "SS_communicate.h"
#import "SS_define.h"
@interface ConnectionsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    SS_communicate *SS;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *connectedDevicesArray;

@end

@implementation ConnectionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Connection";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [UIView new];
    SS = [SS_communicate shareCommunicate];
    self.connectedDevicesArray = [NSMutableArray array];
    [self SS_communicateDelegate];
    
}

- (IBAction)disConnect:(id)sender {
    SS.disConnect();
    [self.connectedDevicesArray removeAllObjects];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:DISCONNECT object:nil];
}
- (IBAction)scan:(id)sender {
    SS.setUpBrowser().advertiser().presentBrowserWithViewController(self);
}

- (void)SS_communicateDelegate{
    __weak typeof(self)weakSelf = self;
    //节点改变状态的时候委托
    [SS setBlockOnChangeState:^(MCSession *session, MCPeerID *peerID, MCSessionState state) {
        if (state != MCSessionStateConnecting) {
            if (state == MCSessionStateConnected) {
                [weakSelf.connectedDevicesArray addObject:peerID.displayName];
            }else if (state == MCSessionStateNotConnected){
                if (weakSelf.connectedDevicesArray.count > 0) {
                    [weakSelf.connectedDevicesArray removeObject:peerID.displayName];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DISCONNECT object:nil];
                }
            }
        }
        if (weakSelf.connectedDevicesArray.count > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:CONNECT object:weakSelf.connectedDevicesArray];
        }
        [weakSelf.tableView reloadData];
    }];

    //有新数据从节点过来委托
    [SS setBlockOnReceiveData:^(MCSession *session, NSData *ata, MCPeerID *peerID) {

    }];

    //开始接收资源委托
    [SS setBlockOndidStartReceivingResourceWithName:^(NSString *resourceName, MCPeerID *peerID, NSProgress *progress) {

    }];

    //资源接收完委托
    [SS setBlockOndidFinishReceivingResourceWithName:^(MCSession *session, NSString *resourceName, MCPeerID *peerID, NSURL *localURL, NSError *error) {

    }];

    // 接收流数据委托
    [SS setBlockOnReceiveStream:^(MCSession *session, NSInputStream *stream, NSString *streamName, MCPeerID *peerID) {

    }];
}
#pragma mark -- UITableViewDelegate、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.connectedDevicesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.connectedDevicesArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
