//
//  DetailViewController.m
//  ReusableXIB
//
//  Created by liuyaodong on 11/30/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "DetailViewController.h"
#import "StatusViewOwner.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import <UIImageView+WebCache.h>


static NSString * const kCommentCellId = @"commentCellId";

@interface DetailViewController ()<WBHttpRequestDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic, copy) NSArray *comments;
@property (nonatomic, strong) StatusViewOwner *statusViewOwner;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.statusViewOwner = [StatusViewOwner new];
    
    [self.statusViewOwner.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.status[@"avatarURL"]]];
    self.statusViewOwner.nameLabel.text = self.status[@"name"];
    [self.statusViewOwner.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.status[@"pictureURL"]]];
    self.statusViewOwner.contentLabel.text = self.status[@"text"];
    [self.statusViewOwner setFixedContentHeight:NO];
    
    [WBHttpRequest requestWithAccessToken:self.wbtoken
                                      url:@"https://api.weibo.com/2/comments/show.json"
                               httpMethod:@"GET"
                                   params:@{@"source": kAppKey, @"id": [self.status[@"id"] stringValue]}
                                 delegate:self
                                  withTag:nil];
    
    
}

#pragma mark - TableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellId];
    cell.textLabel.text = self.comments[indexPath.row];
    return cell;
}

#pragma mark - WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!result) {
        NSLog(@"error: %@", error.description);
        return;
    }
    
    NSMutableArray *comments = [NSMutableArray array];
    for (NSDictionary *comment in result[@"comments"]) {
        [comments addObject:comment[@"text"] ?: @""];
    }
    
    self.comments = comments;
    [self.commentTableView reloadData];
    
    [self setupTableHeaderView];
}

#pragma mark - Helper
- (void)setupTableHeaderView
{
    self.statusViewOwner.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentTableView.frame) - 16;
    
    UIView *statusView = self.statusViewOwner.view;
    CGRect frame = statusView.frame;
    
    [statusView setNeedsLayout];
    [statusView layoutIfNeeded];
    
    CGFloat height = [statusView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    frame.size.height = height;
    statusView.frame = frame;
    
    self.commentTableView.tableHeaderView = statusView;
}

@end
