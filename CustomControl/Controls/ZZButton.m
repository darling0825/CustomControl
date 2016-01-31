//
//  ZZButton.m
//  CustomControl
//
//  Created by System Administrator on 13-8-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ZZButton.h"



@implementation ZZButton
@dynamic stretchable;
@dynamic allowUnderline;

+ (Class)cellClass {
    return [ZZButtonCell class];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib
{
    [self addTrackingRect:[self bounds] 
                    owner:self 
                 userData:nil 
             assumeInside:NO];

//    [self setNeedsDisplay];
}

- (BOOL)isStretchable
{
    return [[self cell] isStretchable];
}

- (void)setStretchable:(BOOL)stretchable
{
    [[self cell] setStretchable:stretchable];
}

- (void)setButtonImage:(NSImage *)image
{
    [[self cell] setButtonImage:image];
}

- (void)setButtonStateImageWithNormal:(NSImage *)normal
                                   up:(NSImage *)up
                                 down:(NSImage *)down
                              disable:(NSImage *)disable
{
    [[self cell] setButtonStateImageWithNormal:normal
                                            up:up
                                          down:down
                                       disable:disable];
}

- (void)setTitleColorWithNormal:(NSColor *)normal
                             up:(NSColor *)up
                           down:(NSColor *)down
                        disable:(NSColor *)disable
{
    [[self cell] setTitleColorWithNormal:normal
                                      up:up
                                    down:down
                                 disable:disable];
}

- (void)setButtonTitle:(NSAttributedString *)title
{
    [[self cell] setButtonTitle:title];
}

- (void)setButtonTitle:(NSString *)title
              fontName:(NSString *)name
              fontSize:(NSInteger)size
             fontColor:(NSColor *)color
                 align:(NSTextAlignment)align
             underline:(BOOL)underline
        attributeRange:(NSRange)range
{
    [[self cell] setButtonTitle:title
                       fontName:name
                       fontSize:size
                      fontColor:color
                          align:align
                      underline:underline
                 attributeRange:range];
}

- (void)setTitle:(NSString *)title font:(NSFont *)font
{
    [[self cell] setTitle:title font:font];
}

- (void)setAlign:(NSTextAlignment)align
{
    [[self cell] setAlign:align];
}

- (BOOL)isAllowUnderline
{
    return [[self cell] isAllowUnderline];
}

- (void)setAllowUnderline:(BOOL)underline
{
    [[self cell] setAllowUnderline:underline];
}

#pragma mark -------------------- 鼠标事件 ---------------------
- (void)mouseDown:(NSEvent *)theEvent
{
    if ([[self cell] respondsToSelector:@selector(mouseDown:)]) {
        [[self cell] mouseDown:theEvent];
    }
    
    [super mouseDown:theEvent];
    
    if ([[self cell] respondsToSelector:@selector(mouseUp:)]) {
        [[self cell] mouseUp:theEvent];
    }
}

//- (void)mouseUp:(NSEvent *)theEvent
//{
//    [[self cell] mouseUp:theEvent];
//}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [[self cell] mouseEntered:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [[self cell] mouseExited:theEvent];
}

@end

@interface ZZButtonCell()
- (void)_drawNoStretchableImage:(NSRect)cellFrame;
- (void)_drawButtonImage:(NSRect)cellFrame;
- (void)_drawButtonImageV2:(NSRect)cellFrame;
- (void)_drawButtonTitleColor:(NSRect)cellFrame;
- (void)_setCurrentColor;
- (void)_setCurrentImage;
- (NSImage *)_cutImageFromImage:(NSImage *)srcImg rect:(NSRect)srcRect;
@end

@implementation ZZButtonCell
@synthesize stretchable = _stretchable;
@synthesize allowUnderline = _allowUnderline;

- (id)init
{
    self = [super init];
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
    _color              = nil;
    
    _normalImg          = nil;
    _upImage            = nil;
    _downImage          = nil;
    _disableImage       = nil;
    
    _mouseEnterOrExit   = NO;
    _mouseUpOrDown      = NO;
    _isSetFourImage     = NO;
    
    _stretchable        = YES;
    _allowUnderline     = NO;
}

- (id)copyWithZone:(NSZone *)zone
{
    ZZButtonCell *cell = (ZZButtonCell *)[super copyWithZone:zone];
    if (cell != nil) {
        cell->_image = [_image copyWithZone:zone];
        cell->_color = [_color copyWithZone:zone];
        cell->_title = [_title copyWithZone:zone];
        
        cell->_normalImg = [_normalImg copyWithZone:zone];
        cell->_downImage = [_downImage copyWithZone:zone];
        cell->_upImage = [_upImage copyWithZone:zone];
        cell->_disableImage = [_disableImage copyWithZone:zone];
        
        cell->_normalColor = [_normalColor copyWithZone:zone];
        cell->_downColor = [_downColor copyWithZone:zone];
        cell->_upColor = [_upColor copyWithZone:zone];
        cell->_disableColor = [_disableColor copyWithZone:zone];
        
        cell->_mouseEnterOrExit = _mouseEnterOrExit;
        cell->_mouseUpOrDown = _mouseUpOrDown;
        cell->_isSetFourImage = _isSetFourImage;
        cell->_isSetFourColor = _isSetFourColor;
        cell->_stretchable = _stretchable;
        cell->_allowUnderline = _allowUnderline;
    }
    return cell;
}

- (void)dealloc
{
    [_image release];           _image = nil;
    [_color release];           _color = nil;
    [_title release];           _title = nil;
    
    [_normalImg release];       _normalImg = nil;
    [_upImage release];         _upImage = nil;
    [_downImage release];       _downImage = nil;
    [_disableImage release];    _disableImage = nil;
    
    [_normalColor release];     _normalColor = nil;
    [_upColor release];         _upColor = nil;
    [_downColor release];       _downColor = nil;
    [_disableColor release];    _disableColor = nil;
    [super dealloc];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [self _setCurrentImage];
    [self _setCurrentColor];
    
    if (_image) {
        if (_stretchable) {
            [self _drawButtonImage:cellFrame];
        }
        else{
            [self _drawNoStretchableImage:cellFrame];
        }
    }
    
    if (_title) {
        [self _drawButtonTitleColor:cellFrame];
    }
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
                [_normalImg retain];
                [_image release]; _image = nil;
                _image = _normalImg;
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
    [_normalImg release];
    _normalImg = nil;
    _normalImg = normal;
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

- (void)_drawNoStretchableImage:(NSRect)cellFrame
{
    NSSize imgSize = [_image size];
    NSRect imageRect = NSMakeRect(0, 0, imgSize.width, imgSize.height);
    
    NSRect drawRect = cellFrame;
    
    [_image drawInRect:drawRect
              fromRect:imageRect
             operation:NSCompositeSourceOver
              fraction:1
        respectFlipped:YES
                 hints:nil];
}

- (void)_drawButtonImage:(NSRect)cellFrame
{
    NSSize imgSize = [_image size];
    CGFloat endsWidth = ceilf(imgSize.width/3);
    if (endsWidth >= 20) {
        endsWidth = 20;
    }
    
    NSSize btnSize = cellFrame.size;
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

- (void)_drawButtonImageV2:(NSRect)cellFrame
{
    NSSize imgSize = [_image size];
    CGFloat endsWidth = ceilf(imgSize.width/3);
    if (endsWidth >= 20) {
        endsWidth = 20;
    }
    
    NSImage *startCap = [[self _cutImageFromImage:_image rect:NSMakeRect(0, 0, endsWidth, imgSize.height)] retain];
    NSImage *centerCap = [[self _cutImageFromImage:_image rect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)] retain];
    NSImage *endCap = [[self _cutImageFromImage:_image rect:NSMakeRect(imgSize.width-endsWidth, 0, endsWidth, imgSize.height)] retain];
    
    
    NSSize btnSize = cellFrame.size;
    NSRect drawRect = NSMakeRect(0, 0, btnSize.width, btnSize.height);
    NSImage *newImage = [[NSImage alloc] initWithSize:btnSize];
    
    [newImage lockFocus];
    NSDrawThreePartImage(drawRect, startCap, centerCap, endCap, NO, NSCompositeSourceOver, 1, NO);
    [newImage unlockFocus];
    
    [self setImage:newImage];
    
    [newImage release];
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
        
        [self.controlView setNeedsDisplay:YES];
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
    
    [self.controlView setNeedsDisplay:YES];
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

    [_title release]; _title = nil;
    _title = [attTitle copy];
    
    [attribute release]; attribute = nil;
    [attTitle release]; attTitle = nil;
    
    [self.controlView setNeedsDisplay:YES];
}

- (void)setTitle:(NSString *)title font:(NSFont *)font
{
    if (!title.length || font == nil){
        return;
    }
    
    [self setTitle:title];
    
    NSMutableAttributedString *attTitle = nil;
    if (_title == nil) {
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    }
    else{
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:_title];
    }
    
    [attTitle addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attTitle.string.length)];
    
    [_title release]; _title = nil;
    _title = [attTitle copy];
    [attTitle release]; attTitle = nil;
    
    [self.controlView setNeedsDisplay:YES];
}

- (void)setAlign:(NSTextAlignment)align
{
    NSMutableAttributedString *attTitle = nil;
    if (_title == nil) {
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    }
    else{
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:_title];
    }
    
    NSMutableParagraphStyle *ps = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
    [ps setAlignment:align];
    [attTitle addAttribute:NSParagraphStyleAttributeName
                     value:ps
                     range:NSMakeRange(0, attTitle.string.length)];
    
    [_title release]; _title = nil;
    _title = [attTitle copy];
    [attTitle release]; attTitle = nil;
    
    [self.controlView setNeedsDisplay:YES];
}

- (void)setAllowUnderline:(BOOL)underline
{
    if (!underline) {
        return;
    }
    
    NSMutableAttributedString *attTitle = nil;
    if (_title == nil) {
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    }
    else{
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:_title];
    }

    [attTitle addAttribute:NSUnderlineStyleAttributeName
                     value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                     range:NSMakeRange(0, attTitle.string.length)];
    
    [_title release]; _title = nil;
    _title = [attTitle copy];
    [attTitle release]; attTitle = nil;
    
    [self.controlView setNeedsDisplay:YES];
}

- (void)_drawButtonTitleColor:(NSRect)cellFrame
{
    NSMutableAttributedString *attTitle = nil;
    if (_title == nil) {
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedTitle]];
    }
    else{
        attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:_title];
    }
    
    NSRange r = NSMakeRange(0, attTitle.string.length);
    
    //Color
    if (_color != nil){
        [attTitle addAttribute:NSForegroundColorAttributeName
                         value:_color
                         range:r];
    }
    
    [attTitle fixAttributesInRange:r];
    [super drawTitle:attTitle withFrame:cellFrame inView:self.controlView];
    
    [attTitle release]; attTitle = nil;
}

#pragma mark -------------------- 鼠标事件 ---------------------
- (void)mouseDown:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseUpOrDown = YES;
        
//        if ([self isEnabled]){
//            [NSApp sendAction:self.action to:self.target from:self];
//        }
    }
    [self.controlView setNeedsDisplay:YES];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseUpOrDown = NO;
        
//        if ([self isEnabled]){
//            [NSApp sendAction:self.action to:self.target from:self];
//            [self.target performSelector:self.action withObject:self];
//            [self setAction:self.action];
//        }
    }
    [self.controlView setNeedsDisplay:YES];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseEnterOrExit = YES;
    }

    [super mouseEntered:theEvent];

    [self.controlView setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (_isSetFourImage || _isSetFourColor){
        _mouseEnterOrExit = NO;
        _mouseUpOrDown = NO;
    }

    [super mouseExited:theEvent];

    [self.controlView setNeedsDisplay:YES];
}

//- (void)mouseMoved:(NSEvent *)theEvent
//{
//    NSLog(@"mouseMoved");
//}

@end
