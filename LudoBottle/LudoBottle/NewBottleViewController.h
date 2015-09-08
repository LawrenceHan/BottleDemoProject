//
//  ViewController.h
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottleModel;

@interface NewBottleViewController : UIViewController
@property (nonatomic, strong) BottleModel *bottle;
@property (nonatomic) BOOL takePictureFromCamera;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end

