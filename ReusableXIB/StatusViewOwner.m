//
//  StatusViewOwner.m
//  ReusableXIB
//
//  Created by liuyaodong on 12/7/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "StatusViewOwner.h"

@interface StatusViewOwner ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeightConstraint;
@end

@implementation StatusViewOwner

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"StatusView" owner:self options:nil];
        self.avatarImageView.layer.cornerRadius = 20;
    }
    return self;
}

- (void)setFixedContentHeight:(BOOL)flag
{
    self.contentHeightConstraint.active = flag;
}
@end
