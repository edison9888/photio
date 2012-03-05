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
    __weak NSArray*         items;
}

@property (nonatomic, weak)     NSArray*        items;

+ (id)withFrame:(CGRect)_rect andItems:(NSArray*)_items;
- (id)initWithFrame:(CGRect)_frame andItems:(NSArray*)_items;

@end
