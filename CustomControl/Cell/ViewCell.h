//
//  ImageTextCell.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface ViewCell : NSTextFieldCell{
    NSView          *_View;
    BOOL            _hidden;
}
@property(getter = isHidden) BOOL hidden;
- (void)setCellView:(NSView *)cellView;
@end
