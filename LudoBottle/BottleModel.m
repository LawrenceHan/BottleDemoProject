//
//  BottleModel.m
//  LudoBottle
//
//  Created by Hanguang on 9/8/15.
//  Copyright (c) 2015 Hanguang. All rights reserved.
//

#import "BottleModel.h"

@interface BottleModel ()
@property (nonatomic, strong) NSDate *dateCreated;

@end

@implementation BottleModel

- (instancetype)initWithItemTitle:(NSString *)title
                   valueInDollars:(int)value
                         footnote:(NSString *)footnote
{
    self = [super init];
    if (self) {
        self.bottleTitle = title;
        self.bottleFootnote = footnote;
        self.valueInDollars = value;
        self.dateCreated = [[NSDate alloc] init];
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    return self;
}

- (instancetype)init {
    return [self initWithItemTitle:@"Bottle" valueInDollars:0 footnote:@""];
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     self.bottleTitle,
     self.bottleFootnote,
     self.valueInDollars,
     self.dateCreated];
    return descriptionString;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _bottleTitle = [aDecoder decodeObjectForKey:@"itemName"];
        _bottleFootnote = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.bottleTitle forKey:@"itemName"];
    [aCoder encodeObject:self.bottleFootnote forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

- (void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    CGRect newRect = CGRectMake(0, 0, 70, 90);
    
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    UIGraphicsEndImageContext();
}


@end
