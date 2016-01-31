//
//  LZAlert.m
//  CustomControl
//
//  Created by System Administrator on 13-8-21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LZAlert.h"

@interface LZAlert (){

}
- (IBAction)clickDefaultButton:(id)sender;
- (IBAction)clickAlternateButton:(id)sender;
- (IBAction)clickOtherButton:(id)sender;
- (void)setString:(NSString *)title
          forView:(id)view
         fontName:(NSString *)name
         fontSize:(NSInteger)size
        fontColor:(NSColor *)color
            align:(NSTextAlignment)align
        underline:(BOOL)underline
   attributeRange:(NSRange)range;

@end



static LZAlert *_alert = nil;

@implementation LZAlert

#pragma mark -------------------------初始化----------------------------

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (id)init
{
     return [self initWithTitle:@"Title"
                    messageText:@"Message"
                  defaultButton:@"Default"
                alternateButton:@"Alternate"
                    otherButton:@"Other"
                          image:nil];
}

- (id)initWithTitle:(NSString *)strTitle
        messageText:(NSString *)strMsgText
      defaultButton:(NSString *)strDefaultBtn
    alternateButton:(NSString *)strAlternateBtn
        otherButton:(NSString *)strOtherBtn
              image:(NSImage *)image
{
    self = [super init];
    if (self) {
        [self alertWithTitle:strTitle
                 messageText:strMsgText
               defaultButton:strDefaultBtn
             alternateButton:strAlternateBtn
                 otherButton:strOtherBtn
                       image:image];
    }
    return self;
}

//类方法初始化
+ (id)alertWithTitle:(NSString *)strTitle
         messageText:(NSString *)strMsgText
       defaultButton:(NSString *)strDefaultBtn
     alternateButton:(NSString *)strAlternateBtn
         otherButton:(NSString *)strOtherBtn
               image:(NSImage *)image
{
    return [[[self alloc] initWithTitle:strTitle
                            messageText:strMsgText
                          defaultButton:strDefaultBtn
                        alternateButton:strAlternateBtn
                            otherButton:strOtherBtn
                                  image:image] autorelease];
}

//单例使用的初始化方式
- (id)alertWithTitle:(NSString *)strTitle
         messageText:(NSString *)strMsgText
       defaultButton:(NSString *)strDefaultBtn
     alternateButton:(NSString *)strAlternateBtn
         otherButton:(NSString *)strOtherBtn
               image:(NSImage *)image
{
    if ([[NSBundle bundleForClass:[self class]] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)]) {
        // We're running on Mountain Lion or higher
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LZAlert"
                                      owner:self
                            topLevelObjects:nil];
    } else {
        // We're running on Lion
        [NSBundle loadNibNamed:@"LZAlert"
                         owner:self];
    }
    
    NSLog(@"Object %@ is created successfully!",self);
    
    [alertTitle setStringValue:strTitle];
    [alertMessageText setStringValue:strMsgText];
    
    if (strDefaultBtn == nil){
        [defaultButton setEnabled:NO];
        [defaultButton setHidden:YES];
    }
    else{
        [defaultButton setTitle:strDefaultBtn];
    }
    
    if (strAlternateBtn == nil){
        [alternateButton setEnabled:NO];
        [alternateButton setHidden:YES];
    }
    else{
        [alternateButton setTitle:strAlternateBtn];
    }
    
    if (strOtherBtn == nil){
        [otherButton setEnabled:NO];
        [otherButton setHidden:YES];
    }
    else{
        [otherButton setTitle:strOtherBtn];
    }
    
    [alertImageView setImage:image];
    
    return self;
}


#pragma mark -------------------------显示------------------------------
- (void)showAlertModalForWindow:(NSWindow *)docWindow
                       delegate:(id)delegate
                 didEndSelector:(SEL)didEndSelector 
                    contextInfo:(void *)contextInfo
{
    if ([docWindow attachedSheet] != nil) 
    {
        [NSApp stopModal];
        //[NSApp endSheet:[docWindow attachedSheet] returnCode:NSCancelButton];
        [NSApp endSheet:[docWindow attachedSheet]];
        [[docWindow attachedSheet] orderOut:self];
    }
    
    [NSApp beginSheet:[self window] 
       modalForWindow:docWindow
        modalDelegate:delegate
       didEndSelector:didEndSelector 
          contextInfo:contextInfo];
    
    //模态
    //[NSApp runModalForWindow:[self window]];
}


#pragma mark -------------------------设置属性---------------------------
- (void)setButtonTitleAttribute:(NSDictionary *)attDic
{
    if ([defaultButton isEnabled]) {
        NSMutableAttributedString *defaultButtonTitle = [[NSMutableAttributedString alloc]initWithAttributedString:[defaultButton attributedTitle]];
        [defaultButtonTitle addAttributes:attDic range:NSMakeRange(0, [defaultButtonTitle length])];
        [defaultButton setAttributedTitle:defaultButtonTitle];
        [defaultButtonTitle release]; defaultButtonTitle = nil;
    }
    
    if ([alternateButton isEnabled]) {
        NSMutableAttributedString *alternateButtonTitle = [[NSMutableAttributedString alloc]initWithAttributedString:[alternateButton attributedTitle]];
        [alternateButtonTitle addAttributes:attDic range:NSMakeRange(0, [alternateButtonTitle length])];
        [alternateButton setAttributedTitle:alternateButtonTitle];
        [alternateButtonTitle release]; alternateButtonTitle = nil;
    }
    
    if ([otherButton isEnabled]) {
        NSMutableAttributedString *otherButtonTitle = [[NSMutableAttributedString alloc]initWithAttributedString:[otherButton attributedTitle]];
        [otherButtonTitle addAttributes:attDic range:NSMakeRange(0, [otherButtonTitle length])];
        [otherButton setAttributedTitle:otherButtonTitle];
        [otherButtonTitle release]; otherButtonTitle = nil;
    }
}

- (void)setButtonImage:(NSImage *)image
{
    if ([defaultButton isEnabled]) {
        [defaultButton setButtonImage:image];
    }
    
    if ([alternateButton isEnabled]) {
        [alternateButton setButtonImage:image];
    }
    
    if ([otherButton isEnabled]) {
        [otherButton setButtonImage:image];
    }

}

- (void)setButtonImageWithNormal:(NSImage *)normal
                              up:(NSImage *)up
                            down:(NSImage *)down
                         disable:(NSImage *)disable
{
    if ([defaultButton isEnabled]) {
        [defaultButton setButtonStateImageWithNormal:normal up:up down:down disable:disable];
    }
    
    if ([alternateButton isEnabled]) {
        [alternateButton setButtonStateImageWithNormal:normal up:up down:down disable:disable];
    }
    
    if ([otherButton isEnabled]) {
        [otherButton setButtonStateImageWithNormal:normal up:up down:down disable:disable];
    }
}

- (void)setButtonColorWithNormal:(NSColor *)normal
                              up:(NSColor *)up
                            down:(NSColor *)down
                         disable:(NSColor *)disable
{
    if ([defaultButton isEnabled]) {
        [defaultButton setTitleColorWithNormal:normal up:up down:down disable:disable];
    }
    
    if ([alternateButton isEnabled]) {
        [alternateButton setTitleColorWithNormal:normal up:up down:down disable:disable];
    }
    
    if ([otherButton isEnabled]) {
        [otherButton setTitleColorWithNormal:normal up:up down:down disable:disable];
    }
}

- (void)setAlertImage:(NSImage *)image
{
    [alertImageView setImage:image];
}

- (void)setAlertTitle:(NSString *)title
             fontName:(NSString *)name 
             fontSize:(NSInteger)size 
            fontColor:(NSColor *)color 
       attributeRange:(NSRange)range
                align:(NSTextAlignment)align
{
    [self setString:title 
            forView:alertTitle
           fontName:name 
           fontSize:size 
          fontColor:color
              align:align
          underline:NO
     attributeRange:range];
}

- (void)setAlertMessageText:(NSString *)title
                   fontName:(NSString *)name 
                   fontSize:(NSInteger)size 
                  fontColor:(NSColor *)color 
             attributeRange:(NSRange)range
                      align:(NSTextAlignment)align
{
    [self setString:title 
             forView:alertMessageText
           fontName:name 
           fontSize:size 
          fontColor:color
              align:align
          underline:NO
     attributeRange:range];
}

- (void)setString:(NSString *)title
          forView:(id)view
         fontName:(NSString *)name 
         fontSize:(NSInteger)size 
        fontColor:(NSColor *)color 
            align:(NSTextAlignment)align
        underline:(BOOL)underline
   attributeRange:(NSRange)range
{
    //Title
    if (title == nil || [title isEqualToString:@""]) 
    {
        [view setStringValue:@""];
        return;
    }
    else 
    {
        [view setStringValue:title];
    }
    
    NSMutableDictionary *attribute = [[NSMutableDictionary alloc]init];
    
    //Align
    //[self setAlignment:align];
    NSMutableParagraphStyle *ps = [[[NSParagraphStyle defaultParagraphStyle]mutableCopy]autorelease];
    [ps setAlignment:align];
    [attribute setObject:ps forKey:NSParagraphStyleAttributeName];
    
    //Font name, size
    NSString *fontName = @"Helvetica";
    if (name != nil && ![name isEqualToString:@""]) 
    {
        fontName = [NSString stringWithString:name];
    }
    
    NSFont *font =[NSFont fontWithName:fontName size:size];
    [attribute setObject:font forKey:NSFontAttributeName];
    
    //Color
    if (color != nil) 
    {
        [attribute setObject:color forKey:NSForegroundColorAttributeName];
    }
    
    //下划线
    if (underline) {
        [attribute setObject:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                      forKey:NSUnderlineStyleAttributeName];
    }
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[view attributedStringValue]];
    
    //Attribute title
    [attTitle addAttributes:attribute range:range];
    
    [view setAttributedStringValue:attTitle];
    
    [attribute release];
    [attTitle release];
}

#pragma mark -------------------------按钮动作---------------------------
- (IBAction)clickDefaultButton:(id)sender
{
    [NSApp stopModal];
    [NSApp endSheet:[self window] returnCode:NSAlertDefaultReturn];
    [[self window] orderOut:self];
}

- (IBAction)clickAlternateButton:(id)sender
{
    [NSApp stopModal];
    [NSApp endSheet:[self window] returnCode:NSAlertAlternateReturn];
    [[self window] orderOut:self];
}

- (IBAction)clickOtherButton:(id)sender
{
    [NSApp stopModal];
    [NSApp endSheet:[self window] returnCode:NSAlertOtherReturn];
    [[self window] orderOut:self];
}


#pragma mark --------------------------单例-----------------------------
+ (LZAlert *)sharedAlert
{
    if (_alert == nil)
    {
        _alert = [[super allocWithZone:NULL] init];
    }
    
    return _alert;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[LZAlert sharedAlert] retain];
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (oneway void)release
{
    //
}

- (id)autorelease
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

-(void)dealloc
{
	[super dealloc];
}


@end
