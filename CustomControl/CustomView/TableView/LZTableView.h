//
//  LZTableView.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
 TableView Setting
 */
#define KeyWidth                    @"Width"
#define KeyMinWidth                 @"MinWidth"
#define KeyIsResizable              @"IsResizable"
#define KeyTitle                    @"Title"
#define KeyIdentifier               @"Identifier"
#define KeyCompareIdentifier        @"CompareIdentifier"

@protocol LZTableViewDelegate;

@interface LZTableView : NSTableView{
    NSRange             _visibleRows;
    
    NSTrackingArea      *_trackingArea;
    
    NSInteger           _rowForMouseAt;
    NSInteger           _columnForMouseAt;
    
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
@property(assign) id <LZTableViewDelegate> delegate;
@property(retain) NSImage *headerBackgroundImage;
@property(retain) NSImage *headerLineImage;
@property(retain) NSColor *headerBackgroundColor;
@property(retain) NSColor *headerLineColor;
@property(retain) NSColor *highlightColor;
@property(retain) NSFont *headerFont;
@property(retain) NSColor *headerFontColor;
@property (assign)float headerHeight;
@property(assign,setter = setAllowsRowHighlight:) BOOL allowsRowHighlight;

/*
 TableView Setting
 */
- (void)setTableView:(NSArray *)columnSettings;

@end


@protocol LZTableViewDelegate <NSTableViewDelegate>
@optional
- (void)tableView:(LZTableView *)tableView changedVisibleRowsFromRange:(NSRange)oldVisibleRows toRange:(NSRange)newVisibleRows;

- (void)mouseInRow:(NSInteger)row column:(NSInteger)column;
@end