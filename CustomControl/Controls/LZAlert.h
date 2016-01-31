//
//  LZAlert.h
//  CustomControl
//
//  Created by System Administrator on 13-8-21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZButton.h"

@interface LZAlert : NSWindowController{
    IBOutlet NSImageView    *alertImageView;
    IBOutlet NSTextField    *alertTitle;
    IBOutlet NSTextField    *alertMessageText;
    
    IBOutlet LZButton       *defaultButton;
    IBOutlet LZButton       *alternateButton;
    IBOutlet LZButton       *otherButton;
}

//-----------------------------------------
//    单例
//-----------------------------------------
+ (LZAlert *)sharedAlert;

- (id)alertWithTitle:(NSString *)strTitle
         messageText:(NSString *)strMsgText
       defaultButton:(NSString *)strDefaultBtn
     alternateButton:(NSString *)strAlternateBtn
         otherButton:(NSString *)strOtherBtn
               image:(NSImage *)image;

//-----------------------------------------
//    alloc and init
//-----------------------------------------
- (id)initWithTitle:(NSString *)strTitle
        messageText:(NSString *)strMsgText
      defaultButton:(NSString *)strDefaultBtn
    alternateButton:(NSString *)strAlternateBtn
        otherButton:(NSString *)strOtherBtn
              image:(NSImage *)image;


//-----------------------------------------
//    Class Method
//-----------------------------------------
+ (id)alertWithTitle:(NSString *)strTitle
         messageText:(NSString *)strMsgText
       defaultButton:(NSString *)strDefaultBtn
     alternateButton:(NSString *)strAlternateBtn
         otherButton:(NSString *)strOtherBtn
               image:(NSImage *)image;

- (void)showAlertModalForWindow:(NSWindow *)docWindow
                       delegate:(id)delegate
                 didEndSelector:(SEL)didEndSelector 
                    contextInfo:(void *)contextInfo;

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

//-----------------------------------------
//    Alert Message Attribute
//-----------------------------------------
- (void)setAlertMessageText:(NSString *)title
                   fontName:(NSString *)name 
                   fontSize:(NSInteger)size 
                  fontColor:(NSColor *)color 
             attributeRange:(NSRange)range
                      align:(NSTextAlignment)align;

@end
