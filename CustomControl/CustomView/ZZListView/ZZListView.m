//
//  ZZListView.m
//  CustomControl
//
//  Created by liww on 2014/12/1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ZZListView.h"

#define KeyListViewItemIndex          @"ItemIndex"
#define KeyListViewItemFrame          @"ItemFrame"

@interface ZZListViewCell ()
@property (nonatomic, copy) NSString *reuseIdentifier;
@end

@implementation ZZListView
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
- (id)init
{
    self = [super init];
    if (self) {
        [self setupDefaults];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDefaults];
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
    _keyedVisibleItems          = [[NSMutableDictionary alloc] init];
    _reuseableItems             = [[NSMutableDictionary alloc] init];
    _classIdentifiers           = [[NSMutableDictionary alloc] init];
    _itemAttributes             = [[NSMutableDictionary alloc] init];
    _keyedVisibleItemAttributes = [[NSMutableDictionary alloc] init];
    
    _itemIndexs                 = [[NSMutableArray alloc] init];
    
    _numberOfItems              = 0;
    
    _isInitialCall              = YES;
    
    _delegate                   = nil;
    _dataSource                 = nil;
    
    [[self enclosingScrollView] setDrawsBackground:YES];
    NSClipView *clipView = [[self enclosingScrollView] contentView];
    [clipView setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_scrollViewDidScroll)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:clipView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_viewDidResize)
                                                 name:NSViewFrameDidChangeNotification
                                               object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_keyedVisibleItems release];
    [_reuseableItems release];
    [_classIdentifiers release];
    [_itemAttributes release];
    [_keyedVisibleItemAttributes release];
    [_itemIndexs release];
    
    [super dealloc];
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [_classIdentifiers setObject:cellClass forKey:identifier];
}

- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                    forIndex:(NSInteger)index
{
    ZZListViewCell *reusableCell = nil;
    NSMutableSet *reuseQueue = [_reuseableItems objectForKey:identifier];
    if (reuseQueue != nil && [reuseQueue count] > 0) {
        reusableCell = [[reuseQueue anyObject] retain];
        [reuseQueue removeObject:reusableCell];
        [_reuseableItems setObject:reuseQueue forKey:identifier];
    }
    else{
        reusableCell = [[[_classIdentifiers objectForKey:identifier] alloc] init];
        reusableCell.reuseIdentifier = identifier;
    }
    return [reusableCell autorelease];
}

- (NSInteger)numberOfItems
{
    return _numberOfItems;
}

- (NSInteger)indexForCell:(ZZListViewCell *)cell
{
    __block NSInteger index = -1;
    [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([cell isEqual:(ZZListViewCell *)obj]) {
            index = [(NSNumber *)key integerValue];
            *stop = YES;
        } ;
    }];
    return index;
}

- (ZZListViewCell *)cellForItemAtIndex:(NSInteger)index
{
    ZZListViewCell *cell = [_keyedVisibleItems objectForKey:[NSNumber numberWithInteger:index]];
    if ([cell isKindOfClass:[ZZListViewCell class]]) {
        return cell;
    }
    return nil;
}

- (NSArray *)indexsForVisibleItems
{
    return [_keyedVisibleItems allKeys];
}

- (void)reloadData
{
    __unsafe_unretained ZZListView *wSelf = self;
    //dispatch_async(dispatch_get_main_queue(), ^{
        _isInitialCall = YES;
        
        _numberOfItems = [wSelf numberOfItemsInListView:wSelf];
        
        [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            ZZListViewCell *cell = (ZZListViewCell *)obj;
            [cell.view removeFromSuperview];
        }];
        
        [_keyedVisibleItems removeAllObjects];
        [_reuseableItems removeAllObjects];
        
        [wSelf refreshCollectionView];
        
        _isInitialCall = NO;
    //});
}

- (void)reloadItemAtIndex:(NSInteger)index
{
    __unsafe_unretained ZZListView *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([wSelf _isVisibleForIndex:index]) {
            [wSelf updateReuseableItemAtIndex:index];
            [wSelf updateVisibleItemAtIndex:index];
        }
    });
}

- (void)setNeedsDisplay
{
    [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSInteger index = [(NSNumber *)key integerValue];
        ZZListViewCell *cell = (ZZListViewCell *)obj;
        [self listView:self willDisplayCell:cell forItemAtIndex:index];
        [cell.view setNeedsDisplay:YES];
    }];
}

- (void)refreshCollectionView
{
    [self _prepareLayout];
    [self updateVisibleRect];
}

- (void)updateVisibleRect
{
    NSLog(@">>> %@",NSStringFromSelector(_cmd));
    //__unsafe_unretained ZZListView *wSelf = self;
    //dispatch_async(dispatch_get_main_queue(), ^{
        
        //  当前可见范围
        NSMutableArray *visibleItemindexPaths = [[self _updateIndexPathsForVisibleItems] retain];
        NSArray *lastVisibleItemIndexPaths = [self indexsForVisibleItems];
        
        //  从keyedVisibleItems 中移除不可见的item,并添加到reuseableItems
        [lastVisibleItemIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSNumber *itemKey = (NSNumber *)obj;
            if (![visibleItemindexPaths containsObject:itemKey]) {
                [self updateReuseableItemAtIndex:[itemKey integerValue]];
            }
        }];
        
        //  移除已加载的，只加载未加载的
        [visibleItemindexPaths removeObjectsInArray:lastVisibleItemIndexPaths];
        
        //  从reuseableItems 中取出一个可用的item,并添加到keyedVisibleItems,再显示到界面
        [visibleItemindexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self updateVisibleItemAtIndex:[obj integerValue]];
        }];
        
        [_keyedVisibleItemAttributes removeAllObjects];
        [visibleItemindexPaths release]; visibleItemindexPaths = nil;
    //});
}

- (void)updateReuseableItemAtIndex:(NSInteger)index
{
    ZZListViewCell *cell = [[_keyedVisibleItems objectForKey:[NSNumber numberWithInteger:index]] retain];
    
    if (cell == nil) {
        return;
    }
    
    [cell.view removeFromSuperview];
    [cell prepareForReuse];
    
    [_keyedVisibleItems removeObjectForKey:[NSNumber numberWithInteger:index]];
    
    NSMutableSet *reuseQueue = [_reuseableItems objectForKey:cell.reuseIdentifier];
    if (reuseQueue == nil) {
        reuseQueue = [NSMutableSet set];
    }
    [reuseQueue addObject:cell];
    [_reuseableItems setObject:reuseQueue forKey:cell.reuseIdentifier];
    [cell release]; cell = nil;
}


- (void)updateVisibleItemAtIndex:(NSInteger)index
{
    ZZListViewCell *cell = [[self listView:self cellForItemAtIndex:index] retain];
    if (cell) {
        [cell.view setFrame:[[self layoutAttributesForItemAtIndex:index] frame]];
        [cell.view setAutoresizingMask:NSViewMaxXMargin | NSViewMaxYMargin];
        
        [self listView:self willDisplayCell:cell forItemAtIndex:index];
        [_keyedVisibleItems setObject:cell forKey:[NSNumber numberWithInteger:index]];
        [self addSubview:cell.view];
        [cell release]; cell = nil;
    }
}

#pragma mark Private Helper

- (void)_scrollViewDidScroll
{
    [self updateVisibleRect];
}

- (void)_viewDidResize
{
    if (_isInitialCall) {
        return;
    }
    
    _isInitialCall = YES;
    
    [self _prepareLayout];
    
    __unsafe_unretained ZZListView *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableArray *visibleItemIndexPaths = [[wSelf _updateIndexPathsForVisibleItems] retain];
        NSArray *lastVisibleItemIndexPaths = [wSelf indexsForVisibleItems];
        
        [lastVisibleItemIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [wSelf updateReuseableItemAtIndex:[(NSNumber *)obj integerValue]];
        }];
        
        [visibleItemIndexPaths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [wSelf updateVisibleItemAtIndex:[(NSNumber *)obj integerValue]];
        }];
        
        [_keyedVisibleItemAttributes removeAllObjects];
        [visibleItemIndexPaths release]; visibleItemIndexPaths = nil;
    });
    
    _isInitialCall = NO;
}

- (NSRect)_clippedRect
{
    return [[[self enclosingScrollView] contentView] bounds];
}

- (void)_prepareLayout
{
    [_itemAttributes removeAllObjects];
    [_itemIndexs removeAllObjects];
    
    NSInteger xPosition = 0.0;
    CGFloat yPosition = 0.0;
    
    for (NSInteger index = 0; index < _numberOfItems; index++) {
        
        NSInteger heightOfItem = [self listView:self heightOfRow:index];
        NSInteger widthOfItem = [self _clippedRect].size.width;
        
        NSRect itemFrame = NSMakeRect(xPosition,
                                      yPosition,
                                      widthOfItem,
                                      heightOfItem);
        
        NSDictionary *itemAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInteger:index], KeyListViewItemIndex,
                                       NSStringFromRect(itemFrame), KeyListViewItemFrame, nil];
        
        NSString *itemKey = [NSString stringWithFormat:@"Index-%ld",(long)index];
        [_itemAttributes setObject:itemAttribute forKey:itemKey];
        [_itemIndexs addObject:itemKey];
        
        yPosition += heightOfItem;
    }
    
    NSSize frameSize = [self _clippedRect].size;
    frameSize.height = yPosition;
    [self setFrameSize:frameSize];
}

- (BOOL)_isVisibleForIndex:(NSInteger)index
{
    BOOL isVisible = NO;
    NSString *itemKey = [NSString stringWithFormat:@"Index-%ld",(long)index];
    NSDictionary *itemDic = [_itemAttributes objectForKey:itemKey];
    NSRect itemFrame = NSRectFromString([itemDic objectForKey:KeyListViewItemFrame]);
    
    NSRect visibleRect = [self visibleRect];
    if (NSIntersectsRect(itemFrame,visibleRect)) {
        isVisible = YES;
    }
    return isVisible;
}

- (NSMutableArray *)_updateIndexPathsForVisibleItems
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *attributes = [[self layoutAttributesForElementsInRect:[self visibleRect]] retain];
    
    [attributes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZZListViewLayoutAttributes *attribute = (ZZListViewLayoutAttributes *)obj;
        NSNumber *itemKey = [NSNumber numberWithInteger:attribute.index];
        [_keyedVisibleItemAttributes setObject:attribute forKey:itemKey];
        [result addObject:itemKey];
    }];
    
    [attributes release]; attributes = nil;
    return [result autorelease];
}

#pragma mark Layout Attributes

- (NSArray *)layoutAttributesForElementsInRect:(NSRect)rect
{
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    
    NSInteger midIndex = 0;
    NSInteger startIndex = 0;
    NSInteger endIndex = [_itemIndexs count] - 1;
    
    ZZListViewLayoutAttributes *midAttributes = [[self layoutAttributesForItemAtIndex:midIndex] retain];
    do {
        midIndex = (startIndex + endIndex) / 2;
        NSRect midCellFrame = midAttributes.frame;
        if (NSMaxY(midCellFrame) < NSMinY(rect)) {
            startIndex = midIndex + 1;
        }
        else if (NSMinY(midCellFrame) > NSMaxY(rect)) {
            endIndex = midIndex - 1;
        }
        else{
            ZZListViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndex:midIndex];
            [layoutAttributes addObject:attributes];
            break;
        }
        
        
    }while (startIndex <= endIndex);
    
    [midAttributes release]; midAttributes = nil;
    
    for (NSInteger index = midIndex - 1; index >= startIndex; index--) {
        if ([self _isVisibleForIndex:index]) {
            ZZListViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndex:index];
            [layoutAttributes addObject:attributes];
        }
        else{
            break;
        }
    }
    
    for (NSInteger index = midIndex + 1; index <= endIndex; index++) {
        
        if ([self _isVisibleForIndex:index]) {
            ZZListViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndex:index];
            [layoutAttributes addObject:attributes];
        }
        else{
            break;
        }
    }
    
    return [layoutAttributes autorelease];
}

- (ZZListViewLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index
{
    NSString *itemKey = [NSString stringWithFormat:@"Index-%ld",(long)index];
    NSDictionary *itemDic = [_itemAttributes objectForKey:itemKey];
    NSRect itemFrame = NSRectFromString([itemDic objectForKey:KeyListViewItemFrame]);
    
    ZZListViewLayoutAttributes *attributes = [[ZZListViewLayoutAttributes layoutAttributesForCellWithIndex:index] retain];
    
    attributes.frame = itemFrame;
    
    return [attributes autorelease];
}

#pragma mark DataSource and delegate
- (void)listView:(ZZListView *)listView willDisplayCell:(ZZListViewCell *)cell forItemAtIndex:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        [_delegate listView:listView willDisplayCell:cell forItemAtIndex:index];
    }
}

- (CGFloat)listView:(ZZListView *)listView heightOfRow:(NSInteger)index
{
    if (_delegate && [_delegate respondsToSelector:_cmd]) {
        return [_delegate listView:listView heightOfRow:index];
    }
    return 0;
}

- (NSInteger)numberOfItemsInListView:(ZZListView *)listView
{
    if (_dataSource && [_dataSource respondsToSelector:_cmd]) {
        return [_dataSource numberOfItemsInListView:listView];
    }
    return 0;
}

- (ZZListViewCell *)listView:(ZZListView *)listView cellForItemAtIndex:(NSInteger)index
{
    if (_dataSource && [_dataSource respondsToSelector:_cmd]) {
        return [_dataSource listView:listView cellForItemAtIndex:index];
    }
    return nil;
}

@end

@implementation ZZListViewLayoutAttributes
@synthesize frame = _frame;
@synthesize index = _index;

+ (instancetype)layoutAttributesForCellWithIndex:(NSInteger)index
{
    ZZListViewLayoutAttributes *attributes = [[ZZListViewLayoutAttributes alloc] init];
    attributes.index = index;
    return [attributes autorelease];
}

@end