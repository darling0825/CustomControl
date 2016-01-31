//
//  LZButton.m
//  CustomControl
//
//  Created by System Administrator on 13-8-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LZButton.h"

@interface LZButton()
- (void)_setButtonTitle;
- (void)_drawNoStretchableImage;
- (void)_drawButtonImage;
- (void)_drawButtonImageV2;
- (void)_setCurrentImage;
- (NSImage *)_cutImageFromImage:(NSImage *)srcImg rect:(NSRect)srcRect;
@end

@implementation LZButton
@synthesize stretchable = _stretchable;

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        [self config];
//    }
//    return self;
//}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config
{
    _title              = nil;
    _image              = nil;
    _normalImage        = nil;
    _upImage            = nil;
    _downImage          = nil;
    _disableImage       = nil;
    
    _mouseEnterOrExit   = NO;
    _mouseUpOrDown      = NO;
    _isSetFourImage     = NO;
    
    _stretchable        = YES;
}

- (void)awakeFromNib
{
    //[[self window] setAcceptsMouseMovedEvents:YES];
    [self addTrackingRect:[self bounds] 
                    owner:self 
                 userData:nil 
             assumeInside:NO];
    
//    [self _setCurrentImage];
//    [self _setCurrentColor];
//    [self setNeedsDisplay];
}

- (void)dealloc
{
    [_title release];           _title = nil;

    [_normalImage release];     _normalImage = nil;
    [_upImage release];         _upImage = nil;
    [_downImage release];       _downImage = nil;
    [_disableImage release];    _disableImage = nil;
    
    [_normalColor release];     _normalColor = nil;
    [_upColor release];         _upColor = nil;
    [_downColor release];       _downColor = nil;
    [_disableColor release];    _disableColor = nil;
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self _setCurrentImage];
    [self _setCurrentColor];
    
    if (_image) {
        if (_stretchable) {
            [self _drawButtonImageV2];
        }
        else{
            [self _drawNoStretchableImage];
        }
    }
    
    if (_title) {
        [self _setButtonTitle];
    }
    
    if (_color) {
        [self _drawButtonTitleColor];
    }
    
    [super drawRect:dirtyRect];
}

- (void)_setCurrentImage
{
    if (_isSetFourImage) {
        if (self.isEnabled){
            if (_mouseEnterOrExit && _mouseUpOrDown && _downImage) {
                [_downImage retain];
                [_image release]; _image = nil;
                _image = _downImage;
            }
            else if (_mouseEnterOrExit && !_mouseUpOrDown && _upImage) {
                [_upImage retain];
                [_image release]; _image = nil;
                _image = _upImage;
            }
            else {
                [_normalImage retain];
                [_image release]; _image = nil;
                _image = _normalImage;
            }
        }
        else{
            if (_disableImage) {
                [_disableImage retain];
                [_image release]; _image = nil;
                _image = _disableImage;
            }
        }
    }
    else{
        
    }
}

- (void)_setCurrentColor
{
    if (self.isEnabled){
        if (_mouseEnterOrExit && _mouseUpOrDown && _downColor) {
            [_downColor retain];
            [_color release]; _color = nil;
            _color = _downColor;
        }
        else if (_mouseEnterOrExit && !_mouseUpOrDown && _upColor) {
            [_upColor retain];
            [_color release]; _color = nil;
            _color = _upColor;
        }
        else {
            [_normalColor retain];
            [_color release]; _color = nil;
            _color = _normalColor;
        }
    }
    else{
        if (_disableColor) {
            [_disableColor retain];
            [_color release]; _color = nil;
            _color = _disableColor;
        }
    }
}

#pragma mark -------------------- 设置按钮图片------------------
- (void)setButtonImage:(NSImage *)img
{
    _isSetFourImage = NO;
    
    if (img) {
        [img retain];
        [_image release];
        _image = img;
        
        [self setBordered:NO];
        [self setNeedsDisplay];
    }
}

- (void)setButtonStateImageWithNormal:(NSImage *)normal
                                   up:(NSImage *)up
                                 down:(NSImage *)down
                              disable:(NSImage *)disable
{
    _isSetFourImage = YES;
    [self setBordered:NO];
    
    //if (normal){
        [normal retain];
        [_normalImage release]; 
        _normalImage = nil;
        _normalImage = normal;
    //}
    
    //if (up) {
        [up retain];
        [_upImage release];
        _upImage = nil;
        _upImage = up;
    //}
    
    //if (down) {
        [down retain];
        [_downImage release];
        _downImage = nil;
        _downImage = down;
    //}
    
    //if (disable){
        [disable retain];
        [_disableImage release];
        _disableImage = nil;
        _disableImage = disable;
    //}
}

- (void)_drawNoStretchableImage
{
    NSSize imgSize = [_image size];
    NSRect imageRect = NSMakeRect(0, 0, imgSize.width, imgSize.height);
    
    NSRect drawRect = self.bounds;

    [_image drawInRect:drawRect
              fromRect:imageRect
             operation:NSCompositeSourceOver
              fraction:1
        respectFlipped:YES
                 hints:nil];
}

- (void)_drawButtonImage
{
    NSSize imgSize = [_image size];
    CGFloat endsWidth = ceilf(imgSize.width/3);
    if (endsWidth >= 20) {
        endsWidth = 20;
    }
    
    NSSize btnSize = self.frame.size;
    CGFloat drawEndsWidth = ceilf(btnSize.width/3);
    if (drawEndsWidth >= 20) {
        drawEndsWidth = 20;
    }
    
    //NSImage *newImage = [[NSImage alloc] initWithSize:btnSize];
    
    //[newImage lockFocus];
    
    [_image drawInRect:NSMakeRect(0, 0, drawEndsWidth, btnSize.height)
              fromRect:NSMakeRect(0, 0, endsWidth, imgSize.height)
             operation:NSCompositeSourceOver 
              fraction:1];
    
    [_image drawInRect:NSMakeRect(drawEndsWidth, 0, btnSize.width-drawEndsWidth*2, btnSize.height)
              fromRect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)
             operation:NSCompositeSourceOver        
              fraction:1];
    
    [_image drawInRect:NSMakeRect(btnSize.width-drawEndsWidth, 0, drawEndsWidth, btnSize.height)
              fromRect:NSMakeRect(imgSize.width-endsWidth, 0, endsWidth, imgSize.height)
             operation:NSCompositeSourceOver 
              fraction:1];
    
    //[newImage unlockFocus];
    //[self setImage:newImage];
    
    
    //2
//    [newImage lockFocus];
//    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0, 0.0, [newImage size].width, [newImage size].height)];
//    [newImage unlockFocus];
//    
//    NSImage *image = [[NSImage alloc] initWithSize:[bitmapRep size]];
//	[image addRepresentation:bitmapRep];
//    
//    [self setImage:image];
//    [image release];
//    [bitmapRep release];
    
    //3
//    NSImage *img = [NSImage imageNamed:@"info_btn_dis"];
//    [self setImage:img];
    
     
    //[newImage release];
}

- (void)_drawButtonImageV2
{
    NSSize imgSize = [_image size];
    CGFloat endsWidth = ceilf(imgSize.width/3);
    if (endsWidth >= 20) {
        endsWidth = 20;
    }
    
    NSImage *startCap = [[self _cutImageFromImage:_image rect:NSMakeRect(0, 0, endsWidth, imgSize.height)] retain];
    NSImage *centerCap = [[self _cutImageFromImage:_image rect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)] retain];
    NSImage *endCap = [[self _cutImageFromImage:_image rect:NSMakeRect(imgSize.width-endsWidth, 0, endsWidth, imgSize.height)] retain];
    
    
    NSSize btnSize = self.frame.size;
    NSRect drawRect = NSMakeRect(0, 0, btnSize.width, btnSize.height);
    
    //NSImage *newImage = [[NSImage alloc] initWithSize:btnSize];
    //[newImage lockFocus];
    NSDrawThreePartImage(drawRect, startCap, centerCap, endCap, NO, NSCompositeSourceOver, 1, NO);
    //[newImage unlockFocus];
    //[self setImage:newImage];
    //[newImage release];
    
    [startCap release];
    [centerCap release];
    [endCap release];
}

- (NSImage *)_cutImageFromImage:(NSImage *)srcImg rect:(NSRect)srcRect
{
    NSImage *dstImg = [[NSImage alloc]initWithSize:srcRect.size];
    NSRect dstRect = NSZeroRect; dstRect.size = srcRect.size;
    
    [dstImg lockFocus];
    [srcImg drawInRect:dstRect
              fromRect:srcRect 
             operation:NSCompositeSourceOver 
              fraction:1.0f];
    
    [dstImg unlockFocus];
    
    return [dstImg autorelease];
}

#pragma mark -------------------- 设置文字 ---------------------
- (void)setButtonTitle:(NSAttributedString *)aString
{
    if (aString) {
        [aString retain];
        [_title release]; _title = nil;
        _title = aString;
    }
}
- (void)setTitleColorWithNormal:(NSColor *)normal
                             up:(NSColor *)up
                           down:(NSColor *)down
                        disable:(NSColor *)disable
{
    _isSetFourColor = YES;
    [self setBordered:NO];
    
    if (normal){
        [normal retain];
        [_normalColor release];
        _normalColor = nil;
        _normalColor = normal;
    }
    
    if (up) {
        [up retain];
        [_upColor release];
        _upColor = nil;
        _upColor = up;
    }
    
    if (down) {
        [down retain];
        [_downColor release];
        _downColor = nil;
        _downColor = down;
    }
    
    if (disable){
        [disable retain];
        [_disableColor release];
        _disableColor = nil;
        _disableColor = disable;
    }
}

- (void)setButtonTitle:(NSString *)title
              fontName:(NSString *)name
              fontSize:(NSInteger)size
             fontColor:(NSColor *)color
                 align:(NSTextAlignment)align
             underline:(BOOL)underline
        attributeRange:(NSRange)range
{
    //Title
    if (!title.length){
        [self setTitle:@""];
        return;
    }
    else{
        [self setTitle:title];
    }
    
    NSMutableDictionary *attribute = [[NSMutableDictionary alloc] init];
    
    //Align
    [self setAlignment:align];
    NSMutableParagraphStyle *ps = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy]autorelease];
    [ps setAlignment:align];
    [attribute setObject:ps forKey:NSParagraphStyleAttributeName];
    
    //Font name, size
    NSString *fontName = @"Helvetica";
    if (name != nil && ![name isEqualToString:@""]){
        fontName = name;
    }
    
    NSFont *font =[NSFont fontWithName:fontName size:size];
    [attribute setObject:font forKey:NSFontAttributeName];
    
    //Color
    if (color != nil){
        [attribute setObject:color forKey:NSForegroundColorAttributeName];
    }
    
    //下划线
    if (underline) {
        [attribute setObject:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                      forKey:NSUnderlineStyleAttributeName];
    }
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]initWithAttributedString:[self attributedTitle]];
    
    
    //链接
    //    [attTitle addAttribute:NSLinkAttributeName
    //                     value:[NSURL URLWithString:@"www.baidu.com"]
    //                     range:range];
    
    //Attribute title
    NSRange r = range;
    if (r.length == 0) {
        r = NSMakeRange(0, attTitle.string.length);
    }
    [attTitle addAttributes:attribute range:r];
    [attTitle fixAttributesInRange:NSMakeRange(0, attTitle.string.length)];
    
    [self setAttributedTitle:attTitle];
    
    [attribute release]; attribute = nil;
    [attTitle release]; attTitle = nil;
}

- (void)_setButtonTitle
{
    [self setAttributedTitle:_title];
}

- (void)_drawButtonTitleColor
{
    NSMutableDictionary *attribute = [[NSMutableDictionary alloc] init];
    
    //Color
    if (_color != nil){
        [attribute setObject:_color forKey:NSForegroundColorAttributeName];
    }
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]initWithAttributedString:[self attributedTitle]];
    [attTitle addAttributes:attribute range:NSMakeRange(0, attTitle.string.length)];
    
    [self setAttributedTitle:attTitle];
    
    [attribute release]; attribute = nil;
    [attTitle release]; attTitle = nil;
}

#pragma mark -------------------- 鼠标事件 ---------------------
- (void)mouseDown:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseUpOrDown = YES;
        
//        if ([self isEnabled]) 
//        {
//            [NSApp sendAction:self.action to:self.target from:self];
//        }
    }
    else 
    {
        [super mouseDown:theEvent];
    }
    
    [self setNeedsDisplay];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseUpOrDown = NO;
        
        if ([self isEnabled]) {
            [NSApp sendAction:self.action to:self.target from:self];
            //[self.target performSelector:self.action withObject:self];
            //[self setAction:self.action];
        }

    }
    else {
        [super mouseUp:theEvent];
    }
    
    [self setNeedsDisplay];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseEnterOrExit = YES;
    }
    else {
        [super mouseEntered:theEvent];
    }
    
    [self setNeedsDisplay];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseEnterOrExit = NO;
        _mouseUpOrDown = NO;
    }
    else {
        [super mouseExited:theEvent];
    }
    
    [self setNeedsDisplay];
}

//- (void)mouseMoved:(NSEvent *)theEvent
//{
//    NSLog(@"mouseMoved");
//}

@end
