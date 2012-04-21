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
}

@property (nonatomic, strong) NSArray*  items;

+ (id)withFrame:(CGRect)_rect andItems:(NSArray*)_items;
- (id)initWithFrame:(CGRect)_frame andItems:(NSArray*)_items;

@end
