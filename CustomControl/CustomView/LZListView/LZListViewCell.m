//
//  LZListViewCell.m
//  CustomControl
//
//  Created by liww on 2014/12/1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZListViewCell.h"

@implementation LZListViewCell
@dynamic reuseIdentifier;
@dynamic text;
@dynamic image;

- (id)init
{
    self = [super init];
    if (self){
        
        // 初始化时加载xib文件
        BOOL loadSuccess = NO;
        NSMutableArray *topLevelObjs = [NSMutableArray array];
        
        if ([[NSBundle bundleForClass:[self class]] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)]) {
            // We're running on Mountain Lion or higher
            loadSuccess = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LZListViewCell"
                                                                         owner:self
                                                               topLevelObjects:&topLevelObjs];
        }
        else {
            // We're running on Lion
//            loadSuccess = [NSBundle loadNibNamed:@"MyCollectionViewCell"
//                                           owner:self];
            
            NSDictionary *nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
                                       self, NSNibOwner,
                                       topLevelObjs, NSNibTopLevelObjects,
                                       nil];
            loadSuccess = [[NSBundle bundleForClass:[self class]] loadNibFile:@"LZListViewCell" externalNameTable:nameTable withZone:nil];
        }
        
        if (!loadSuccess || [topLevelObjs count] <= 0) {
            return nil;
        }
        
        for (int i = 0; i < [topLevelObjs count]; i++) {
            if ([[topLevelObjs objectAtIndex:i] isKindOfClass:NSClassFromString(@"LZListViewCell")]){
                self = [[topLevelObjs objectAtIndex:i] retain];
                break;
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    [_text release]; _text = nil;
    [super dealloc];
}

- (void)prepareForReuse
{
    
}

- (NSString *)reuseIdentifier
{
    return _reuseIdentifier;
}

- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    [_reuseIdentifier release]; _reuseIdentifier = nil;
    _reuseIdentifier = [reuseIdentifier copy];
}

- (NSString *)text
{
    return _text;
}

- (void)setText:(NSString *)text
{
    if (text) {
        [_textField setStringValue:text];
        
        [_text release]; _text = nil;
        _text = [text copy];
    }
}

- (NSImage *)image
{
    return _image;
}

- (void)setImage:(NSImage *)image
{
    [_imageView setImage:image];
    
    [image retain];
    [_image release]; _image = nil;
    _image = image;
}

@end
