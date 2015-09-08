//
//  BottleCell.h
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bottleImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottleFootnoteLabel;

@property (copy, nonatomic) void (^actionBlock)(void);
@end
