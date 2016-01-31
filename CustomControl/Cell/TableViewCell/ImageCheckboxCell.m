//
//  ImageAndTextCell.m
//  iTransferLite
//
//  Created by feng ma on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageCheckboxCell.h"

#define Button_WIDTH     14.0


@implementation ImageCheckboxCell
@synthesize image       = _image;
@synthesize hidden      = isHidden_;
@synthesize selectable  = selectable_;
@dynamic selected;

static NSImage * g_CheckButtonSelected = nil;
static NSImage * g_CheckButtonDisable = nil;
static NSImage * g_CheckButtonUnselected = nil;
static NSImage * g_CheckButtonMixed = nil;

- (id)init {
    if (self = [super init]) {
        isHidden_ = NO;
        selectable_ = YES;
    }
    return self;
}

- (void)awakeFromNib
{
    [self setTarget:self];
}

+ (void)initialize
{
    
    NSString *selectAllImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Select_All" ofType:@"png"];
    NSImage *selectAllImage = [[NSImage alloc] initWithContentsOfFile:selectAllImagePath];
    
    NSString *selectPartImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Select_Part" ofType:@"png"];
    NSImage *selectPartImage = [[NSImage alloc] initWithContentsOfFile:selectPartImagePath];
    
    NSString *selectNoneImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Select_None" ofType:@"png"];
    NSImage *selectNoneImage = [[NSImage alloc] initWithContentsOfFile:selectNoneImagePath];
    
    g_CheckButtonSelected = [selectAllImage retain];
    g_CheckButtonDisable = [selectNoneImage retain];
    g_CheckButtonUnselected = [selectNoneImage retain];
    g_CheckButtonMixed = [selectPartImage retain];
    
    [selectAllImage release]; selectAllImage = nil;
    [selectPartImage release]; selectPartImage = nil;
    [selectNoneImage release]; selectNoneImage = nil;
}

- (void)dealloc
{
    [_image         release]; _image          = nil;
    [checkImgCell_  release]; checkImgCell_     = nil;
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone
{
	ImageCheckboxCell *cell = (ImageCheckboxCell*)[super copyWithZone:zone];
    cell->_image = [_image copyWithZone:zone];
    cell->checkImgCell_ = [checkImgCell_ copyWithZone:zone];
	return cell;
}

- (NSRect)checkBtnCellFrame:(NSRect)frame
{
	NSRect imageRect = frame;
    imageRect.origin.x += (frame.size.width - Button_WIDTH)/2;
    imageRect.origin.y += (frame.size.height - Button_WIDTH)/2;
	imageRect.size.width = Button_WIDTH;
    imageRect.size.height = Button_WIDTH;
	return imageRect;
}

- (BOOL)isSelected
{
    return selected_;
}

- (void)setSelected:(NSInteger)selected
{
    selected_ = selected;
    if (checkImgCell_ == nil) {
        checkImgCell_ =  [[NSImageCell alloc] init];
        [checkImgCell_ setControlView:self.controlView];
        [checkImgCell_ setBackgroundStyle:self.backgroundStyle];
        [checkImgCell_ setImageScaling:NSImageScaleAxesIndependently];
    }
    
    _image = g_CheckButtonUnselected;
    
    if (!isHidden_) {
        if (!selectable_) {
            _image = g_CheckButtonDisable;
        }
        else if (selected_ == NSOnState) {
            _image = g_CheckButtonSelected;
        }
        else if (selected_ == NSOffState) {
            _image = g_CheckButtonUnselected;
        }
        else{
            _image = g_CheckButtonMixed;
        }
    }else{
        _image = nil;
    }
    
    [checkImgCell_ setImage:_image];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
	if (_image) {
        NSRect buttonRect = [self checkBtnCellFrame:frame];
        [checkImgCell_ drawInteriorWithFrame:buttonRect inView:controlView];
        
//        [_image drawInRect:buttonRect
//                         fromRect:NSZeroRect
//                        operation:NSCompositeSourceOver
//                         fraction:1.0
//                   respectFlipped:YES
//                            hints:nil];

    }
    else{
        //图片不能显示
        [super drawInteriorWithFrame:frame inView:controlView];
    }
}

//设置选中行高亮颜色时, 文字部分不是蓝色（ NSTableViewSelectionHighlightStyleRegular）
- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    return nil;
}


- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp
{
    NSPoint point = [controlView convertPoint:[theEvent locationInWindow] fromView:nil];
    NSRect checkBtnRect = [self checkBtnCellFrame:cellFrame];
    if (NSPointInRect(point, checkBtnRect)){
        [[NSNotificationCenter defaultCenter] postNotificationName:ImageCheckboxCellStateDidChanged object:self.controlView userInfo:nil];
    }
    return  YES;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{
	NSRect textFrame = [self titleRectForBounds:aRect];
	[super editWithFrame: textFrame inView: controlView editor:textObj delegate:anObject event: theEvent];
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength
{
	NSRect textFrame = [self titleRectForBounds:aRect];
	[super selectWithFrame: textFrame inView: controlView editor:textObj delegate:anObject start:selStart length:selLength];
}


- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView
{
    NSLog(@"hitTestForEvent....");
	NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    // If we have an image, we need to see if the user clicked on the image portion.
	if (g_CheckButtonSelected != nil)
    {
        // This code closely mimics drawWithFrame:inView:
        NSRect checkBtnRect = [self checkBtnCellFrame:cellFrame];
        // If the point is in the image rect, then it is a content hit
		if (NSMouseInRect(point, checkBtnRect, [controlView isFlipped]))
        {
            // We consider this just a content area. It is not trackable, nor it it editable text. If it was, we would or in the additional items.
            // By returning the correct parts, we allow NSTableView to correctly begin an edit when the text portion is clicked on.
			return NSCellHitContentArea;
        }
    }
    // At this point, the cellFrame has been modified to exclude the portion for the image. Let the superclass handle the hit testing at this point.
	return [super hitTestForEvent:event inRect:cellFrame ofView:controlView];
}

@end
