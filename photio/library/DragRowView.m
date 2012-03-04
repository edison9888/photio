//
//  DragRowView.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "DragRowView.h"
#import "DragGridView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DragRowView (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragRowView

@synthesize gridView, items;

#pragma mark -
#pragma mark UIViewController


+ (id)withFrame:(CGRect)_rect inGridView:(DragGridView*)_gridView withItems:(NSArray*)_items {
    return [[DragRowView alloc] initWithFrame:_rect];;
}

- (id)initWithFrame:(CGRect)_frame inGridView:(DragGridView*)_gridView withItems:(NSArray*)_items {
    if ((self = [super initWithFrame:_frame])) {
        self.gridView = _gridView;
        self.items = _items;
        UIView* firstItem = [self.items objectAtIndex:0];
        CGFloat itemWidth = firstItem.frame.size.width;
        for (int i = 0; i < [items count]; i++) {
            UIView* itemView = [self.items objectAtIndex:i];
            CGRect newFrame = itemView.frame;
            newFrame.origin.x = i * itemWidth;
            itemView.frame = newFrame;
            [self addSubview:itemView];
        }
    }
    return self;
}

@end
