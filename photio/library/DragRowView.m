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

@synthesize items;

#pragma mark -
#pragma mark UIViewController


+ (id)withFrame:(CGRect)_rect andItems:(NSArray*)_items {
    return [[DragRowView alloc] initWithFrame:_rect andItems:(NSArray*)_items];
}

- (id)initWithFrame:(CGRect)_frame andItems:(NSArray*)_items {
    if ((self = [super initWithFrame:_frame])) {
        self.items = _items;
        UIView* firstItem = [self.items objectAtIndex:0];
        CGFloat itemWidth = firstItem.frame.size.width;
        CGFloat itemOffset = (_frame.size.width - itemWidth * [self.items count]) / 2.0;
        for (int i = 0; i < [self.items count]; i++) {
            UIView* itemView = [self.items objectAtIndex:i];
            CGRect newFrame = itemView.frame;
            newFrame.origin.x = itemOffset + itemWidth * i;
            itemView.frame = newFrame;
            [self addSubview:itemView];
       }
    }
    return self;
}

@end
