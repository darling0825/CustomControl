//
//  ImageTextCheckboxCell.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define MARGIN_DISTANCE    6.0

@interface FourImageButtonCell : NSTextFieldCell{
    NSImageCell    *_buttonCell_1;
    NSImageCell    *_buttonCell_2;
    NSImageCell    *_buttonCell_3;
    NSImageCell    *_buttonCell_4;
    SEL             _selector_1;
    SEL             _selector_2;
    SEL             _selector_3;
    SEL             _selector_4;
    
    id              _targetObj;
    
    BOOL            _hidden;
}
@property(retain) NSImage *firstImage;
@property(retain) NSImage *secondImage;
@property(retain) NSImage *thirdImage;
@property(retain) NSImage *fourthImage;
@property(getter = isHidden) BOOL hidden;

- (void)setTarget:(id)anObject;
- (void)setFirstSelector:(SEL)sel;
- (void)setSecondSelector:(SEL)sel;
- (void)setThirdSelector:(SEL)sel;
- (void)setFourthSelector:(SEL)sel;
@end
