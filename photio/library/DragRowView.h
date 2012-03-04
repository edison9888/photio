//
//  DragRowView.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DragGridView;

@interface DragRowView : UIView {
    __weak DragGridView*            gridView;
    NSArray*                        items;
}

@property (nonatomic, weak)   DragGridView*     gridView;
@property (nonatomic, retain) NSArray*          items;

+ (id)withFrame:(CGRect)_rect inGridView:(DragGridView*)_gridView withItems:(NSArray*)_items;
- (id)initWithFrame:(CGRect)frame inGridView:(DragGridView*)_gridView withItems:(NSArray*)_items;

@end
