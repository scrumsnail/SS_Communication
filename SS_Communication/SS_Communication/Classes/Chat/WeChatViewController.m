//
//  WeChatViewController.m
//  SS_Communication
//
//  Created by allthings_LuYD on 2016/11/25.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "WeChatViewController.h"
#define kMessageTag 101
#define kBackgroundTag 102
#define identifier @"cell"
@interface WeChatViewController ()<UITableViewDataSource,UITableViewDelegate>{
    SS_communicate *SS;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *keybordView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) SS_communicate *SS;

@end

@implementation WeChatViewController
@synthesize SS;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _navTitle;
    SS = [SS_communicate shareCommunicate];
    _dataArray = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.separatorStyle = 0;
    [self registerForKeyboardNotifications];
    [self SS_communicateDelegate];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.tableView addGestureRecognizer:tap];
}
- (void)tap:(UITapGestureRecognizer *)tap{
    [self.textField resignFirstResponder];
}
- (IBAction)sendMsg:(id)sender {

    [self.textField resignFirstResponder];
    NSDictionary *messageDictionary = @{@"message" : self.textField.text , @"sender" : @"myself"};
    [_dataArray addObject: messageDictionary];

    NSData *dataToSend = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = SS->session.connectedPeers;
    NSError *error;
    [SS->session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];

    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    [self.tableView reloadData];
    self.textField.text = nil;
}

- (void)SS_communicateDelegate{
    __weak typeof(self)weakSelf = self;
    //节点改变状态的时候委托
    [SS setBlockOnChangeState:^(MCSession *session, MCPeerID *peerID, MCSessionState state) {
        if(state == MCSessionStateNotConnected){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"The peer has disconnected" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alert show];

            [weakSelf.SS->session disconnect];
            [[weakSelf navigationController] popViewControllerAnimated: YES];
        }
    }];

    //有新数据从节点过来委托
    [SS setBlockOnReceiveData:^(MCSession *session, NSData *ata, MCPeerID *peerID) {
        NSString *messageString = [[NSString alloc] initWithData:ata encoding:NSUTF8StringEncoding];
        NSDictionary *messageDictionary = @{@"message" : messageString , @"sender" : @"peer"};

        [weakSelf.dataArray addObject: messageDictionary];



        [weakSelf.tableView reloadData];

        //scroll to the last row

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
#pragma mark Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [[UIImage imageNamed:@"ChatBubbleGreen.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:13];
    rightImg.backgroundColor = [UIColor clearColor];
    UILabel *rightLable = [[UILabel alloc] init];
    rightLable.backgroundColor = [UIColor clearColor];
    rightLable.numberOfLines = 0;
    rightLable.lineBreakMode = NSLineBreakByWordWrapping;
    rightLable.font = [UIFont systemFontOfSize:14];


    UIImageView *leftImg = [[UIImageView alloc] init];
    leftImg.backgroundColor = [UIColor clearColor];
    leftImg.image = [[UIImage imageNamed:@"ChatBubbleGray.png"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.numberOfLines = 0;
    leftLabel.lineBreakMode = NSLineBreakByWordWrapping;
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.backgroundColor = [UIColor clearColor];
    NSString *message = [[_dataArray objectAtIndex: indexPath.row] objectForKey:@"message"];
    rightLable.text = message;
    leftLabel.text = message;
    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(180, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    if([[[_dataArray objectAtIndex: indexPath.row] objectForKey:@"sender"] isEqualToString: @"myself"]){
        rightImg.frame = CGRectMake(tableView.frame.size.width-size.width-34.0f, 1.0f, size.width+34.0f, size.height+12.0f);
        rightLable.frame = CGRectMake(tableView.frame.size.width-size.width-22.0f, 5.0f, size.width+5.0f, size.height);
        [cell.contentView addSubview:rightImg];
        [cell.contentView addSubview:rightLable];

    }else{
        leftImg.frame = CGRectMake(0.0f, 1.0f, size.width+34.0f, size.height+12.0f);
        leftLabel.frame = CGRectMake(22.0f, 5.0f, size.width+5.0f, size.height);
        [cell.contentView addSubview:leftImg];
        [cell.contentView addSubview:leftLabel];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *message = [[_dataArray objectAtIndex: indexPath.row] objectForKey:@"message"];

    CGSize size = [message sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(180, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + 17.0f;
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY = value.CGRectValue.origin.y;
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
    NSLog(@"keyboardWasShown");

    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, activeField.superview.superview.frame.origin) ) {
//        CGPoint scrollPoint = CGPointMake(0.0, activeField.superview.superview.frame.origin.y-aRect.size.height+44);
//        [displayTable setContentOffset:scrollPoint animated:YES];
//    }


    [UIView animateWithDuration:duration.doubleValue  animations:^{

        _keybordView.center = CGPointMake(_keybordView.center.x, keyBoardEndY - _keybordView.bounds.size.height/2.0);
    }];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    NSDictionary* info = [aNotification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.tableView.contentInset = contentInsets;
//    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView animateWithDuration:duration.doubleValue  animations:^{

        _keybordView.center = CGPointMake(_keybordView.center.x, self.view.frame.size.height - _keybordView.bounds.size.height/2.0);
    }];
}
@end
