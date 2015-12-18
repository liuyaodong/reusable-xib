//
//  StatusTableViewCell.h
//  ReusableXIB
//
//  Created by liuyaodong on 12/7/15.
//  Copyright © 2015 liuyaodong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusTableViewCell : UITableViewCell
- (void)setAvatarURL:(NSURL *)URL;
- (void)setPictureURL:(NSURL *)URL;
- (void)setName:(NSString *)name;
- (void)setContent:(NSString *)content;
@end
