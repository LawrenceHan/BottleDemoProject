//
//  BottleStore.m
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import "BottleStore.h"
#import "BottleModel.h"
#import "BottleImageStore.h"

@interface BottleStore ()
@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation BottleStore

+ (instancetype)sharedStore
{
    static BottleStore *sharedStore;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BottleStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"bottles.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (BottleModel *)createItem {
    BottleModel *bottle = [[BottleModel alloc] init];
    [self.privateItems addObject:bottle];
    return bottle;
}

- (void)removeItem:(BottleModel *)item {
    NSString *key = item.itemKey;
    if (key) {
        [[BottleImageStore sharedStore] deleteImageForKey:key];
    }
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    BottleModel *bottle = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:bottle atIndex:toIndex];
}


@end
