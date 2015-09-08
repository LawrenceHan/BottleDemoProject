//
//  ViewController.m
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import "NewBottleViewController.h"
#import "BottleImageStore.h"
#import "BottleStore.h"
#import "BottleModel.h"

@interface NewBottleViewController () <UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView *bottleImageView;
@property (weak, nonatomic) IBOutlet UIImageView *parLine1;
@property (weak, nonatomic) IBOutlet UIImageView *parLine2;

//Use UIDynamicBehavior + PanGesture to animate par line
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;

@end

@implementation NewBottleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    UIPanGestureRecognizer *panGesture1 = [[UIPanGestureRecognizer alloc]
                              initWithTarget:self
                              action:@selector(handlePan:)];
    UIPanGestureRecognizer *panGesture2 = [[UIPanGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(handlePan:)];
    
    [self.parLine1 addGestureRecognizer:panGesture1];
    [self.parLine2 addGestureRecognizer:panGesture2];
    
    [self takePicture:self.takePictureFromCamera];
}

#pragma mark - Pan Gesture Delegate
- (void)handlePan:(UIPanGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateEnded ||
        g.state == UIGestureRecognizerStateCancelled) {
        [self stopDragging];
    }
    else {
        [self dragToPoint:[g locationInView:self.view] withView:g.view];
    }
}

- (void)dragToPoint:(CGPoint)point withView:(UIView *)view {
    [self.animator removeBehavior:self.snapBehavior];
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:view
                                                 snapToPoint:CGPointMake(view.frame.origin.x, point.y)];
    self.snapBehavior.damping = .25;
    [self.animator addBehavior:self.snapBehavior];
}

- (void)stopDragging {
    [self.animator removeBehavior:self.snapBehavior];
    self.snapBehavior = nil;
}

- (void)takePicture:(BOOL)fromCamera
{
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    
    // TODO: Add overlay view
    // imagePicker.cameraOverlayView = overlayView;
    if (fromCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:NULL];
    
}

#pragma mark - ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = self.bottle.itemKey;
    if (oldKey) {
        [[BottleImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.bottle setThumbnailFromImage:image];
    [[BottleImageStore sharedStore] setImage:image forKey:self.bottle.itemKey];
    self.bottleImageView.image = image;
    
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
    // If the user cancelled, then remoce the new bottle
    [[BottleStore sharedStore] removeItem:self.bottle];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (IBAction)nextTouched:(id)sender {
    //TODO: Show detail VC
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
