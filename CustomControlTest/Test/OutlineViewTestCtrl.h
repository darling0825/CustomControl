//
//  OutlineViewTestCtrl.h
//  CustomControl
//
//  Created by liww on 14-6-13.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZOutlineView.h"

#define NAME_KEY                     @"Name"
#define CHILDREN_KEY                 @"Children"

@class CheckboxImageTextCell;

@interface OutlineViewTestCtrl : NSWindowController <NSOutlineViewDataSource,NSOutlineViewDelegate>{
    
    LZOutlineView          *_outlineView;
    NSMutableArray         *_dataItems;
    
    NSTreeNode             *_rootTreeNode;
    CheckboxImageTextCell  *_cell;
    
    NSMutableArray         *_iconImages;
}

@end
