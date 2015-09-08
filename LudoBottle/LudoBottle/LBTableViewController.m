//
//  LBTableViewController.m
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import "LBTableViewController.h"
#import "BottleStore.h"
#import "BottleImageStore.h"
#import "BottleModel.h"
#import "BottleCell.h"
#import "BottleDetailViewController.h"
#import "NewBottleViewController.h"
#import "NewBottleDetailViewController.h"

@interface LBTableViewController () <UIActionSheetDelegate>
@property (nonatomic, strong) BottleCell *prototypeCell;

@end

@implementation LBTableViewController {
    NSIndexPath *_currentIndexPath;
    UIActionSheet *_actionSheet;
    BOOL _takePictureFromCamera;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScene];
}

- (void)setupScene {
    UINavigationItem *navItem = self.navigationItem;
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addNewItem)];

    navItem.rightBarButtonItem = bbi;
    navItem.leftBarButtonItem = self.editButtonItem;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateTableViewForDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
    
    // Register custom cell
    [self.tableView registerClass:[BottleCell class] forCellReuseIdentifier:NSStringFromClass([BottleCell class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTableViewForDynamicTypeSize];
}

- (void)updateTableViewForDynamicTypeSize
{
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BottleStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    BottleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BottleCell class]) forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(BottleCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *bottles = [[BottleStore sharedStore] allItems];
    BottleModel *bottle = bottles[indexPath.row];
    
    cell.bottleTitleLabel.text = bottle.bottleTitle;
    cell.bottleFootnoteLabel.text = bottle.bottleFootnote;
    cell.bottleImageView.image = bottle.thumbnail;
    
    // TODO: Image action block
    /* Uncomment if you need an action for click on bottle image
    __weak BottleCell *weakCell = cell;
    cell.actionBlock = ^{
        BottleCell *strongSelf = weakCell;
    };
    */
    
    // Make sure the constraints have been added to this cell, since it may have just been created from scratch
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:NSStringFromClass([BottleDetailViewController class]) sender:self];
    _currentIndexPath = indexPath;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NSStringFromClass([BottleDetailViewController class])]) {
        BottleDetailViewController *detailViewController = segue.destinationViewController;
        NSArray *bottles = [[BottleStore sharedStore] allItems];
        BottleModel *bottle = bottles[_currentIndexPath.row];
        detailViewController.bottle = bottle;
    } else if ([segue.identifier isEqualToString:NSStringFromClass([NewBottleViewController class])]) {
        BottleModel *bottle = [[BottleStore sharedStore] createItem];
        NewBottleViewController *newBC = segue.destinationViewController;
        newBC.bottle = bottle;
        newBC.takePictureFromCamera = _takePictureFromCamera;
        newBC.dismissBlock = ^{
            [self.tableView reloadData];
        };
    }
}

- (void)tableView:(UITableView *)tableView
  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
   forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *bottles = [[BottleStore sharedStore] allItems];
        BottleModel *bottle = bottles[indexPath.row];
        [[BottleStore sharedStore] removeItem:bottle];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView
  moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
         toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BottleStore sharedStore] moveItemAtIndex:sourceIndexPath.row
                                        toIndex:destinationIndexPath.row];
}

- (void)addNewItem {
    if (_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"Add new bottle"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                          otherButtonTitles:@"Take Picture", @"Select From Library", nil];
    }
    
    [_actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        _takePictureFromCamera = YES;
    } else if (buttonIndex == 1) {
        _takePictureFromCamera = NO;
    }
    // TODO: Show an alert view if user don't have a camera or don't have permission
    [self performSegueWithIdentifier:NSStringFromClass([NewBottleViewController class]) sender:self];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
