//
//  ListViewItem.m
//  CustomControl
//
//  Created by liww on 2014/12/2.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ListViewItem.h"
#import "LZListView.h"

#define DefaultListViewItemRowHeight 30.0

static NSImage *prepareStateImage = nil;
static NSImage *startStateImage = nil;
static NSImage *successStateImage = nil;
static NSImage *failStateImage = nil;
static NSImage *abortStateImage = nil;

@implementation ListViewItem
@synthesize itemType = _itemType;
@synthesize itemHeight = _itemHeight;
@synthesize text = _text;
@synthesize stateImage = _stateImage;
@synthesize state = _state;

- (id)init
{
    self = [super init];
    if (self) {
        _itemType = ListViewItemType_None;
        _itemHeight = DefaultListViewItemRowHeight;
        _text = nil;
        _stateImage = nil;
        _state = EraserState_None;
    }
    return self;
}

- (void)dealloc
{
    [_text release]; _text = nil;
    [_stateImage release]; _stateImage = nil;
    [super dealloc];
}

@end


@interface ListViewItemMgr ()
@end

@implementation ListViewItemMgr
+ (void)initialize
{
    NSString *prepareStateImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"PrepareStateImage" ofType:@"png"];
    NSString *startStateImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"StartStateImage" ofType:@"gif"];
    NSString *successStateImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"SuccessStateImage" ofType:@"png"];
    NSString *failStateImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FailStateImage" ofType:@"png"];
    NSString *abortStateImagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FailStateImage" ofType:@"png"];
    
    prepareStateImage = [[NSImage alloc] initWithContentsOfFile:prepareStateImagePath];
    startStateImage = [[NSImage alloc] initWithContentsOfFile:startStateImagePath];
    successStateImage = [[NSImage alloc] initWithContentsOfFile:successStateImagePath];
    failStateImage = [[NSImage alloc] initWithContentsOfFile:failStateImagePath];
    abortStateImage = [[NSImage alloc] initWithContentsOfFile:abortStateImagePath];
}

- (id)init
{
    return [self initWithItemType:nil listView:nil];
}

- (void)dealloc
{
    [_items release]; _items = nil;
    [_itemsDic release]; _itemsDic = nil;
    [_listView release]; _listView = nil;
    [super dealloc];
}

- (id)initWithItemType:(NSArray *)itemTypes listView:(LZListView *)listView
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        _itemsDic = [[NSMutableDictionary alloc] init];
        _listView = [listView retain];
        for (NSNumber *type in itemTypes) {
            ListViewItem *item = [[ListViewItem alloc] init];
            [item setItemType:[type intValue]];
            [_itemsDic setObject:item forKey:type];
            [_items addObject:item];
            [item release]; item = nil;
        }
    }
    
    return self;
}

- (NSArray *)items
{
    return _items;
}

- (NSInteger)itemCount
{
    return [_items count];
}

- (ListViewItem *)itemAtIndex:(NSInteger)index
{
    if (index < 0) {
        return nil;
    }
    return [_items objectAtIndex:index];
}

- (NSInteger)indexOfItem:(ListViewItem *)item
{
    if (item == nil) {
        return -1;
    }
    
    return [_items indexOfObject:item];
}

- (CGFloat)heightForType:(ListViewItemType)type
{
    if (type == ListViewItemType_None) {
        return 0.0;
    }
    
    ListViewItem *item = [_itemsDic objectForKey:[NSNumber numberWithInteger:type]];
    if (item == nil) {
        return 0.0;
    }
    return [item itemHeight];
}

- (void)setText:(NSString *)text
          state:(EraserState)state
        forType:(ListViewItemType)type
       isReload:(BOOL)isReload
{
    if (type == ListViewItemType_None) {
        return;
    }
    ListViewItem *item = [_itemsDic objectForKey:[NSNumber numberWithInteger:type]];
    if (item) {
        @synchronized(_itemsDic){
            [item setText:text];
            [item setStateImage:[self _imageForState:state]];
            [item setState:state];
        }
        
        if (isReload) {
            [_listView reloadItemAtIndex:[self indexOfItem:item]];
        }
    }
}

- (void)setState:(EraserState)state forType:(ListViewItemType)type isReload:(BOOL)isReload
{
    if (type == ListViewItemType_None) {
        return;
    }
    ListViewItem *item = [_itemsDic objectForKey:[NSNumber numberWithInteger:type]];
    if (item) {
        @synchronized(_itemsDic){
            [item setStateImage:[self _imageForState:state]];
            [item setState:state];
        }
        
        if (isReload) {
            [_listView reloadItemAtIndex:[self indexOfItem:item]];
        }
    }
}

- (void)setText:(NSString *)text forType:(ListViewItemType)type isReload:(BOOL)isReload
{
    if (type == ListViewItemType_None) {
        return;
    }
    ListViewItem *item = [_itemsDic objectForKey:[NSNumber numberWithInteger:type]];
    if (item) {
        @synchronized(_itemsDic){
            [item setText:text];
        }
        
        if (isReload) {
            [_listView reloadItemAtIndex:[self indexOfItem:item]];
        }
    }
}

- (void)resetItemState
{
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ListViewItem *item = (ListViewItem *)obj;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (item.state == EraserState_Prepare) {
                [item setStateImage:nil];
                [_listView reloadItemAtIndex:[self indexOfItem:item]];
            }
            else if (item.state == EraserState_Start){
                [item setStateImage:[self _imageForState:EraserState_Fail]];
                [_listView reloadItemAtIndex:[self indexOfItem:item]];
            }
        });
    }];
}

- (void)insertItem:(ListViewItem *)item atIndex:(NSInteger)index
{
    [_itemsDic setObject:item forKey:[NSNumber numberWithInteger:item.itemType]];
    [_items insertObject:item atIndex:index];
    [_listView reloadData];
}

- (void)addItem:(ListViewItem *)item
{
    [_items addObject:item];
    [_listView reloadData];
}

- (void)removeItem:(ListViewItem *)item
{
    [_items removeObject:item];
    [_listView reloadData];
}

- (NSImage *)_imageForState:(EraserState)state
{
    NSImage *image = nil;
    switch (state) {
        case EraserState_Prepare:
            image = prepareStateImage;
            break;
        case EraserState_Start:
            image = startStateImage;
            break;
        case EraserState_Success:
            image = successStateImage;
            break;
        case EraserState_Fail:
            image = failStateImage;
            break;
        case EraserState_Abort:
            image = abortStateImage;
            break;
            
        default:
            break;
    }
    return image;
}

@end