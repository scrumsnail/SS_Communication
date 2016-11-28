//
//  ChatViewController.m
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/25.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "ChatViewController.h"
#import "SS_define.h"
#import "WeChatViewController.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChatViewController
- (IBAction)b:(id)sender {
    WeChatViewController *w = [WeChatViewController new];
    w.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:w animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Address";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connection:) name:CONNECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disConnection:) name:DISCONNECT object:nil];
}

//断开连接通知
- (void)disConnection:(NSNotification *)noti{
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
}
//连接通知
- (void)connection:(NSNotification *)noti{
    _dataArray = noti.object;
    [self.tableView reloadData];
}


#pragma mark -- UITableViewDelegate、UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeChatViewController *w = [WeChatViewController new];
    w.navTitle = [NSString stringWithFormat:@"ChatWith%@",_dataArray[indexPath.row]];
    w.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:w animated:YES];
}

//释放
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
