//
//  BottleStore.h
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BottleModel;

@interface BottleStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;
- (BottleModel *)createItem;
- (void)removeItem:(BottleModel *)item;

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex;

- (BOOL)saveChanges;

@end
