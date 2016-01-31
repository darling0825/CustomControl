//
//  LZGridView.h
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZGridViewDelegate.h"
#import "LZGridViewItem.h"

/**
 `LZGridView` is a (wanna be) replacement for NSCollectionView. It has full delegate and dataSource support with method calls like known from NSTableView/UITableView.
 
 The use of `LZGridView` is just simple as possible.
 */

@interface LZGridView : NSView

#pragma mark - Initializing a CNGridView Object
/** @name Initializing a CNGridView Object */


#pragma mark - Managing the Delegate and the Data Source
/** @name Managing the Delegate and the Data Source */

/**
 Property for the receiver's delegate.
 */
@property (nonatomic, assign) IBOutlet id<LZGridViewDelegate> delegate;

/**
 Property for the receiver's data source.
 */
@property (nonatomic, assign) IBOutlet id<LZGridViewDataSource> dataSource;


/**
 Property for the background color of the grid view.
 
 This color (or pattern image) will be assigned to the enclosing scroll view. In the phase of initializing `CNGridView` will
 send the enclosing scroll view a `setDrawsBackground` message with `YES` as parameter value. So it's guaranteed the background
 will be drawn even if you forgot to set this flag in interface builder.
 
 If you don't use this property, the default value is `[NSColor controlColor]`.
 */
@property (nonatomic, strong) NSColor *backgroundColor;

/**
 Property for setting the elasticity of the enclosing `NSScrollView`.
 
 This property will set and overwrite the values from Interface Builder. There is no horizontal-vertical distinction.
 The default value is `YES`.
 
 @param     YES Elasticity is on.
 @param     NO Elasticity is off.
 
 */
@property (nonatomic, assign) BOOL scrollElasticity;


/** @name Managing Selections */

/**
 Property for setting whether the grid view allows item selection or not.
 
 The default value is `YES`.
 */
@property (nonatomic, assign) BOOL allowsSelection;

/**
 Property that indicates whether the grid view should allow multiple item selection or not.
 
 If you have this property set to `YES` with actually many selected items, all these items will be unselect on setting `allowsMultipleSelection` to `NO`.
 
 @param YES The grid view allows multiple item selection.
 @param NO  The grid view don't allow multiple item selection.
 */
@property (nonatomic, assign) BOOL allowsMultipleSelection;

/**
 Property indicates if the mouse drag operation can be used to select multiple items.
 
 If you have this property set to `YES` you must also set `allowsMultipleSelection`
 
 @param YES The grid view allows multiple item selection with mouse drag.
 @param NO  The grid view don't allow multiple item selection with mouse drag.
 */
@property (nonatomic, assign) BOOL allowsMultipleSelectionWithDrag;

/**
 ...
 */
@property (nonatomic, assign) BOOL useSelectionRing;

/**
 ...
 */
@property (nonatomic, assign) BOOL useHover;


/**
Property for setting the grid view item size.

You can set this property programmatically to any value you want. On each change of this value `CNGridView` will automatically
refresh the entire visible grid view with an animation effect.
*/
@property (nonatomic, assign) NSSize itemSize;
@property (nonatomic, assign) CGFloat contentInset;
@property (nonatomic, assign) NSSize itemBoundSize;

/**
 Returns a reusable grid view item object located by its identifier.
 
 @param identifier  A string identifying the grid view item object to be reused. This parameter must not be nil.
 @return A CNGridViewItem object with the associated identifier or nil if no such object exists in the reusable queue.
 */
- (id)dequeueReusableItemWithIdentifier:(NSString *)identifier;
//- (id)dequeueReusableHeader;

/**
 Returns an array of the selected `CNGridViewSelectItem` items.
 */
- (NSArray *)selectedItems;

/**
 Returns an index set of the selected items
 */
- (NSIndexSet*)selectedIndexes;


#pragma mark - Reloading GridView Data
/** @name  Reloading GridView Data */

/**
 Reloads all the items on the grid from the data source
 */
- (void)reloadData;

- (void)reloadDataAnimated:(BOOL)animated;

@end
