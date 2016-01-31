//
//  LZGridView.m
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZGridView.h"

@interface LZGridView (){
    NSMutableDictionary *keyedVisibleItems;
    NSMutableDictionary *reuseableItems;
    NSMutableDictionary *selectedItems;
    
    NSInteger numberOfItems;
    NSInteger numberOfSections;
    
    BOOL isInitialCall;
}
@end

@implementation LZGridView

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaults];
        _delegate = nil;
        _dataSource = nil;
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
        _delegate = nil;
        _dataSource = nil;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (void)setupDefaults
{
    keyedVisibleItems = [[NSMutableDictionary alloc] init];
    reuseableItems = [[NSMutableDictionary alloc] init];
    selectedItems = [[NSMutableDictionary alloc] init];
    
    _itemSize = [LZGridViewItem defaultItemSize];
    _itemBoundSize = [LZGridViewItem defaultItemSize];
    
    _scrollElasticity = YES;
    _allowsSelection = YES;
    _allowsMultipleSelection = NO;
    _allowsMultipleSelectionWithDrag = NO;
    _useSelectionRing = YES;
    _useHover = YES;
    
    isInitialCall = YES;
    
    [[self enclosingScrollView] setDrawsBackground:YES];
	NSClipView *clipView = [[self enclosingScrollView] contentView];
	[clipView setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:@selector(updateVisibleRect)
	                                             name:NSViewBoundsDidChangeNotification
	                                           object:clipView];
}

#pragma mark - Accessors

- (void)setItemSize:(NSSize)itemSize
{
    if (!NSEqualSizes(_itemSize, itemSize)) {
        _itemSize = itemSize;
        _itemBoundSize = NSMakeSize(_itemSize.width + 2*_contentInset, _itemSize.height + 2*_contentInset);
        [self refreshGridViewAnimated:YES initialCall:YES];
    }
}

- (void)setContentInset:(CGFloat)contentInset
{
    if (_contentInset != contentInset) {
        _contentInset = contentInset;
        _itemBoundSize = NSMakeSize(_itemSize.width + 2*_contentInset, _itemSize.height + 2*_contentInset);
        [self refreshGridViewAnimated:YES initialCall:YES];
    }
}

- (void)setScrollElasticity:(BOOL)scrollElasticity
{
    _scrollElasticity = scrollElasticity;
    NSScrollView *scrollView = [self enclosingScrollView];
    if (_scrollElasticity) {
        [scrollView setHorizontalScrollElasticity:NSScrollElasticityAllowed];
        [scrollView setVerticalScrollElasticity:NSScrollElasticityAllowed];
    }
    else {
        [scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
        [scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
    }
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [[self enclosingScrollView] setBackgroundColor:_backgroundColor];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    _allowsMultipleSelection = allowsMultipleSelection;
    if (selectedItems.count > 0 && !allowsMultipleSelection) {
        [selectedItems removeAllObjects];
    }
}

#pragma mark - Creating GridView Items

- (id)dequeueReusableItemWithIdentifier:(NSString *)identifier
{
    LZGridViewItem *reusableItem = nil;
    NSMutableSet *reuseQueue = reuseableItems[identifier];
    if (reuseQueue != nil && [reuseQueue count] > 0) {
        reusableItem = [reuseQueue anyObject];
        [reuseQueue removeObject:reusableItem];
        reuseableItems[identifier] = reuseQueue;
        reusableItem.representedItem = nil;
    }
    return reusableItem;
}

#pragma mark - Reloading GridView Data

- (void)reloadData
{
    [self reloadDataAnimated:NO];
}

- (void)reloadDataAnimated:(BOOL)animated
{
    numberOfItems = [self gridView:self numberOfItemsInSection:0];
    [keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [((LZGridViewItemBase *)obj).view removeFromSuperview];
    }];
    [keyedVisibleItems removeAllObjects];
    [reuseableItems removeAllObjects];
    [self refreshGridViewAnimated:animated initialCall:YES];
}

#pragma mark - Private Helper

- (void)updateVisibleRect
{
	[self updateReuseableItems];
	[self updateVisibleItems];
	[self arrangeGridViewItemsAnimated:NO];
}

- (void)updateReuseableItems
{
    //Do not mark items as reusable unless there are no selected items in the grid as recycling items when doing range multiselect
    if (self.selectedIndexes.count == 0) {
        NSRange visibleItemRange = [self visibleItemRange];
        
        //从keyedVisibleItems 中移除不可见的item,并添加到reuseableItems
        [[keyedVisibleItems allValues] enumerateObjectsUsingBlock: ^(LZGridViewItem *item, NSUInteger idx, BOOL *stop) {
            if (!NSLocationInRange(item.index, visibleItemRange) && [item isReuseable]) {
                [keyedVisibleItems removeObjectForKey:@(item.index)];
                [item.view removeFromSuperview];
                [item prepareForReuse];
                
                NSMutableSet *reuseQueue = reuseableItems[item.reuseIdentifier];
                if (reuseQueue == nil) {
                    reuseQueue = [NSMutableSet set];
                }
                [reuseQueue addObject:item];
                reuseableItems[item.reuseIdentifier] = reuseQueue;
            }
        }];
    }
}

- (void)updateVisibleItems
{
    //  当前可见范围
    NSRange visibleItemRange = [self visibleItemRange];
    NSMutableIndexSet *visibleItemIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:visibleItemRange];
    
    //  移除已加载的，只加载未加载的
    [visibleItemIndexes removeIndexes:[self indexesForVisibleItems]];
    
    //  从reuseableItems 中取出一个可用的item,并添加到keyedVisibleItems,再显示到界面
    [visibleItemIndexes enumerateIndexesUsingBlock: ^(NSUInteger idx, BOOL *stop) {
        LZGridViewItem *viewController = (LZGridViewItem *)[self reusableItemForGridView:self inSection:0];
        if (viewController) {
            viewController.index = idx;
            if (isInitialCall) {
                [[viewController view] setFrame:[self rectForItemAtIndex:idx]];
                [[viewController view] setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
            }
            [self gridView:self willShowViewController:viewController itemAtIndex:idx];
            [keyedVisibleItems setObject:viewController forKey:@(viewController.index)];
            [self addSubview:[viewController view]];
        }
    }];
}

- (void)arrangeGridViewItemsAnimated:(BOOL)animated
{
    // on initial call (aka application startup) we will fade all items (after loading it) in
    if (isInitialCall && [keyedVisibleItems count] > 0) {
        isInitialCall = NO;
        
        [[NSAnimationContext currentContext] setDuration:0.35];
        [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
            [keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, LZGridViewItem *item, BOOL *stop) {
                [[item.view animator] setAlphaValue:1.0];
            }];
        } completionHandler:nil];
    }
    else if ([keyedVisibleItems count] > 0) {
        [[NSAnimationContext currentContext] setDuration:(animated ? 0.15 : 0.0)];
        [NSAnimationContext runAnimationGroup: ^(NSAnimationContext *context) {
            [keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, LZGridViewItem *item, BOOL *stop) {
                NSRect newRect = [self rectForItemAtIndex:item.index];
                [[item.view animator] setFrame:newRect];
            }];
        } completionHandler:nil];
    }
}


- (void)refreshGridViewAnimated:(BOOL)animated initialCall:(BOOL)initialCall
{
    isInitialCall = initialCall;
    
    CGSize size = self.frame.size;
    CGFloat newHeight = [self allOverRowsInGridView] * self.itemBoundSize.height;

    if (ABS(newHeight - size.height) > 1) {
        size.height = newHeight;
        [super setFrameSize:size];
    }
    
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf updateReuseableItems];
        [wSelf updateVisibleItems];
        [wSelf arrangeGridViewItemsAnimated:animated];
    });
}

- (NSRange)visibleItemRange
{
    NSRect clippedRect  = [self clippedRect];
    NSUInteger columns  = [self visibleColumnsInGridView];
    NSUInteger rows     = [self visibleRowsInGridView];
    
    CGFloat H = self.itemBoundSize.height;
    
    NSUInteger rangeStart = 0;
    if (clippedRect.origin.y > H) {
        rangeStart = (ceilf(clippedRect.origin.y / H) * columns) - columns;
    }
    NSUInteger rangeLength = MIN(numberOfItems, (columns * rows) + columns);
    rangeLength = ((rangeStart + rangeLength) > numberOfItems ? numberOfItems - rangeStart : rangeLength);
    
    NSRange rangeForVisibleRect = NSMakeRange(rangeStart, rangeLength);
    return rangeForVisibleRect;
}

- (NSIndexSet *)indexesForVisibleItems
{
    __block NSMutableIndexSet *indexesForVisibleItems = [[NSMutableIndexSet alloc] init];
    [keyedVisibleItems enumerateKeysAndObjectsUsingBlock: ^(id key, LZGridViewItem *item, BOOL *stop) {
        [indexesForVisibleItems addIndex:item.index];
    }];
    return indexesForVisibleItems;
}

- (NSRect)rectForItemAtIndex:(NSUInteger)index
{
    NSUInteger columns = [self visibleColumnsInGridView];
    
    CGFloat x = (index % columns) * self.itemBoundSize.width + self.contentInset;
    CGFloat y = (index / columns) * self.itemBoundSize.height + self.contentInset;
    
    NSRect itemRect = NSMakeRect(x,
                                 y,
                                 self.itemSize.width,
                                 self.itemSize.height);
    return itemRect;
}

- (NSUInteger)allOverRowsInGridView
{
    NSUInteger allOverRows = ceilf((float)numberOfItems / [self visibleColumnsInGridView]);
    return allOverRows;
}

- (NSUInteger)visibleColumnsInGridView
{
    NSRect visibleRect  = [self clippedRect];
    CGFloat W = self.itemBoundSize.width;
    NSUInteger columns = floorf((float)NSWidth(visibleRect) / W);
    columns = (columns < 1 ? 1 : columns);
    return columns;
}

- (NSUInteger)visibleRowsInGridView
{
    NSRect visibleRect  = [self clippedRect];
    CGFloat H = self.itemBoundSize.height;
    
    NSUInteger visibleRows = ceilf((float)NSHeight(visibleRect) / H);
    return visibleRows;
}

- (NSRect)clippedRect
{
    return [[[self enclosingScrollView] contentView] bounds];
}


- (NSArray *)selectedItems
{
    return [selectedItems allValues];
}

- (NSIndexSet *)selectedIndexes
{
    NSMutableIndexSet *mutableIndex = [NSMutableIndexSet indexSet];
    for (LZGridViewItem *gridItem in[self selectedItems]) {
        [mutableIndex addIndex:gridItem.index];
    }
    return mutableIndex;
}

#pragma mark - NSView

- (BOOL)isFlipped
{
    return YES;
}

#pragma mark - CNGridView DataSource Calls

- (NSUInteger)gridView:(LZGridView *)gridView numberOfItemsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource gridView:gridView numberOfItemsInSection:section];
    }
    return NSNotFound;
}

- (NSViewController *)reusableItemForGridView:(LZGridView *)gridView inSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource reusableItemForGridView:gridView inSection:section];
    }
    return nil;
}

- (void)gridView:(LZGridView *)gridView willShowViewController:(NSViewController *)viewController itemAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource gridView:gridView willShowViewController:viewController itemAtIndex:index];
    }
}

- (NSUInteger)numberOfSectionsInGridView:(LZGridView *)gridView
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource numberOfSectionsInGridView:gridView];
    }
    return NSNotFound;
}

- (NSViewController *)reusableHeaderForGridView:(LZGridView *)gridView inSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource reusableHeaderForGridView:gridView inSection:section];
    }
    return nil;
}

@end
