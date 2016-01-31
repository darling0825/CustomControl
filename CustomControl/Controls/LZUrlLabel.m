//
//  LZUrlLabel.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-10.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZUrlLabel.h"

@implementation LZUrlLabel
@synthesize url = _url;
@synthesize color = _color;
@synthesize underLine = _isUnderLine;
@synthesize underLineRange = _underLineRange;
@synthesize align = _align;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _align = NSLeftTextAlignment;
        _isUnderLine = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // Initialization code here.
        _align = NSLeftTextAlignment;
        _isUnderLine = YES;
    }
    return self;
}

- (void)dealloc
{
    [_url release]; _url = nil;
    [super dealloc];
}

- (void)setStringValue:(NSString *)aString
{
    [super setStringValue:aString];
    //[self sizeToFit];
    [self drawAttribute];
}


- (void)drawAttribute
{
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]initWithAttributedString:[self attributedStringValue]];
    
    NSMutableDictionary *attribute = [[NSMutableDictionary alloc] init];
    
    //Color
    [attribute setObject:_color?_color:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
    
    if (_isUnderLine) {
        //下划线
        [attribute setObject:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                      forKey:NSUnderlineStyleAttributeName];
    }
    
    //Align
    NSMutableParagraphStyle *ps = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy]autorelease];
    [ps setAlignment:_align];
    [attribute setObject:ps forKey:NSParagraphStyleAttributeName];
    
    //Attribute title
    NSRange range = _underLineRange;
    if (_underLineRange.length == 0) {
        range = NSMakeRange(0, attTitle.string.length);
    }
    [attTitle addAttributes:attribute range:range];
    
    [self setAttributedStringValue:attTitle];
    
    [attribute release]; attribute = nil;
    [attTitle release]; attTitle = nil;
}

- (void)setUrl:(NSURL *)url
{
    [url retain];
    [_url release]; _url = nil;
    _url = url;
    
    [self drawAttribute];
}

//- (void)setTarget:(id)anObject
//{
//    [anObject retain];
//    [_target release]; _target = nil;
//    _target = anObject;
//}
//
//- (void)setAction:(SEL)aSelector
//{
//    _action = aSelector;
//}

- (void)mouseUp:(NSEvent *)theEvent
{
//    NSPoint curPoint = [theEvent locationInWindow];
//    curPoint = [self convertPoint:curPoint fromView:nil];
//    if (!NSPointInRect(curPoint, [self bounds])){
//        return;
//    }
    
    if (self.target && self.action) {
        [self sendAction:self.action to:self.target];
    }
    else if (_url){
        [[NSWorkspace sharedWorkspace] openURL:_url];
    }
}

- (void)resetCursorRects
{
    [super resetCursorRects];
    
    if ((self.target && self.action) || _url) {
        [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
    }
    else {
        [self addCursorRect:[self bounds] cursor:[NSCursor arrowCursor]];
    }
}

@end
