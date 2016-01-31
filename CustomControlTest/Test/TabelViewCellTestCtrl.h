//
//  TabelViewCellTestCtrl.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-11.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZTableView.h"

@class ImageTextCell;
@class ATImageTextCell;
@class ImageTextCheckboxCell;

@interface TabelViewCellTestCtrl : NSWindowController<NSTableViewDelegate, NSTableViewDataSource>
{
    LZTableView                 *_lzTableView;
    
    ImageTextCell               *_imageTextCell;
    ATImageTextCell             *_ATImageTextCell;
    ImageTextCheckboxCell       *_imageTextCheckboxCell;
    
    NSTextFieldCell             *_sharedGroupTitleCell;
    
    NSMutableArray              *_tableContents;
}

@end
