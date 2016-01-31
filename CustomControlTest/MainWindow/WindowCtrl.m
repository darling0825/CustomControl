//
//  WindowCtrl.m
//  CustomControl
//
//  Created by System Administrator on 13-8-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "WindowCtrl.h"

@interface WindowCtrl ()

@end

@implementation WindowCtrl

- (id)init
{
    NSLog(@"=== init:%@",self);
    
    self = [super initWithWindowNibName:@"WindowCtrl" owner:self];
    if (self) {
        _tableViewCellTest = nil;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)windowDidLoad
{
    NSLog(@"=== windowDidLoad:%@",self);
}

- (void)awakeFromNib
{
    NSLog(@"=== awakeFromNib:%@",self);
//    [_backgroundView setBackgroundColor:[NSColor purpleColor]];
//    [_backgroundView setBackgroundImage:[NSImage imageNamed:@"mainground"]];
//    [_backgroundView setStretchBackgroundImage:[NSImage imageNamed:@"mainground"]];
    
    
    [_backgroundView setDrawType:DrawType_Vertical];
    //[_backgroundView setStretchable:YES];
    [_backgroundView setEdgeInsets:LZEdgeInsetsMake(100,50,100,50)];
    [_backgroundView setStretchBackgroundImage:[NSImage imageNamed:@"IMG_0203"]];
    
    NSColor *color = [NSColor colorWithCalibratedRed:1.0
                                               green:11/255.0
                                                blue:38/255.0
                                               alpha:1.0];
    
    [btnEnable setButtonTitle:@"Enable" 
                     fontName:@"Helvetica" 
                     fontSize:16
                    fontColor:color
                        align:NSCenterTextAlignment
                    underline:NO
               attributeRange:NSMakeRange(0, 6)];
    
    [btnDisable setButtonTitle:@"Disable"
                      fontName:@"Helvetica" 
                      fontSize:16
                     fontColor:color
                         align:NSCenterTextAlignment
                     underline:NO
                attributeRange:NSMakeRange(0, 7)];

    [btnEnable setButtonStateImageWithNormal:[NSImage imageNamed:@"info_btn_normal"]
                                          up:[NSImage imageNamed:@"info_btn_over"]
                                        down:[NSImage imageNamed:@"info_btn_down"]
                                     disable:[NSImage imageNamed:@"info_btn_dis"]];
    
    [btnDisable setButtonStateImageWithNormal:[NSImage imageNamed:@"info_btn_normal"]
                                           up:[NSImage imageNamed:@"info_btn_over"]
                                         down:[NSImage imageNamed:@"info_btn_down"]
                                      disable:[NSImage imageNamed:@"info_btn_dis"]];
    
    [btnEnable setTitleColorWithNormal:[NSColor blueColor]
                                     up:[NSColor whiteColor]
                                   down:[NSColor greenColor]
                                disable:[NSColor redColor]];
    [btnDisable setTitleColorWithNormal:[NSColor blueColor]
                                   up:[NSColor whiteColor]
                                 down:[NSColor greenColor]
                              disable:[NSColor redColor]];

    [lzButton setTitle:@"This is a LZButton with attribute" font:[NSFont fontWithName:@"Helvetica" size:16]];
    [lzButton setAllowUnderline:YES];
    [lzButton setAlign:NSCenterTextAlignment];
    
    /*
    [lzButton setButtonTitle:@"This is a LZButton with attribute"
                    fontName:@"Helvetica"
                    fontSize:20
                   fontColor:[NSColor redColor]
                       align:NSCenterTextAlignment
                   underline:YES
              attributeRange:NSMakeRange(10, 8)];
     */
    [lzButton setTitleColorWithNormal:[NSColor blueColor]
                                   up:[NSColor whiteColor]
                                 down:[NSColor redColor]
                              disable:[NSColor greenColor]];
    
    
    [lzButton setButtonStateImageWithNormal:[NSImage imageNamed:@"info_btn_normal"]
                                         up:[NSImage imageNamed:@"info_btn_over"]
                                       down:[NSImage imageNamed:@"info_btn_down"]
                                    disable:[NSImage imageNamed:@"info_btn_dis"]];
    //[lzButton setButtonImage:[NSImage imageNamed:@"info_btn_normal"]];
    //[lzButton setImage:[NSImage imageNamed:@"info_btn_normal"]];
    

    //进度条
    [lzProgress setType:TopToBottom];
    [lzProgress setMinValue:0];
    [lzProgress setMaxValue:1000];
    [lzProgress setBackgroundImage:[NSImage imageNamed:@"progress_bgImage_1"]];
    [lzProgress setProgressImage:[NSImage imageNamed:@"progress_pgImage_1"]];
//    [lzProgress setBackgroundImage:[NSImage imageNamed:@"progress_bgImage"]];
//    [lzProgress setProgressImage:[NSImage imageNamed:@"progress_pgImage"]];
    [lzProgress setBackgroundColor:[NSColor colorWithCalibratedRed:1.0 green:110/255.0 blue:38/255.0 alpha:1.0]];
    [lzProgress setProgressColor:[NSColor colorWithCalibratedRed:200/255.0 green:1/255.0 blue:255/255.0 alpha:1.0]];
    
    [self testProgress];
    
    //URL Label
    [_urlLabel setTarget:self];
    [_urlLabel setAction:@selector(clickUrlLabel:)];
    [_urlLabel setStringValue:@"URL Label URL Label URL Label URL Label"];
    [_urlLabel setUrl:[NSURL URLWithString:@"http://www.baidu.com"]];
    [_urlLabel setUnderLineRange:NSMakeRange(2, 5)];
    
    
    //ColorTextButton
    [_colorTextButton setHoverColor:[NSColor redColor]];
    [_colorTextButton setPushColor:[NSColor blueColor]];
    [_colorTextButton setNormalColor:[NSColor greenColor]];
    [_colorTextButton setDisableColor:[NSColor greenColor]];
    //[_colorTextButton setEnabled:NO];
    
    [_lzColorButton setTitleColorWithNormal:[NSColor blackColor]
                                         up:[NSColor blueColor]
                                       down:[NSColor redColor]
                                    disable:[NSColor grayColor]];
}

#pragma mark ----------------------URL Label-----------------------
- (void)clickUrlLabel:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.163.com"]];
}


#pragma mark -----------------------按钮测试------------------------
- (IBAction)clickEnable:(id)sender
{
    [lzButton setEnabled:YES];
}
- (IBAction)clickDisable:(id)sender
{
    [lzButton setEnabled:NO];
}

- (IBAction)showLZAlert:(id)sender
{
    LZAlert *lzAlert = [[LZAlert sharedAlert] alertWithTitle:@"This is a Title."
                                                 messageText:@"This is Message Text."
                                               defaultButton:@"Default"
                                             alternateButton:@"Alternate"
                                                 otherButton:@"Other"
                                                       image:[NSImage imageNamed:@"icon_big_1"]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:12];
    NSMutableParagraphStyle *ps = [[[NSParagraphStyle defaultParagraphStyle]mutableCopy]autorelease];
    [ps setAlignment:NSCenterTextAlignment];
    
    [dic setObject:font forKey:NSFontAttributeName];
    [dic setObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
    [dic setObject:ps forKey:NSParagraphStyleAttributeName];
    
    [lzAlert setButtonTitleAttribute:dic];
    [dic release];
    
    [lzAlert setButtonImage:[NSImage imageNamed:@"info_btn_normal"]];
    [lzAlert setAlertTitle:@"This is a Title."
                  fontName:@"Helvetica"
                  fontSize:14
                 fontColor:[NSColor redColor]
            attributeRange:NSMakeRange(10, 5)
                     align:NSLeftTextAlignment];
    
    [lzAlert setAlertMessageText:@"This is Message Text."
                        fontName:@"Helvetica"
                        fontSize:14
                       fontColor:[NSColor redColor]
                  attributeRange:NSMakeRange(8, 12)
                           align:NSLeftTextAlignment];

    
   [lzAlert showAlertModalForWindow:[self window]
                           delegate:self
                     didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
                        contextInfo:@"contextInfo"];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    switch (returnCode) {
        case NSAlertDefaultReturn:
            NSLog(@"Return Code: NSAlertDefaultReturn");
            break;
        case NSAlertAlternateReturn:
            NSLog(@"Return Code: NSAlertAlternateReturn");
            break;
        case NSAlertOtherReturn:
            NSLog(@"Return Code: NSAlertOtherReturn");
            break;
        default:
            break;
    }
}


#pragma mark ----------------------进度条测试------------------------
- (void)testProgress
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.01
                                             target:self 
                                           selector:@selector(handleTimer:) 
                                           userInfo:nil 
                                            repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    [timer fire];
}

- (void)handleTimer:(NSTimer *)timer
{
    static double i;
    if (i <= 1000) 
    {
        NSLog(@"%f",i);
        [lzProgress setProgressValue:i];
        i = i + 1;
        if ((int)i % 100 == 0) {
            //[self showLZAlert:nil];
            
        }
    }
    else 
    {
        [timer invalidate];
    }
    
}

#pragma mark ---------------------- 功能测试 ------------------------
- (IBAction)clickTableViewCellTest:(id)sender
{
    if (_tableViewCellTest) {
        [_tableViewCellTest release]; _tableViewCellTest = nil;
    }
    _tableViewCellTest = [[TabelViewCellTestCtrl alloc] init];
    [_tableViewCellTest.window makeKeyAndOrderFront:self];
}

- (IBAction)clickOutlineViewTest:(id)sender
{
    if (_outlineViewTest) {
        [_outlineViewTest release]; _outlineViewTest = nil;
    }
    _outlineViewTest = [[OutlineViewTestCtrl alloc] init];
    [_outlineViewTest.window makeKeyAndOrderFront:self];
}


- (IBAction)clickGridViewAction:(id)sender
{
    if (_gridViewTest) {
        [_gridViewTest release]; _gridViewTest = nil;
    }
    _gridViewTest = [[GridViewTestWindowCtrl alloc] init];
    [_gridViewTest.window makeKeyAndOrderFront:self];
}


- (IBAction)clickSplashWindowAction:(id)sender
{
    if (_splashWindowTest) {
        [_splashWindowTest release]; _splashWindowTest = nil;
    }
    _splashWindowTest = [[SplashWindowTest alloc] init];
    //[_splashWindowTest showWindow:self];
    [[_splashWindowTest window] makeKeyAndOrderFront:self];
}
@end
