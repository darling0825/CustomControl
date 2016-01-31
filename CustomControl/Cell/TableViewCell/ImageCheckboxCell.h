//
//  ImageAndTextCell.h
//  iTransferLite
//
//  Created by feng ma on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define ImageCheckboxCellStateDidChanged @"CheckboxStateDidChanged"

@interface ImageCheckboxCell : NSTextFieldCell {
    NSImage         *_image;
    NSImageCell     * checkImgCell_;
    BOOL            isHidden_;
    BOOL            selectable_;
    NSInteger       selected_;
}

@property(retain) NSImage *image;
@property(readwrite)BOOL hidden;
@property(readwrite,getter = isSelectable)BOOL selectable;
@property(readwrite)NSInteger selected;

- (BOOL)isSelected;
- (void)setSelected:(NSInteger)selected;
@end
