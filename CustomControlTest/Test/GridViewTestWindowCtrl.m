//
//  GridViewTestWindowCtrl.m
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "GridViewTestWindowCtrl.h"
#import "NSIndexPath+Additions.h"
#import "CircleLayout.h"
#import "LZCollectionViewFlowLayout.h"
#import "LZCollectionViewGridLayout.h"
#import "MyCollectionViewCell.h"
#import "MyCollectionSupplementaryView.h"

static NSString *kContentTitleKey, *kContentImageKey;

@interface GridViewTestWindowCtrl ()

@end

@implementation GridViewTestWindowCtrl

+ (void)initialize
{
    kContentTitleKey = @"itemTitle";
    kContentImageKey = @"itemImage";
}


- (id)init
{
    self = [super initWithWindowNibName:@"GridViewTestWindowCtrl" owner:self];
    if (self) {
        _sections = [[NSMutableArray alloc] init];
        _items1 = [[NSMutableArray alloc] init];
        _items2 = [[NSMutableArray alloc] init];
        _items3 = [[NSMutableArray alloc] init];
        
        _circleLayout = [[CircleLayout alloc] init];
        _gridLayout   = [[LZCollectionViewGridLayout alloc] init];
        _flowLayout   = [[LZCollectionViewFlowLayout alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_sections release]; _sections = nil;
    [_items1 release]; _items1 = nil;
    [_items2 release]; _items2 = nil;
    [_items3 release]; _items3 = nil;
    
    [_circleLayout release]; _circleLayout = nil;
    [_gridLayout release]; _gridLayout = nil;
    [super dealloc];
}

- (void)awakeFromNib
{
    [self createData];
    
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
    [_collectionView registerClass:[MyCollectionSupplementaryView class]
        forSupplementaryViewOfKind:LZCollectionElementKindSectionHeader
               withReuseIdentifier:@"SupplementaryViewIdentifier"];
    [_collectionView registerClass:[MyCollectionSupplementaryView class]
        forSupplementaryViewOfKind:LZCollectionElementKindSectionFooter
               withReuseIdentifier:@"SupplementaryViewIdentifier"];
    
    [_collectionView setBackgroundColor:[NSColor lightGrayColor]];
    [_collectionView setAllowsMultipleSelection:YES];
    [_collectionView setAllowsMultipleSelectionWithDrag:YES];
    
    
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    
    //layout
    [_gridLayout setSectionInset:LZEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_flowLayout setSectionInset:LZEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [_collectionView setCollectionViewLayout:_flowLayout];
    
    [_collectionView reloadData];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (void)createData
{
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"IMG_0202" ofType:@"png"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"DefaultAppIcon" ofType:@"png"];
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"IMG_0309" ofType:@"png"];
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"IMG_0294" ofType:@"png"];
    NSString *path5 = [[NSBundle mainBundle] pathForResource:@"AppIcon" ofType:@"png"];
//    NSImage *image1 = [[NSImage alloc] initWithContentsOfFile:path1];
//    NSImage *image2 = [[NSImage alloc] initWithContentsOfFile:path2];
//    NSImage *image3 = [[NSImage alloc] initWithContentsOfFile:path3];
//    NSImage *image4 = [[NSImage alloc] initWithContentsOfFile:path4];
//    NSImage *image5 = [[NSImage alloc] initWithContentsOfFile:path5];
    NSImage *image1 = [[NSImage imageNamed:@"IMG_0202"] retain];
    NSImage *image2 = [[NSImage imageNamed:@"DefaultAppIcon"] retain];
    NSImage *image3 = [[NSImage imageNamed:@"IMG_0309"] retain];
    NSImage *image4 = [[NSImage imageNamed:@"AppIcon"] retain];
    NSImage *image5 = [[NSImage imageNamed:@"IMG_0294"] retain];
    
    for (int i = 0; i < 200; i++) {
        [_items1 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               image1, kContentImageKey,
                               NSImageNameComputer, kContentTitleKey,
                               nil]];
        [_items2 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               image2, kContentImageKey,
                               NSImageNameNetwork, kContentTitleKey,
                               nil]];
        [_items2 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               image3, kContentImageKey,
                               NSImageNameDotMac, kContentTitleKey,
                               nil]];
        [_items3 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               image4, kContentImageKey,
                               NSImageNameFolderSmart, kContentTitleKey,
                               nil]];
        [_items3 addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               image5, kContentImageKey,
                               NSImageNameBonjour, kContentTitleKey,
                               nil]];
    }
    
    [_sections addObject:_items1];
    [_sections addObject:_items2];
    [_sections addObject:_items3];
    
    [image1 release]; image1 = nil;
    [image2 release]; image2 = nil;
    [image3 release]; image3 = nil;
    [image4 release]; image4 = nil;
    [image5 release]; image5 = nil;
}


#pragma mark
#pragma mark ----------------------- CNGridView DataSource -----------------------
- (NSInteger)collectionView:(LZCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] count];
}


- (LZCollectionViewCell *)collectionView:(LZCollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier"
                                                                           forIndexPath:indexPath];
    
    NSInteger section = indexPath.section;
    NSImage *image = [[[_sections objectAtIndex:section] objectAtIndex:indexPath.item] objectForKey:kContentImageKey];
    NSString *title = [[[_sections objectAtIndex:section] objectAtIndex:indexPath.item] objectForKey:kContentTitleKey];
    
    cell.image = image;
    cell.text = title;
    
    cell.backgroundColor = [NSColor lightGrayColor];
    
    cell.highlightedColor = [NSColor blueColor];
    
    [cell setSelectable:YES];
    [cell setSelectedColor:[NSColor greenColor]];
    
    [cell setItemBorderRadius:10.0];
    [cell setSelectionRingColor:[NSColor redColor]];
    [cell setSelectionRingLineWidth:2];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(LZCollectionView *)collectionView
{
    return [_sections count];
}

- (LZCollectionReusableView *)collectionView:(LZCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionSupplementaryView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                             withReuseIdentifier:@"SupplementaryViewIdentifier"
                                                                                    forIndexPath:indexPath];
    view.image = [NSImage imageNamed:@"AudioIcon"];
    view.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.item];
    
    return view;
}

- (void)collectionView:(LZCollectionView *)collectionView
       willDisplayCell:(LZCollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)collectionView:(LZCollectionView *)collectionView
willDisplaySupplementaryView:(LZCollectionReusableView *)view
        forElementKind:(NSString *)elementKind
           atIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if (section == 0 && item % 2 == 0) {
        return NSMakeSize(50, 50);
    }
    else if (section == 1 && item % 2 == 0) {
        return NSMakeSize(60, 60);
    }
    else if (section == 2 && item % 2 == 0) {
        return NSMakeSize(70, 70);
    }
    
    return NSMakeSize(100, 100);
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section
{
    return NSMakeSize([_collectionView visibleRect].size.width, 30);
}

- (NSSize)collectionView:(LZCollectionView *)collectionView
                  layout:(LZCollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    return NSMakeSize([_collectionView visibleRect].size.width, 30);
}

@end
