//
//  CustomView.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "CustomView.h"

//避免切图时有线条出现
#define DistanceErrorEstimation 1.0

@implementation CustomView
@dynamic backgroundColor;
@dynamic backgroundImage;
@dynamic stretchBackgroundImage;
@synthesize drawType = _drawType;
@synthesize stretchable = _stretchable;
@synthesize edgeInsets = _edgeInsets;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _color = nil;
        _image = nil;
        _stretchImage = nil;
        _stretchable = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code here.
        _color = nil;
        _image = nil;
        _stretchImage = nil;
        _stretchable = NO;
    }
    return self;
}

- (void)dealloc
{
    [_color release]; _color = nil;
    [_image release]; _image = nil;
    [_stretchImage release]; _stretchImage = nil;
    [super dealloc];
}

//- (BOOL)isFlipped
//{
//    return NO;
//}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    [backgroundColor retain];
    [_color release]; _color = nil;
    _color = backgroundColor;
    [self setNeedsDisplay:YES];
}

- (void)setBackgroundImage:(NSImage *)backgroundImage
{
    [backgroundImage retain];
    [_image release]; _image = nil;
    _image = backgroundImage;
    [self setNeedsDisplay:YES];
}

- (void)setStretchBackgroundImage:(NSImage *)stretchBackgroundImage
{
    [stretchBackgroundImage retain];
    [_stretchImage release]; _stretchImage = nil;
    _stretchImage = stretchBackgroundImage;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (_stretchImage) {
        if (_drawType == DrawType_Horizontal){
            [self drawHorizontalStretchImageV2];
        }
        else if (_drawType == DrawType_Vertical){
            [self drawVerticalStretchImageV2];
        }
        else if (_drawType == DrawType_NinePart){
            [self drawNinePartStretchImageV2];
        }
        else {
            [self drawNinePartStretchImage];
        }
    }
    else if (_image) {
        [self drawImage];
    }
    else if (_color) {
        [self drawColor];
    }
}

- (void)drawColor
{
    [_color set];
    [NSBezierPath fillRect:self.bounds];
}

- (void)drawImage
{
    NSSize imgSize = [_image size];
    NSRect imageRect = NSMakeRect(0, 0, imgSize.width, imgSize.height);
    
    NSRect drawRect = self.bounds;
    if (!_stretchable) {
        //居中显示
        drawRect = NSMakeRect(fabs((drawRect.size.width - imgSize.width)/2),
                              fabs((drawRect.size.height - imgSize.height)/2),
                              imgSize.width,
                              imgSize.height);
    }
    
    [_image drawInRect:drawRect
              fromRect:imageRect
             operation:NSCompositeSourceOver
              fraction:1
        respectFlipped:YES
                 hints:nil];
    
}

- (void)drawHorizontalStretchImage
{
    NSSize imgSize = [_stretchImage size];
    
    if (EqualLZEdgeInsets(_edgeInsets, LZZeroEdgeInsets)) {
        _edgeInsets = LZEdgeInsetsMake(0,imgSize.width/3,0,imgSize.width/3);
    }
    
    NSImage *start = [self cutImageFromImage:_stretchImage rect:NSMakeRect(0, 0, _edgeInsets.left, imgSize.height)];
    NSImage *center = [self cutImageFromImage:_stretchImage rect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)];
    NSImage *end = [self cutImageFromImage:_stretchImage rect:NSMakeRect(imgSize.width-_edgeInsets.right, 0, _edgeInsets.right, imgSize.height)];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    NSRect drawRect = NSMakeRect(0, 0, width, height);
    
    //从左往右
    NSDrawThreePartImage(drawRect, start, center, end, NO, NSCompositeSourceOver, 1, NO);
}

- (void)drawHorizontalStretchImageV2
{
    NSSize imgSize = [_stretchImage size];
    NSSize size = self.frame.size;
    
    if (EqualLZEdgeInsets(_edgeInsets, LZZeroEdgeInsets)) {
        _edgeInsets = LZEdgeInsetsMake(0,imgSize.width/3,0,imgSize.width/3);
    }
    
    CGFloat W = size.width / imgSize.width;
    if (!_stretchable) {
        W = 1.0f;
    }
    
    LZEdgeInsets edgeInsets = LZEdgeInsetsMake(0,
                                               _edgeInsets.left * W,
                                               0,
                                               _edgeInsets.right * W);
    
    [_stretchImage drawInRect:NSMakeRect(0, 0, edgeInsets.left, size.height)
                     fromRect:NSMakeRect(0, 0, _edgeInsets.left, imgSize.height)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    
    [_stretchImage drawInRect:NSMakeRect(edgeInsets.left, 0, size.width-edgeInsets.left-edgeInsets.right, size.height)
                     fromRect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)
                            //NSMakeRect(_edgeInsets.left, 0, imgSize.width-_edgeInsets.left-_edgeInsets.right, imgSize.height)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    
    [_stretchImage drawInRect:NSMakeRect(size.width-edgeInsets.right, 0, edgeInsets.right, size.height)
                     fromRect:NSMakeRect(imgSize.width-_edgeInsets.right, 0, _edgeInsets.right, imgSize.height)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
}


- (void)drawVerticalStretchImage
{
    NSSize imgSize = [_stretchImage size];
    
    if (EqualLZEdgeInsets(_edgeInsets, LZZeroEdgeInsets)) {
        _edgeInsets = LZEdgeInsetsMake(imgSize.height/3,0,imgSize.height/3,0);
    }
    
    NSImage *start = [self cutImageFromImage:_stretchImage rect:NSMakeRect(0, imgSize.height-_edgeInsets.top, imgSize.width, _edgeInsets.top)];
    NSImage *center = [self cutImageFromImage:_stretchImage rect:NSMakeRect(0, imgSize.height/2, imgSize.width, 1)];
    NSImage *end = [self cutImageFromImage:_stretchImage rect:NSMakeRect(0, 0, imgSize.width, _edgeInsets.bottom)];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    NSRect drawRect = NSMakeRect(0, 0, width, height);
    
    //从上往下
    NSDrawThreePartImage(drawRect, start, center, end, YES, NSCompositeSourceOver, 1, NO);
}

- (void)drawVerticalStretchImageV2
{
    NSSize imgSize = [_stretchImage size];
    NSSize size = self.frame.size;
    
    if (EqualLZEdgeInsets(_edgeInsets, LZZeroEdgeInsets)) {
        _edgeInsets = LZEdgeInsetsMake(imgSize.height/3,0,imgSize.height/3,0);
    }
    
    CGFloat H = size.height / imgSize.height;
    if (!_stretchable) {
        H = 1.0f;
    }
    
    LZEdgeInsets edgeInsets = LZEdgeInsetsMake(_edgeInsets.top * H,
                                               0,
                                               _edgeInsets.bottom * H,
                                               0
                                               );
    
    [_stretchImage drawInRect:NSMakeRect(0, size.height-edgeInsets.top, size.width, edgeInsets.top)
                     fromRect:NSMakeRect(0, imgSize.height-_edgeInsets.top, imgSize.width, _edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    
    [_stretchImage drawInRect:NSMakeRect(0, edgeInsets.bottom, size.width, size.height-edgeInsets.bottom-edgeInsets.top)
                     fromRect:NSMakeRect(0, imgSize.height/2, imgSize.width, 1)
                            //NSMakeRect(0, _edgeInsets.bottom, imgSize.width, imgSize.height-_edgeInsets.bottom-_edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    
    [_stretchImage drawInRect:NSMakeRect(0, 0, size.width, edgeInsets.bottom)
                     fromRect:NSMakeRect(0, 0, imgSize.width, _edgeInsets.bottom)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
}

- (void)drawNinePartStretchImage
{
    NSSize imgSize = [_stretchImage size];
    if (EqualLZEdgeInsets(_edgeInsets, LZZeroEdgeInsets)) {
        _edgeInsets = LZEdgeInsetsMake(imgSize.height/3,imgSize.width/3,imgSize.height/3,imgSize.width/3);
    }
    
    NSRect drawRect = NSMakeRect(0, 0, self.bounds.size.width, self.bounds.size.height);
    //NSArray *ninePart = [[self ninePartWithImage:_stretchImage position:_edgeInsets] retain];
    NSArray *ninePart = [[self ninePartWithImage:_stretchImage size:drawRect.size edgeInsets:_edgeInsets] retain];
    
    //从左往右,从上往下
    /*
    topLeftCorner     topEdgeFill       topRightCorner
    leftEdgeFill      centerFill        rightEdgeFill
    bottomLeftCorner  bottomEdgeFill    bottomRightCorner
     */
    NSDrawNinePartImage(drawRect,
                        [ninePart objectAtIndex:0],
                        [ninePart objectAtIndex:1],
                        [ninePart objectAtIndex:2],
                        [ninePart objectAtIndex:3],
                        [ninePart objectAtIndex:4],
                        [ninePart objectAtIndex:5],
                        [ninePart objectAtIndex:6],
                        [ninePart objectAtIndex:7],
                        [ninePart objectAtIndex:8],
                        NSCompositeSourceOver, 1.0, NO);
    
    [ninePart release]; ninePart = nil;
}

- (void)drawNinePartStretchImageV2
{
    NSSize imgSize = [_stretchImage size];
    NSSize size = self.frame.size;
    
    if (EqualLZEdgeInsets(_edgeInsets, LZZeroEdgeInsets)) {
        _edgeInsets = LZEdgeInsetsMake(imgSize.height/3,imgSize.width/3,imgSize.height/3,imgSize.width/3);
    }
    
    CGFloat W = size.width / imgSize.width;
    CGFloat H = size.height / imgSize.height;
    
    if (!_stretchable) {
        W = 1.0f;
        H = 1.0f;
    }
    
    LZEdgeInsets edgeInsets = LZEdgeInsetsMake(_edgeInsets.top * H,
                                               _edgeInsets.left * W,
                                               _edgeInsets.bottom * H,
                                               _edgeInsets.right * W);
    
    //图片切割线位置
    /*
     ------------------------
     |  11  |   12  |   13  |
     ------------------------
     |  21  |   22  |   23  |
     ------------------------
     |  31  |   32  |   33  |
     ------------------------
     */
    
    //11
    [_stretchImage drawInRect:NSMakeRect(0, size.height-edgeInsets.top, edgeInsets.left, edgeInsets.top)
                     fromRect:NSMakeRect(0, imgSize.height-_edgeInsets.top, _edgeInsets.left, _edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    //12
    [_stretchImage drawInRect:NSMakeRect(edgeInsets.left-DistanceErrorEstimation, size.height-edgeInsets.top, size.width - edgeInsets.left - edgeInsets.right + 2*DistanceErrorEstimation, edgeInsets.top)
                     fromRect:NSMakeRect(_edgeInsets.left, imgSize.height-_edgeInsets.top, imgSize.width - _edgeInsets.left - _edgeInsets.right, _edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    //13
    [_stretchImage drawInRect:NSMakeRect(size.width - edgeInsets.right, size.height-edgeInsets.top, edgeInsets.right, edgeInsets.top)
                     fromRect:NSMakeRect(imgSize.width - _edgeInsets.right, imgSize.height-_edgeInsets.top, _edgeInsets.right, _edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    
    //21
    [_stretchImage drawInRect:NSMakeRect(0, edgeInsets.bottom-DistanceErrorEstimation, edgeInsets.left, size.height-edgeInsets.bottom - edgeInsets.top + 2*DistanceErrorEstimation)
                     fromRect:NSMakeRect(0, _edgeInsets.bottom, _edgeInsets.left, imgSize.height-_edgeInsets.bottom - _edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    //22
    [_stretchImage drawInRect:NSMakeRect(edgeInsets.left-DistanceErrorEstimation, edgeInsets.bottom-DistanceErrorEstimation, size.width - edgeInsets.left - edgeInsets.right + 2*DistanceErrorEstimation, size.height-edgeInsets.bottom - edgeInsets.top + 2*DistanceErrorEstimation)
                     fromRect:NSMakeRect(_edgeInsets.left, _edgeInsets.bottom, imgSize.width - _edgeInsets.left - _edgeInsets.right, imgSize.height-_edgeInsets.bottom - _edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    //23
    [_stretchImage drawInRect:NSMakeRect(size.width - edgeInsets.right, edgeInsets.bottom-DistanceErrorEstimation, edgeInsets.right, size.height-edgeInsets.bottom - edgeInsets.top + 2*DistanceErrorEstimation)
                     fromRect:NSMakeRect(imgSize.width - _edgeInsets.right, _edgeInsets.bottom, _edgeInsets.right, imgSize.height-_edgeInsets.bottom - _edgeInsets.top)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    
    //31
    [_stretchImage drawInRect:NSMakeRect(0, 0, edgeInsets.left, edgeInsets.bottom)
                     fromRect:NSMakeRect(0, 0, _edgeInsets.left, _edgeInsets.bottom)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    //32
    [_stretchImage drawInRect:NSMakeRect(edgeInsets.left-DistanceErrorEstimation, 0, size.width - edgeInsets.left - edgeInsets.right + 2*DistanceErrorEstimation, edgeInsets.bottom)
                     fromRect:NSMakeRect(_edgeInsets.left, 0, imgSize.width - _edgeInsets.left - _edgeInsets.right, _edgeInsets.bottom)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
    //33
    [_stretchImage drawInRect:NSMakeRect(size.width - edgeInsets.right, 0, edgeInsets.right, edgeInsets.bottom)
                     fromRect:NSMakeRect(imgSize.width - _edgeInsets.right, 0, _edgeInsets.right, _edgeInsets.bottom)
                    operation:NSCompositeSourceOver
                     fraction:1.0f
               respectFlipped:NO
                        hints:nil];
}

- (NSImage *)cutImageFromImage:(NSImage *)srcImg rect:(NSRect)srcRect
{
    NSImage *dstImg = [[NSImage alloc] initWithSize:srcRect.size];
    NSRect dstRect = (NSRect){NSZeroPoint,srcRect.size};
    
    if (NSWidth(srcRect)!=0 && NSHeight(srcRect)!=0) {
        [dstImg lockFocus];
        
//        [srcImg drawInRect:dstRect
//                  fromRect:srcRect
//                 operation:NSCompositeCopy
//                  fraction:1.0f
//            respectFlipped:YES
//                     hints:nil];
        [srcImg drawAtPoint:NSZeroPoint
                   fromRect:srcRect
                  operation:NSCompositeCopy
                   fraction:1.0];
        [dstImg setSize:dstRect.size];
        
        [dstImg unlockFocus];
    }
    
    return [dstImg autorelease];
}

- (NSArray *)ninePartWithImage:(NSImage*)img position:(LZEdgeInsets)edgeInsets

{
    if (nil == img) {
        return nil;
    }
    
    NSMutableArray *ninePartImages = [[NSMutableArray alloc] initWithCapacity:9];
    
    NSSize imgSize = [_stretchImage size];
    NSRect rect;
    NSImage *image = nil;
    
    //11
    rect = NSMakeRect(0, imgSize.height-edgeInsets.top, edgeInsets.left, edgeInsets.top);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //12
    rect = NSMakeRect(edgeInsets.left, imgSize.height-edgeInsets.top, imgSize.width - edgeInsets.left - edgeInsets.right, edgeInsets.top);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //13
    rect = NSMakeRect(imgSize.width - edgeInsets.right, imgSize.height-edgeInsets.top, edgeInsets.right, edgeInsets.top);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //21
    rect = NSMakeRect(0, edgeInsets.bottom, edgeInsets.left, imgSize.height-edgeInsets.bottom - edgeInsets.top);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //22
    rect = NSMakeRect(edgeInsets.left, edgeInsets.bottom, imgSize.width - edgeInsets.left - edgeInsets.right, imgSize.height-edgeInsets.bottom - edgeInsets.top);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //23
    rect = NSMakeRect(imgSize.width - edgeInsets.right, edgeInsets.bottom, edgeInsets.right, imgSize.height-edgeInsets.bottom - edgeInsets.top);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //31
    rect = NSMakeRect(0, 0, edgeInsets.left, edgeInsets.bottom);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //32
    rect = NSMakeRect(edgeInsets.left, 0, imgSize.width - edgeInsets.left - edgeInsets.right, edgeInsets.bottom);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    //33
    rect = NSMakeRect(imgSize.width - edgeInsets.right, 0, edgeInsets.right, edgeInsets.bottom);
    image = [[self cutImageFromImage:img rect:rect] retain];
    [ninePartImages addObject:image];
    [image release]; image = nil;
    
    return [ninePartImages autorelease];
}

- (NSArray *)ninePartWithImage:(NSImage*)img size:(NSSize)size edgeInsets:(LZEdgeInsets)insets
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
//        aDstRect.origin = NSZeroPoint;
        
        NSImage *partImg = [[NSImage alloc] initWithSize:aSrcRect.size];
        if (NSWidth(aSrcRect)!=0 && NSHeight(aSrcRect)!=0) {
            [partImg lockFocus];
//            [img drawInRect:aDstRect
//                   fromRect:aSrcRect
//                  operation:NSCompositeCopy
//                   fraction:1.0
//             respectFlipped:YES
//                      hints:nil];
            
            [img drawAtPoint:NSZeroPoint
                    fromRect:aSrcRect
                   operation:NSCompositeCopy
                    fraction:1.0];
            
            [partImg setSize:aDstRect.size];
            [partImg unlockFocus];
        }
        
        [partImgs addObject:partImg];
        [partImg release]; partImg = nil;
    }
    
    return partImgs;
}

@end
