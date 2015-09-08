//
//  BottleModel.h
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BottleModel : NSObject

- (instancetype)initWithItemTitle:(NSString *)title
                  valueInDollars:(int)value
                    footnote:(NSString *)footnote;

@property (nonatomic, copy) NSString *bottleTitle;
@property (nonatomic, copy) NSString *bottleFootnote;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

@property (nonatomic, copy) NSString *itemKey;
@property (nonatomic, strong) UIImage *thumbnail;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
