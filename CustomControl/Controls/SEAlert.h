//
//  SEAlert.h
//  SEAlert
//
//  Created by System Administrator on 13-8-21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZButton.h"

@interface SEAlert : NSWindowController{
    IBOutlet NSImageView    *alertImageView;
    IBOutlet NSTextField    *alertTitle;
    
    IBOutlet LZButton       *defaultButton;
    IBOutlet LZButton       *alternateButton;
    IBOutlet LZButton       *otherButton;
    
    id                      _delegate;
    SEL                     _selector;
}

//-----------------------------------------
//    alloc and init
//-----------------------------------------
- (id)initWithTitle:(NSString *)strTitle
      defaultButton:(NSString *)strDefaultBtn
    alternateButton:(NSString *)strAlternateBtn
        otherButton:(NSString *)strOtherBtn
              image:(NSImage *)image;


//-----------------------------------------
//    Class Method
//-----------------------------------------
+ (id)alertWithTitle:(NSString *)strTitle
       defaultButton:(NSString *)strDefaultBtn
     alternateButton:(NSString *)strAlternateBtn
         otherButton:(NSString *)strOtherBtn
               image:(NSImage *)image;

- (void)showAlertModalForWindow:(NSWindow *)docWindow
                 didEndSelector:(SEL)didEndSelector
                       delegate:(id)delegate;

//-----------------------------------------
//    Button Attribute
//-----------------------------------------
- (void)setButtonTitleAttribute:(NSDictionary *)attDic;

- (void)setButtonImage:(NSImage *)image;

- (void)setButtonImageWithNormal:(NSImage *)normal
                              up:(NSImage *)up
                            down:(NSImage *)down
                         disable:(NSImage *)disable;

- (void)setButtonColorWithNormal:(NSColor *)normal
                              up:(NSColor *)up
                            down:(NSColor *)down
                         disable:(NSColor *)disable;

//-----------------------------------------
//    Image Attribute
//-----------------------------------------
- (void)setAlertImage:(NSImage *)image;

//-----------------------------------------
//    Alert Title Attribute
//-----------------------------------------
- (void)setAlertTitle:(NSString *)title
             fontName:(NSString *)name 
             fontSize:(NSInteger)size 
            fontColor:(NSColor *)color 
       attributeRange:(NSRange)range
                align:(NSTextAlignment)align;

- (void)close;

@end
