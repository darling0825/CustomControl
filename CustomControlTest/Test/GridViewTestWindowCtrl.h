//
//  GridViewTestWindowCtrl.h
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZCollectionView.h"

@class CircleLayout;
@class LZCollectionViewGridLayout;
@class LZCollectionViewFlowLayout;

@interface GridViewTestWindowCtrl : NSWindowController<LZCollectionViewDataSource,LZCollectionViewDelegate>{
    
    IBOutlet LZCollectionView   *_collectionView;
    
    CircleLayout                *_circleLayout;
    LZCollectionViewGridLayout  *_gridLayout;
    LZCollectionViewFlowLayout  *_flowLayout;
    
    NSMutableArray              *_sections;
    NSMutableArray              *_items1;
    NSMutableArray              *_items2;
    NSMutableArray              *_items3;
}

@end
