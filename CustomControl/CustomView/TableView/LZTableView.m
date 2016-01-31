//
//  LZTableView.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZTableView.h"
#import "LZTableHeaderCell.h"

#define TableHeaderViewHeight   30.0

@implementation LZTableView
@synthesize headerBackgroundImage   = _headerBackgroundImage;
@synthesize headerBackgroundColor   = _headerBackgroundColor;
@synthesize headerLineImage         = _headerLineImage;
@synthesize headerLineColor         = _headerLineColor;
@synthesize highlightColor          = _highlightColor;
@synthesize allowsRowHighlight      = _allowsRowHighlight;
@synthesize headerHeight            = _headerHeight;
@synthesize headerFont              = _headerFont;
@synthesize headerFontColor         = _headerFontColor;
@dynamic delegate;

- (void)dealloc
{
    [self removeTrackingArea:_trackingArea];
    [_trackingArea release]; _trackingArea = nil;
    
    [_headerBackgroundImage release]; _headerBackgroundImage    = nil;
    [_headerBackgroundColor release]; _headerBackgroundColor    = nil;
    [_headerLineImage       release]; _headerLineImage          = nil;
    [_headerLineColor       release]; _headerLineColor          = nil;
    [_headerFont            release]; _headerFont               = nil;
    [_headerFontColor       release]; _headerFontColor          = nil;
    
    [super dealloc];
}
- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


//Delegate settet and getter
- (void)setDelegate:(id <LZTableViewDelegate>)delegate
{
    [super setDelegate:delegate];
}

- (id <LZTableViewDelegate>)delegate
{
    return (id <LZTableViewDelegate>)[super delegate];
}

- (void)awakeFromNib
{
    _rowForMouseAt          = -1;
    _columnForMouseAt       = -1;
    [self __updateTrackingAreas];
    
    _headerBackgroundColor  = [[NSColor whiteColor] retain];
    _headerLineColor        = [[NSColor whiteColor] retain];
    
    _allowsRowHighlight     = YES;
    _highlightColor         = [[NSColor blueColor] retain];
    
    _headerHeight           = TableHeaderViewHeight;
    _headerFont             = [[NSFont fontWithName:@"Helvetica Neue" size:12] retain];
    _headerFontColor        = [NSColor redColor];
}

- (void)viewWillDraw
{
    //设置水平，坚直线
    [self setGridStyleMask:NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask];
    
    //线条色
    [self setGridColor:[NSColor redColor]];
    
    //行与行之间蓝白交替的背景
    [self setUsesAlternatingRowBackgroundColors:YES];
    
    //设置背景色
    [self setBackgroundColor:[NSColor whiteColor]];
    
    //选中高亮色模式(具体类自己定制)
    //[self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleRegular];
    
    //不需要列表头
    //[self setHeaderView:nil];
    //使用隐藏的效果会出现表头的高度
    //[[self headerView] setHidden:YES];
    
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
    //[self setDoubleAction:@selector(ontableviewrowdoubleClicked:)];
    //[self setAction:@selector(ontablerowclicked:)];
    
    [self setAllowsTypeSelect:YES];
    
    //Draw Table Header
    [self drawTableViewHeader];
    
    
    //加载图片
    NSRange newVisibleRows = [self rowsInRect:self.visibleRect];
    BOOL visibleRowsNeedsUpdate = !NSEqualRanges(newVisibleRows, _visibleRows);
    NSRange oldVisibleRows = _visibleRows;
    
    if (visibleRowsNeedsUpdate) {
        _visibleRows = newVisibleRows;
        
        //加载图片
        if ([self delegate]&&[[self delegate] respondsToSelector:@selector(tableView:changedVisibleRowsFromRange:toRange:)]) {
            [[self delegate] tableView:self
           changedVisibleRowsFromRange:oldVisibleRows
                               toRange:newVisibleRows];
        }
    }
    
    // We have to call super first in case the NSTableView does some layout in -viewWillDraw
    [super viewWillDraw];
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
            [newHeaderCell setFont:_headerFont];
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

//无数据时的背景色
//- (void)drawGridInClipRect:(NSRect)clipRect
//{
//    [[NSColor redColor] set];
//    NSRectFill(clipRect);
//}

//无数据时的背景色
//- (void)drawBackgroundInClipRect:(NSRect)clipRect
//{
//    [[NSColor grayColor] set];
//    NSRectFill(clipRect);
//}

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


- (void)__updateTrackingAreas
{
    if (_trackingArea) {
        [self removeTrackingArea:_trackingArea];
        [_trackingArea release]; _trackingArea = nil;
    }
    
    int opts = NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveAlways;
    _trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)setTableView:(NSArray *)columnSettings
{
    if (columnSettings == nil || columnSettings.count <= 0) {
        return;
    }
    
    //清空现有的table的列
    NSArray *tableColumns = [NSArray arrayWithArray:[self tableColumns]];
    
    for (NSTableColumn *tableColumn in tableColumns){
        [self removeTableColumn:tableColumn];
    }
    
    NSArray *settingArr = [NSArray arrayWithArray:columnSettings];
    
    NSEnumerator *enumerator = [settingArr objectEnumerator];
    NSDictionary *tableColumnsDict = nil;
    
    while (tableColumnsDict = [enumerator nextObject]) {
    //for(int columnIndex = 0; columnIndex < settingArr.count; columnIndex++){
    //此处不能使用for-in遍历
    //for (NSDictionary *tableColumnDict in settingArr) {
        //NSDictionary *tableColumnDict = [settingArr objectAtIndex:columnIndex];
        
        float width = [[tableColumnsDict objectForKey:KeyWidth] floatValue];
        float minWidth = [[tableColumnsDict objectForKey:KeyMinWidth] floatValue];
        BOOL isResizable = [[tableColumnsDict objectForKey:KeyIsResizable] boolValue];
        NSString *title = [tableColumnsDict objectForKey:KeyTitle];
        NSString *identifier = [tableColumnsDict objectForKey:KeyIdentifier];
        NSString *compareIdentifier = [tableColumnsDict objectForKey:KeyCompareIdentifier];
        
        NSSortDescriptor *descriptor = nil;
        if (compareIdentifier.length > 0) {
            descriptor = [NSSortDescriptor sortDescriptorWithKey:compareIdentifier
                                                       ascending:YES
                                                        selector:@selector(compare:)];
        }
        else{
            descriptor = [NSSortDescriptor sortDescriptorWithKey:identifier
                                                       ascending:YES
                                                        selector:@selector(caseInsensitiveCompare:)];
        }
        
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:identifier];
        [column setWidth:width];
        [column setMinWidth:minWidth];
        [column.headerCell setTitle:title];
        [column setEditable:NO];
        [column setSortDescriptorPrototype:descriptor];
        if (!isResizable) {
            [column setResizingMask:NSTableColumnNoResizing];
        }
        
        [self addTableColumn:column];
        
        [column release]; column = nil;
    }
    
    [self setNeedsDisplay];
}

#pragma mark
#pragma mark ----------------- Mouse Event -----------------
- (void)mouseMoved:(NSEvent *)theEvent
{
    [self __mouseMoved:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    NSLog(@">>> mouseEntered Row:%ld column:%ld",_rowForMouseAt,_columnForMouseAt);
    [self _mouseInRow:_rowForMouseAt column:_columnForMouseAt];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    NSLog(@">>> mouseExited");
    _rowForMouseAt = -1;
    [self _mouseInRow:_rowForMouseAt column:_columnForMouseAt];
}

- (void)__mouseMoved:(NSEvent *)theEvent
{
    NSView *scrollView = [[self superview] superview];
    NSRect scrollViewRect = [scrollView frame];
    NSPoint pointAtScrollView = [[scrollView superview] convertPoint:theEvent.locationInWindow fromView:nil];
    if (!NSPointInRect(pointAtScrollView, scrollViewRect)) {
        _rowForMouseAt = -1;
        _columnForMouseAt = -1;
        [self _mouseInRow:_rowForMouseAt column:_columnForMouseAt];
        return;
    }
    
    NSPoint pointAtTableView = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSInteger rowAtPoint = [self rowAtPoint:pointAtTableView];
    NSInteger columnAtPoint = [self columnAtPoint:pointAtTableView];
    if (rowAtPoint != _rowForMouseAt || columnAtPoint != _columnForMouseAt) {
        _rowForMouseAt = rowAtPoint;
        _columnForMouseAt = columnAtPoint;
        
        NSLog(@">>> mouseMoved Row:%ld column:%ld",_rowForMouseAt,_columnForMouseAt);
        [self _mouseInRow:_rowForMouseAt column:_columnForMouseAt];
    }
}

- (void)_mouseInRow:(NSInteger)row column:(NSInteger)column
{
    if ([self delegate] && [[self delegate] respondsToSelector:@selector(mouseInRow:column:)]) {
        [[self delegate] mouseInRow:row column:column];
    }
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [self __mouseMoved:theEvent];
    [super scrollWheel:theEvent];
}

- (void)updateTrackingAreas
{
    [self __updateTrackingAreas];
    [super updateTrackingAreas];
}

@end
