//
//  StatusTableViewCell.m
//  ReusableXIB
//
//  Created by liuyaodong on 12/7/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "StatusViewOwner.h"
#import <UIImageView+WebCache.h>

@implementation StatusTableViewCell
{
    StatusViewOwner     *_statusViewOwner;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _statusViewOwner = [StatusViewOwner new];
        [self.contentView addSubview:_statusViewOwner.view];
        _statusViewOwner.view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *map = @{@"view": _statusViewOwner.view};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:map]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:map]];
    }
    return self;
}

- (void)setAvatarURL:(NSURL *)URL
{
    [_statusViewOwner.avatarImageView sd_setImageWithURL:URL];
}

- (void)setPictureURL:(NSURL *)URL
{
    [_statusViewOwner.contentImageView sd_setImageWithURL:URL];
}

- (void)setName:(NSString *)name
{
    _statusViewOwner.nameLabel.text = name;
}

- (void)setContent:(NSString *)content
{
    _statusViewOwner.contentLabel.text = content;
}

@end
