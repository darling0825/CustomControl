//
//  SEAlert.m
//  SEAlert
//
//  Created by System Administrator on 13-8-21.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "SEAlert.h"

@interface SEAlert ()
- (IBAction)clickDefaultButton:(id)sender;
- (IBAction)clickAlternateButton:(id)sender;
- (IBAction)clickOtherButton:(id)sender;
@end

static SEAlert *alert = nil;
@implementation SEAlert

#pragma mark -------------------------初始化----------------------------
- (id)init
{
     return [self initWithTitle:@"Title"
                  defaultButton:@"Default"
                alternateButton:@"Alternate"
                    otherButton:@"Other"
                          image:nil];
}

- (id)initWithTitle:(NSString *)strTitle
      defaultButton:(NSString *)strDefaultBtn
    alternateButton:(NSString *)strAlternateBtn
        otherButton:(NSString *)strOtherBtn
              image:(NSImage *)image
{
    self = [super init];
    if (self) {
        [self alertWithTitle:strTitle
               defaultButton:strDefaultBtn
             alternateButton:strAlternateBtn
                 otherButton:strOtherBtn
                       image:image];
    }
    return self;
}

- (id)alertWithTitle:(NSString *)strTitle
      defaultButton:(NSString *)strDefaultBtn
    alternateButton:(NSString *)strAlternateBtn
        otherButton:(NSString *)strOtherBtn
              image:(NSImage *)image
{
//    self = [super init];
//    if (self) {
        if ([[NSBundle bundleForClass:[self class]] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)]) {
            [[NSBundle bundleForClass:[self class]] loadNibNamed:@"SEAlert"
                                                           owner:self
                                                 topLevelObjects:nil];
        } else {
            [NSBundle loadNibNamed:@"SEAlert"
                             owner:self];
        }
    
        NSLog(@"Object %@ is created successfully!",self);
        
        [alertTitle setStringValue:strTitle];
        
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
        
        //按钮默认图片
//        [self setButtonImageWithNormal:[[SlicesManager defaultManager] sliceNamed:@"BlueSmallButton_Normal" inImage:UIMainImageName]
//                                    up:[[SlicesManager defaultManager] sliceNamed:@"BlueSmallButton_Over" inImage:UIMainImageName]
//                                  down:[[SlicesManager defaultManager] sliceNamed:@"BlueSmallButton_Down" inImage:UIMainImageName]
//                               disable:[[SlicesManager defaultManager] sliceNamed:@"BlueSmallButton_Disable" inImage:UIMainImageName]];
//    
//        //按钮文字默认属性
//        [self setButtonColorWithNormal:[NSColor whiteColor]
//                                    up:[NSColor whiteColor]
//                                  down:[NSColor whiteColor]
//                               disable:[NSColor colorWithCalibratedRed:218.0/255 green:232.0/255 blue:248.0/255 alpha:1.0]];
    
        [alertImageView setImage:image];
//    }
    return self;
}

//类方法初始化
+ (id)alertWithTitle:(NSString *)strTitle
       defaultButton:(NSString *)strDefaultBtn
     alternateButton:(NSString *)strAlternateBtn
         otherButton:(NSString *)strOtherBtn
               image:(NSImage *)image
{
    return [[self sharedAlert] alertWithTitle:strTitle
                               defaultButton:strDefaultBtn
                             alternateButton:strAlternateBtn
                                 otherButton:strOtherBtn
                                       image:image];
}

#pragma mark -------------------------显示------------------------------
- (void)showAlertModalForWindow:(NSWindow *)docWindow
                 didEndSelector:(SEL)didEndSelector
                       delegate:(id)delegate
{
    if ([docWindow attachedSheet] != nil) {
        [NSApp stopModal];
        [NSApp endSheet:[docWindow attachedSheet]];
        [[docWindow attachedSheet] orderOut:self];
    }
    
    _delegate = delegate;
    _selector = didEndSelector;
    
    [NSApp beginSheet:[self window] 
       modalForWindow:docWindow
        modalDelegate:self
       didEndSelector:nil
          contextInfo:NULL];
    
    //模态
    //[NSApp runModalForWindow:[self window]];
}

- (void)runModalDidEndSelector:(SEL)didEndSelector
                      delegate:(id)delegate
{
    _delegate = delegate;
    _selector = didEndSelector;
    
    //模态
    [NSApp runModalForWindow:[self window]];
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
    NSImage *normlImage = nil;
    NSImage *upImage = nil;
    NSImage *downImage = nil;
    NSImage *disableImage = nil;
    
    normlImage = [normal retain];
    upImage = [up retain];
    downImage = [down retain];
    disableImage = [disable retain];

    
    if ([defaultButton isEnabled]) {
        [defaultButton setButtonStateImageWithNormal:normlImage up:upImage down:downImage disable:disableImage];
    }
    
    if ([alternateButton isEnabled]) {
        [alternateButton setButtonStateImageWithNormal:normlImage up:upImage down:downImage disable:disableImage];
    }
    
    if ([otherButton isEnabled]) {
        [otherButton setButtonStateImageWithNormal:normlImage up:upImage down:downImage disable:disableImage];
    }
    
    [normlImage release];
    [upImage release];
    [downImage release];
    [disableImage release];
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
    //Title
    if (title == nil || [title isEqualToString:@""]){
        [alertTitle setStringValue:@""];
        return;
    }
    else{
        [alertTitle setStringValue:title];
    }
    
    NSMutableDictionary *attribute = [[NSMutableDictionary alloc]init];
    
    //Align
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
    
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc]initWithAttributedString:[alertTitle attributedStringValue]];
    
    //Attribute title
    [attTitle addAttributes:attribute range:range];
    
    [alertTitle setAttributedStringValue:attTitle];
    
    [attribute release];
    [attTitle release];
}

- (void)close
{
    [NSApp stopModal];
    [NSApp endSheet:[self window] returnCode:NSAlertDefaultReturn];
    [[self window] orderOut:self];
}

#pragma mark -------------------------按钮动作---------------------------
- (IBAction)clickDefaultButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:_selector]) {
        [_delegate performSelector:_selector withObject:[self window] withObject:[NSNumber numberWithInt:NSAlertDefaultReturn]];
    }
}

- (IBAction)clickAlternateButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:_selector]) {
        [_delegate performSelector:_selector withObject:[self window] withObject:[NSNumber numberWithInt:NSAlertAlternateReturn]];
    }
}

- (IBAction)clickOtherButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:_selector]) {
        [_delegate performSelector:_selector withObject:[self window] withObject:[NSNumber numberWithInt:NSAlertOtherReturn]];
    }
}

#pragma mark --------------------------单例-----------------------------
+ (SEAlert *)sharedAlert
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[super allocWithZone:NULL] init];
    });
    return alert;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[SEAlert sharedAlert] retain];
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
