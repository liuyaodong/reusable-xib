//
//  StatusViewOwner.h
//  ReusableXIB
//
//  Created by liuyaodong on 12/7/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewOwner : NSObject
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)setFixedContentHeight:(BOOL)flag;

@end
