//
//  MasterViewController.m
//  ReusableXIB
//
//  Created by liuyaodong on 11/30/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "StatusTableViewCell.h"

#define kRedirectURI    @"YOUR REDIRECT URI"

static NSString * const kStatusCellId = @"statusCellId";

@interface MasterViewController ()<WBHttpRequestDelegate>
@property (nonatomic, copy) NSString *wbtoken;
@property (nonatomic, strong) NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.wbtoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (self.wbtoken) {
        [self rxib_fetchStatus];
    } else {
        UIBarButtonItem *authButton = [[UIBarButtonItem alloc] initWithTitle:@"授权" style:UIBarButtonItemStylePlain target:self action:@selector(authButtonClicked:)];
        self.navigationItem.rightBarButtonItem = authButton;
    }
    
    [self.tableView registerClass:[StatusTableViewCell class] forCellReuseIdentifier:kStatusCellId];
    self.tableView.estimatedRowHeight = 366;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}


#pragma mark - WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBAuthorizeResponse.class] && response.statusCode == WeiboSDKResponseStatusCodeSuccess)
    {
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        [[NSUserDefaults standardUserDefaults] setObject:self.wbtoken forKey:@"token"];
        self.navigationItem.rightBarButtonItem = nil;
        
        [self rxib_fetchStatus];
    }
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
    
    NSMutableArray *statusArray = [NSMutableArray array];
    for (NSDictionary *statusJSON in result[@"statuses"]) {
        NSDictionary *user = statusJSON[@"user"];
        if (statusJSON[@"original_pic"] && [statusJSON[@"comments_count"] intValue] > 0) {
            [statusArray addObject:@{
                                     @"text": statusJSON[@"text"] ?: @"",
                                     @"pictureURL": statusJSON[@"original_pic"],
                                     @"avatarURL": user[@"avatar_hd"],
                                     @"name": user[@"name"],
                                     @"id": statusJSON[@"id"],
                                     }];
        }
    }
    
    self.objects = statusArray;
    [self.tableView reloadData];
    
}


#pragma mark - Auth Action
- (void)authButtonClicked:(id)sender
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kStatusCellId];
    NSDictionary *status = self.objects[indexPath.row];
    [cell setAvatarURL:[NSURL URLWithString:status[@"avatarURL"]]];
    [cell setName:status[@"name"]];
    [cell setPictureURL:[NSURL URLWithString:status[@"pictureURL"]]];
    [cell setContent:status[@"text"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *controller = (DetailViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    controller.status = self.objects[indexPath.row];
    controller.wbtoken = self.wbtoken;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Helper
- (void)rxib_fetchStatus
{
    [WBHttpRequest requestWithAccessToken:self.wbtoken
                                      url:@"https://api.weibo.com/2/statuses/friends_timeline.json"
                               httpMethod:@"GET"
                                   params:@{@"source": kAppKey, @"count": @"200"}
                                 delegate:self
                                  withTag:nil];
}
@end
