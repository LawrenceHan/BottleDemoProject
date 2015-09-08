//
//  BottleDetailViewController.m
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import "BottleDetailViewController.h"
#import "BottleModel.h"
#import "BottleImageStore.h"

@interface BottleDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bottleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *parLine1;
@property (weak, nonatomic) IBOutlet UIImageView *parLine2;
@property (weak, nonatomic) IBOutlet UILabel *footnoteLabel;

@end

@implementation BottleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BottleModel *bottle = self.bottle;
    self.navigationItem.title = bottle.bottleTitle;
    self.footnoteLabel.text = bottle.bottleFootnote;
    
    NSString *itemKey = self.bottle.itemKey;
    if (itemKey) {
        UIImage *imageToDisplay = [[BottleImageStore sharedStore] imageForKey:itemKey];
        self.bottleImageView.image = imageToDisplay;
    } else {
        self.bottleImageView.image = nil;
    }
}

- (IBAction)save:(id)sender {
    // TODO: save changes
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
