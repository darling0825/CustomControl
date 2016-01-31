//
//  WindowCtrl.h
//  CustomControl
//
//  Created by System Administrator on 13-8-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomControl/CustomControl.h"

#import "TabelViewCellTestCtrl.h"
#import "OutlineViewTestCtrl.h"
#import "GridViewTestWindowCtrl.h"
#import "SplashWindowTest.h"

@interface WindowCtrl : NSWindowController{
    IBOutlet ZZButton       *lzButton;
    IBOutlet LZButton       *btnDisable;
    IBOutlet ZZButton       *btnEnable;
    IBOutlet LZProgress     *lzProgress;
    
    IBOutlet CustomView     *_backgroundView;

    IBOutlet LZUrlLabel     *_urlLabel;
    
    IBOutlet NSButton       *_colorTextButton;
    IBOutlet LZButton       *_lzColorButton;
    
    TabelViewCellTestCtrl   *_tableViewCellTest;
    OutlineViewTestCtrl     *_outlineViewTest;
    GridViewTestWindowCtrl  *_gridViewTest;
    SplashWindowTest        *_splashWindowTest;
}

- (IBAction)clickEnable:(id)sender;
- (IBAction)clickDisable:(id)sender;
- (IBAction)showLZAlert:(id)sender;

- (IBAction)clickTableViewCellTest:(id)sender;
- (IBAction)clickOutlineViewTest:(id)sender;
- (IBAction)clickGridViewAction:(id)sender;
- (IBAction)clickSplashWindowAction:(id)sender;
@end
