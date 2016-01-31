//
//  LZOutlineView.h
//  CustomControl
//
//  Created by liww on 14-6-16.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LZOutlineView : NSOutlineView{
    NSImage             *_headerBackgroundImage;
    NSImage             *_headerLineImage;
    NSColor             *_headerBackgroundColor;
    NSColor             *_headerLineColor;
    
    BOOL                _allowsRowHighlight;
    NSColor             *_highlightColor;
    float               _headerHeight;
    NSFont              *_headerFont;
    NSColor             *_headerFontColor;
}
@property(retain) NSImage *headerBackgroundImage;
@property(retain) NSImage *headerLineImage;
@property(retain) NSColor *headerBackgroundColor;
@property(retain) NSColor *headerLineColor;
@property(retain) NSColor *highlightColor;
@property(retain) NSColor *headerFontColor;
@property(retain) NSFont *headerFont;
@property (assign)float headerHeight;
@property(assign,setter = setAllowsRowHighlight:) BOOL allowsRowHighlight;
@end
