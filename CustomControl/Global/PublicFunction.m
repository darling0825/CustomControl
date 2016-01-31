//
//  libGlobalFunction.m
//  libGlobalFunction
//
//  Created by liww on 14-9-18.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PublicFunction.h"

@implementation PublicFunction

+ (NSMutableArray *)cropNinePartImages:(NSImage *)stretchImage
                     leftRightCapWidth:(NSUInteger)leftRightCapWidth
                     topBottomCapWidth:(NSUInteger)topBottomCapWidth
                       centerCapHeight:(NSUInteger)centerCapWidth
{
	if (nil == stretchImage) {
		return nil;
	}
	
	NSMutableArray *ninePartImages = [[NSMutableArray alloc] initWithCapacity:9];
	
	NSUInteger templateImageWidth = stretchImage.size.width;
	NSUInteger templateImageHeight = stretchImage.size.height;
    NSRect rect;
    NSImage *image = nil;
    
    //11
	rect = NSMakeRect(0, templateImageHeight-topBottomCapWidth, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //12
	rect = NSMakeRect((templateImageWidth - centerCapWidth)/2, templateImageHeight-topBottomCapWidth, centerCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //13
	rect = NSMakeRect(templateImageWidth-leftRightCapWidth, templateImageHeight-topBottomCapWidth, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //21
	rect = NSMakeRect(0, (templateImageHeight-centerCapWidth)/2, leftRightCapWidth, centerCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
	
    //22
    rect = NSMakeRect((templateImageWidth - centerCapWidth)/2, (templateImageHeight-centerCapWidth)/2, centerCapWidth, centerCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //23
	rect = NSMakeRect(templateImageWidth-leftRightCapWidth, (templateImageHeight-centerCapWidth)/2, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //31
	rect = NSMakeRect(0, 0, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
	//32
    rect = NSMakeRect((templateImageWidth - centerCapWidth)/2, 0, centerCapWidth, centerCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
	//33
    rect = NSMakeRect(templateImageWidth-leftRightCapWidth, 0, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
	return [ninePartImages autorelease];
}

+ (NSArray *)cropNinePartImages:(NSImage*)stretchImage
              leftRightCapWidth:(NSUInteger)leftRightCapWidth
              topBottomCapWidth:(NSUInteger)topBottomCapWidth
{
    if (nil == stretchImage) {
        return nil;
    }
    
    NSMutableArray *ninePartImages = [[NSMutableArray alloc] initWithCapacity:9];
    
    NSUInteger templateImageWidth = stretchImage.size.width;
    NSUInteger templateImageHeight = stretchImage.size.height;
    NSRect rect;
    NSImage *image = nil;
    
    //11
    rect = NSMakeRect(0, templateImageHeight-topBottomCapWidth, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //12
    rect = NSMakeRect(leftRightCapWidth, templateImageHeight-topBottomCapWidth, templateImageWidth - 2*leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //13
    rect = NSMakeRect(templateImageWidth-leftRightCapWidth, templateImageHeight-topBottomCapWidth, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //21
    rect = NSMakeRect(0, topBottomCapWidth, leftRightCapWidth, templateImageHeight - 2*topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //22
    rect = NSMakeRect(leftRightCapWidth, topBottomCapWidth, templateImageWidth - 2*leftRightCapWidth, templateImageHeight - 2*topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //23
    rect = NSMakeRect(templateImageWidth-leftRightCapWidth, topBottomCapWidth, leftRightCapWidth, templateImageHeight - 2*topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //31
    rect = NSMakeRect(0, 0, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //32
    rect = NSMakeRect(leftRightCapWidth, 0, templateImageWidth - 2*leftRightCapWidth, templateImageHeight - 2*topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //33
    rect = NSMakeRect(templateImageWidth-leftRightCapWidth, 0, leftRightCapWidth, topBottomCapWidth);
    image = [[self cropImageFromRect:stretchImage rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    return [ninePartImages autorelease];
}

+ (NSImage *)cropImageFromRect:(NSImage *)image rect:(NSRect)rect
{
    NSImage *subImage = [[NSImage alloc] initWithSize:rect.size];
    NSRect drawRect = NSZeroRect;
    drawRect.size = rect.size;
    
    [subImage lockFocus];
    [image drawInRect:drawRect
             fromRect:rect
            operation:NSCompositeSourceOver
             fraction:1.0f];
    [subImage unlockFocus];
    return [subImage autorelease];
}

+ (NSImage *)tileNinePartImage:(NSArray*)ninePartImages imageSize:(NSSize)imageSize
{
    if (imageSize.width == 0 || imageSize.height == 0) {
        return nil;
    }
    
    if (ninePartImages == nil || [ninePartImages count] <= 0) {
        return nil;
    }
    
	NSImage *resultImage = [[NSImage alloc] initWithSize:imageSize];
	NSRect boundsRect = NSMakeRect(0, 0, imageSize.width, imageSize.height);
    
	[resultImage lockFocus];
	NSDrawNinePartImage(boundsRect,
						[ninePartImages objectAtIndex:0],
						[ninePartImages objectAtIndex:1],
						[ninePartImages objectAtIndex:2],
						[ninePartImages objectAtIndex:3],
						[ninePartImages objectAtIndex:4],
						[ninePartImages objectAtIndex:5],
						[ninePartImages objectAtIndex:6],
						[ninePartImages objectAtIndex:7],
						[ninePartImages objectAtIndex:8],
						NSCompositeSourceOver, 1.0, NO);
	[resultImage unlockFocus];
	return [resultImage autorelease];
}


+ (NSImage *)stretchableImage:(NSImage*)srcImage size:(NSSize)size edgeInsets:(NSEdgeInsets)insets
{
    void (^makeAreas)(NSRect, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *)
    = ^(NSRect srcRect, NSRect *tl, NSRect *tc, NSRect *tr, NSRect *ml, NSRect *mc, NSRect *mr, NSRect *bl, NSRect *bc, NSRect *br)
    {
        CGFloat w = NSWidth(srcRect);
        CGFloat h = NSHeight(srcRect);
        CGFloat cw = w - insets.left - insets.right;
        CGFloat ch = h - insets.top - insets.bottom;
        
        CGFloat x0 = NSMinX(srcRect);
        CGFloat x1 = x0 + insets.left;
        CGFloat x2 = NSMaxX(srcRect) - insets.right;
        
        CGFloat y0 = NSMinY(srcRect);
        CGFloat y1 = y0 + insets.bottom;
        CGFloat y2 = NSMaxY(srcRect) - insets.top;
        
        *tl = NSMakeRect(x0, y2, insets.left, insets.top);
        *tc = NSMakeRect(x1, y2, cw, insets.top);
        *tr = NSMakeRect(x2, y2, insets.right, insets.top);
        
        *ml = NSMakeRect(x0, y1, insets.left, ch);
        *mc = NSMakeRect(x1, y1, cw, ch);
        *mr = NSMakeRect(x2, y1, insets.right, ch);
        
        *bl = NSMakeRect(x0, y0, insets.left, insets.bottom);
        *bc = NSMakeRect(x1, y0, cw, insets.bottom);
        *br = NSMakeRect(x2, y0, insets.right, insets.bottom);
    };
    
    NSRect rect = NSMakeRect(0, 0, size.width, size.height);
    
    // Source rects
    NSRect srcRect = (NSRect){NSZeroPoint, srcImage.size};
    NSRect srcTopL, srcTopC, srcTopR, srcMidL, srcMidC, srcMidR, srcBotL, srcBotC, srcBotR;
    makeAreas(srcRect, &srcTopL, &srcTopC, &srcTopR, &srcMidL, &srcMidC, &srcMidR, &srcBotL, &srcBotC, &srcBotR);
    
    // Destinations rects
    NSRect dstTopL, dstTopC, dstTopR, dstMidL, dstMidC, dstMidR, dstBotL, dstBotC, dstBotR;
    makeAreas(rect, &dstTopL, &dstTopC, &dstTopR, &dstMidL, &dstMidC, &dstMidR, &dstBotL, &dstBotC, &dstBotR);
    
    NSRect srcRects[] = {srcTopL, srcTopC, srcTopR, srcMidL, srcMidC, srcMidR, srcBotL, srcBotC, srcBotR};
    NSRect dstRects[] = {dstTopL, dstTopC, dstTopR, dstMidL, dstMidC, dstMidR, dstBotL, dstBotC, dstBotR};
    NSMutableArray *partImgs = [NSMutableArray arrayWithCapacity:9];
    for (int i=0;i<9;i++)
    {
        NSRect aSrcRect = srcRects[i];
        NSRect aDstRect = dstRects[i];
        
        NSImage *partImg = [[NSImage alloc] initWithSize:aSrcRect.size];
        [partImg lockFocus];
        [srcImage drawAtPoint:NSZeroPoint fromRect:aSrcRect operation:NSCompositeCopy fraction:1.0];
        [partImg setSize:aDstRect.size];
        [partImg unlockFocus];
        [partImgs addObject:partImg];
        [partImg release]; partImg = nil;
    }
    
    // Draw
    NSImage *resultImg = [[NSImage alloc] initWithSize:rect.size];
    [resultImg lockFocus];
    NSDrawNinePartImage(rect,
                        [partImgs objectAtIndex:0],
                        [partImgs objectAtIndex:1],
                        [partImgs objectAtIndex:2],
                        [partImgs objectAtIndex:3],
                        [partImgs objectAtIndex:4],
                        [partImgs objectAtIndex:5],
                        [partImgs objectAtIndex:6],
                        [partImgs objectAtIndex:7],
                        [partImgs objectAtIndex:8],
                        NSCompositeSourceOver, 1, NO);
    [resultImg unlockFocus];
    return [resultImg autorelease];
}

+ (NSArray *)ninePartWithImage:(NSImage*)img size:(NSSize)size edgeInsets:(LZEdgeInsets)insets
{
    void (^makeAreas)(NSRect, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *, NSRect *)
    = ^(NSRect srcRect, NSRect *tl, NSRect *tc, NSRect *tr, NSRect *ml, NSRect *mc, NSRect *mr, NSRect *bl, NSRect *bc, NSRect *br)
    {
        CGFloat w = NSWidth(srcRect);
        CGFloat h = NSHeight(srcRect);
        CGFloat cw = w - insets.left - insets.right;
        CGFloat ch = h - insets.top - insets.bottom;
        
        CGFloat x0 = NSMinX(srcRect);
        CGFloat x1 = x0 + insets.left;
        CGFloat x2 = NSMaxX(srcRect) - insets.right;
        
        CGFloat y0 = NSMinY(srcRect);
        CGFloat y1 = y0 + insets.bottom;
        CGFloat y2 = NSMaxY(srcRect) - insets.top;
        
        *tl = NSMakeRect(x0, y2, insets.left, insets.top);
        *tc = NSMakeRect(x1, y2, cw, insets.top);
        *tr = NSMakeRect(x2, y2, insets.right, insets.top);
        
        *ml = NSMakeRect(x0, y1, insets.left, ch);
        *mc = NSMakeRect(x1, y1, cw, ch);
        *mr = NSMakeRect(x2, y1, insets.right, ch);
        
        *bl = NSMakeRect(x0, y0, insets.left, insets.bottom);
        *bc = NSMakeRect(x1, y0, cw, insets.bottom);
        *br = NSMakeRect(x2, y0, insets.right, insets.bottom);
    };
    
    NSRect rect = NSMakeRect(0, 0, size.width, size.height);
    
    // Source rects
    NSRect srcRect = (NSRect){NSZeroPoint, img.size};
    NSRect srcTopL, srcTopC, srcTopR, srcMidL, srcMidC, srcMidR, srcBotL, srcBotC, srcBotR;
    makeAreas(srcRect, &srcTopL, &srcTopC, &srcTopR, &srcMidL, &srcMidC, &srcMidR, &srcBotL, &srcBotC, &srcBotR);
    
    // Destinations rects
    NSRect dstTopL, dstTopC, dstTopR, dstMidL, dstMidC, dstMidR, dstBotL, dstBotC, dstBotR;
    makeAreas(rect, &dstTopL, &dstTopC, &dstTopR, &dstMidL, &dstMidC, &dstMidR, &dstBotL, &dstBotC, &dstBotR);
    
    NSRect srcRects[] = {srcTopL, srcTopC, srcTopR, srcMidL, srcMidC, srcMidR, srcBotL, srcBotC, srcBotR};
    NSRect dstRects[] = {dstTopL, dstTopC, dstTopR, dstMidL, dstMidC, dstMidR, dstBotL, dstBotC, dstBotR};
    NSMutableArray *partImgs = [NSMutableArray arrayWithCapacity:9];
    for (int i=0; i<9; i++)
    {
        NSRect aSrcRect = srcRects[i];
        NSRect aDstRect = dstRects[i];
        
        NSImage *partImg = [[NSImage alloc] initWithSize:aSrcRect.size];
        [partImg lockFocus];
        [img drawAtPoint:NSZeroPoint fromRect:aSrcRect operation:NSCompositeCopy fraction:1.0];
        [partImg setSize:aDstRect.size];
        [partImg unlockFocus];
        [partImgs addObject:partImg];
        [partImg release]; partImg = nil;
    }
    
    return partImgs;
}
@end

