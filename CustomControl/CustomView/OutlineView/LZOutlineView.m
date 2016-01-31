//
//  LZOutlineView.m
//  CustomControl
//
//  Created by liww on 14-6-16.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZOutlineView.h"
#import "LZTableHeaderCell.h"
#define TableHeaderViewHeight   30.0

@implementation LZOutlineView
@synthesize headerBackgroundImage   = _headerBackgroundImage;
@synthesize headerBackgroundColor   = _headerBackgroundColor;
@synthesize headerLineImage         = _headerLineImage;
@synthesize headerLineColor         = _headerLineColor;
@synthesize highlightColor          = _highlightColor;
@synthesize allowsRowHighlight      = _allowsRowHighlight;
@synthesize headerHeight            = _headerHeight;
@synthesize headerFont              = _headerFont;
@synthesize headerFontColor         = _headerFontColor;

- (void)dealloc
{
    [_headerBackgroundImage release]; _headerBackgroundImage    = nil;
    [_headerBackgroundColor release]; _headerBackgroundColor    = nil;
    [_headerLineImage       release]; _headerLineImage          = nil;
    [_headerLineColor       release]; _headerLineColor          = nil;
    [_headerFont            release]; _headerFont               = nil;
    [_headerFontColor       release]; _headerFontColor          = nil;
    
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)awakeFromNib
{
    _headerBackgroundColor      = [[NSColor whiteColor] retain];
    _headerLineColor            = [[NSColor whiteColor] retain];
    
    _allowsRowHighlight         = YES;
    _highlightColor             = [[NSColor blueColor] retain];
    
    _headerHeight               = TableHeaderViewHeight;
    _headerFont                 = [[NSFont fontWithName:@"Helvetica Neue" size:12] retain];
    _headerFontColor            = [NSColor redColor];
}

- (void)viewWillDraw
{
    //The default is YES, the indentation marker is indented along with the cell contents.跟随内容
    //Return NO, the indentation marker is always displayed left-justified in the column.始终左对齐
    [self setIndentationMarkerFollowsCell:YES];
    [self setIndentationPerLevel:19];
    
    //设置水平，坚直线
    [self setGridStyleMask:NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask];
    
    //线条色
    [self setGridColor:[NSColor redColor]];
    
    //行与行之间蓝白交替的背景
    [self setUsesAlternatingRowBackgroundColors:NO];
    
    //设置背景色
    [self setBackgroundColor:[NSColor whiteColor]];
    
    //选中高亮色模式
    //[self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    
    //不需要列表头
    //[self setHeaderView:nil];
    //使用隐藏的效果会出现表头的高度
    //[[self headerView] setHidden:YES];
    
    //Draw Table Header
    [self drawTableViewHeader];
    
    //去掉蓝框
    [self setFocusRingType:NSFocusRingTypeNone];
    
    [self sizeLastColumnToFit];
    [self setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    
    //设置允许多选
    [self setAllowsMultipleSelection:NO];
    
    //设置每个cell的换行模式，显不下时用...
    [[self cell] setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [[self cell] setTruncatesLastVisibleLine:YES];
    
    //双击
//    [self setDoubleAction:@selector(ontableviewrowdoubleClicked:)];
//    [self setAction:@selector(ontablerowclicked:)];
    
    [self setAllowsTypeSelect:YES];

    //CornerView
    [self setCornerView:nil];
}

//设置TableView Header
- (void)drawTableViewHeader
{
    //HeaderView
    NSRect headerRect = [[self headerView] frame];
    headerRect.size.height = _headerHeight;
    [[self headerView] setFrame:headerRect];
    
    //Crash
    //    NSTableHeaderView *newHeaderView = [[NSTableHeaderView alloc] initWithFrame:headerRect];
    //    [self setHeaderView:newHeaderView];
    //    [newHeaderView release]; newHeaderView = nil;
    
    //HeaderCell
    for (int i = 0; i < [self numberOfColumns]; i++) {
        NSTableColumn *column = [[self tableColumns] objectAtIndex:i];
        LZTableHeaderCell *newHeaderCell = [[LZTableHeaderCell alloc] initTextCell:[[column headerCell] stringValue]];
        
        //最后一列不画线
        if (i == [self numberOfColumns] - 1) {
            [newHeaderCell setLastHeader:YES];
        }
        
        if (_headerBackgroundImage) {
            [newHeaderCell setBackgroundImage:_headerBackgroundImage];
        }
        
        if (_headerLineImage) {
            [newHeaderCell setLineImage:_headerLineImage];
        }

        if (_headerBackgroundColor) {
            [newHeaderCell setBackgroundColor:_headerBackgroundColor];
        }
        
        if (_headerLineColor) {
            [newHeaderCell setLineColor:_headerLineColor];
        }
        
        if (_headerFont) {
            [newHeaderCell setHeaderFont:_headerFont];
        }
        
        if (_headerFontColor) {
            [newHeaderCell setHeaderFontColor:_headerFontColor];
        }
        
        
        [column setHeaderCell:newHeaderCell];
        [newHeaderCell release]; newHeaderCell = nil;
    }
    
    //CornerView
    [self setCornerView:nil];
}

//- (id)_highlightColorForCell:(id)cell
//{
//    if([self selectionHighlightStyle] == NSTableViewSelectionHighlightStyleSourceList){
//        return nil;
//    }
//    else{
//        return _highlightColor;
//    }
//}


//设置选中行高亮颜色,行与行交替颜色设置
//设置NSTableViewSelectionHighlightStyleNone 时, 不调用
- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
    //行与行交替颜色设置
    if ([self usesAlternatingRowBackgroundColors]) {
        NSColor *colorForEven = [NSColor controlHighlightColor];
        NSColor *colorForOdd = [NSColor whiteColor];
        NSInteger rowCount = [self numberOfRows];
        for (NSInteger i = 0; i < rowCount; i++) {
            if (i % 2 == 0) {
                [colorForEven set];
                NSRectFill([self rectOfRow:i]);
            }
            else{
                [colorForOdd set];
                NSRectFill([self rectOfRow:i]);
            }
        }
    }

    //设置选中行高亮颜色, 但是文字部分还是NSTableViewSelectionHighlightStyleRegular
    if (_allowsRowHighlight) {
        NSIndexSet *selectedRowSet = [self selectedRowIndexes];
        NSRange visibleRowRange = [self rowsInRect:clipRect];
        NSUInteger selectedRow = [selectedRowSet firstIndex];
        while (selectedRow != NSNotFound) {
            if (selectedRow == -1 || !NSLocationInRange(selectedRow, visibleRowRange)) {
                selectedRow = [selectedRowSet indexGreaterThanIndex:selectedRow];
                continue;
            }
            [_highlightColor set];
            NSRectFill([self rectOfRow:selectedRow]);
            selectedRow = [selectedRowSet indexGreaterThanIndex:selectedRow];
        }
    }
}

//- (NSRect)frameOfOutlineCellAtRow:(NSInteger)row
//{
//    return NSZeroRect;
//}
//
//- (NSRect)frameOfCellAtColumn:(NSInteger)column row:(NSInteger)row
//{
//    NSRect superFrame = [super frameOfCellAtColumn:column row:row];
//    CGFloat adjustment = 11.0;
//    if (superFrame.origin.x - adjustment < 6) {
//        adjustment = MAX(0, superFrame.origin.x - adjustment < adjustment);
//    }
//    return NSMakeRect(superFrame.origin.x - adjustment,
//                      superFrame.origin.y,
//                      superFrame.size.width + adjustment,
//                      superFrame.size.height);
//}

@end
