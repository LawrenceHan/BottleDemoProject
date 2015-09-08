//
//  BottleCell.m
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import "BottleCell.h"

@interface BottleCell ()

@end

@implementation BottleCell

- (void)updateFontDynamicTypeSize
{
    UIFont *headline = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    UIFont *footnote = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.bottleTitleLabel.font = headline;
    self.bottleFootnoteLabel.font = footnote;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self updateFontDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateFontDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.bottleTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bottleTitleLabel.frame);
    self.bottleFootnoteLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bottleFootnoteLabel.frame);
}

- (IBAction)imageTouched:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}


@end
