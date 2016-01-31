//
//  libGlobalFunction.h
//  libGlobalFunction
//
//  Created by liww on 14-9-18.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZEdgeInsets.h"

@interface PublicFunction : NSObject

//NinePartImage
+ (NSMutableArray *)cropNinePartImages:(NSImage*)stretchImage
                     leftRightCapWidth:(NSUInteger)leftRightCapWidth
                     topBottomCapWidth:(NSUInteger)topBottomCapWidth
                       centerCapHeight:(NSUInteger)centerCapWidth;

+ (NSArray *)cropNinePartImages:(NSImage*)stretchImage
              leftRightCapWidth:(NSUInteger)leftRightCapWidth
              topBottomCapWidth:(NSUInteger)topBottomCapWidth;

+ (NSImage *)cropImageFromRect:(NSImage *)image rect:(NSRect)rect;
+ (NSImage *)tileNinePartImage:(NSArray*)ninePartImages imageSize:(NSSize)imageSize;

//
+ (NSArray *)ninePartWithImage:(NSImage*)img size:(NSSize)size edgeInsets:(LZEdgeInsets)insets;
+ (NSImage *)stretchableImage:(NSImage*)srcImage size:(NSSize)size edgeInsets:(NSEdgeInsets)insets;
@end
