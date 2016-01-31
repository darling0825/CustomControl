//
//  CheckboxImageTextCell.h
//  CustomControl
//
//  Created by 沧海无际 on 14-6-15.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define CheckboxImageTextCellStateDidChanged         @"OutlineViewCheckboxStateDidChanged"
#define DoubleClickCheckboxImageTextCellDidFinish    @"DoubleClickImageDidFinish"

@interface CheckboxImageTextCell : NSTextFieldCell{
    NSImage             *_image;
    NSButtonCell        *_checkBoxCell;
    
    NSInteger           _isSelected;
    BOOL                _isEnable;
    BOOL                _isHidden;
}
@property(retain) NSImage *image;
@property(copy) NSString *name;
@property(assign,getter = isSelected) NSInteger selected;
@property (assign,setter=setEnable:)BOOL isEnable;
@property (assign,setter=setHidden:)BOOL isHidden;

@end
