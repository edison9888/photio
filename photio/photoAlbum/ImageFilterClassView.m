//
//  ImageFilterClassView.m
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageFilterClassView.h"
#import "ImageFilterClassCell.h"
#import "ImageEditView.h"
#import "UITableViewCell+Extensions.h"
#import "UIView+Extensions.h"
#import "FilterFactory.h"

#define IMAGE_FILTER_CLASS_TABEL_CELL_HEIGHT    70.0
#define FILTER_CLASS_VIEW_ANIMATION_DURATION    0.3
#define EDIT_VIEW_ANIMATION_DURATION            0.2

@interface ImageFilterClassView (PrivayeAPI)

- (void)showView;
- (void)hideView;

@end

@implementation ImageFilterClassView

@synthesize imageEditView, filterClasses;

#pragma mark -
#pragma mark ImageFilterClassView (PrivateAPI)

- (void)showView {
    CGRect controlViewRect = self.imageEditView.controlContainerView.frame;
    CGRect filterViewRect = self.imageEditView.filterContainerView.frame;
    __block CGRect oldFrame = self.frame;
    __block CGRect newcontrolViewRect = CGRectMake(controlViewRect.origin.x, -controlViewRect.size.height, controlViewRect.size.width, controlViewRect.size.height);
    __block CGRect newfilterlViewRect = CGRectMake(filterViewRect.origin.x, oldFrame.size.height, filterViewRect.size.width, filterViewRect.size.height);
    self.frame = CGRectMake(oldFrame.origin.x, - oldFrame.size.height, oldFrame.size.width, oldFrame.size.height);
    [UIView animateWithDuration:EDIT_VIEW_ANIMATION_DURATION
         delay:0
         options:UIViewAnimationOptionCurveLinear
         animations:^{
             self.imageEditView.controlContainerView.frame = newcontrolViewRect;
             self.imageEditView.filterContainerView.frame = newfilterlViewRect;
         } 
         completion:^(BOOL _finished) {
             [UIView animateWithDuration:FILTER_CLASS_VIEW_ANIMATION_DURATION
                 delay:0
                 options:UIViewAnimationOptionCurveEaseOut
                 animations:^{
                      self.frame = CGRectMake(0.0, 0.0, oldFrame.size.width, oldFrame.size.height);
                } 
                completion:^(BOOL _finished) {
                }
            ];
         }
     ];
}

- (void)hideView {
    CGRect controlViewRect = self.imageEditView.controlContainerView.frame;
    CGRect filterViewRect = self.imageEditView.filterContainerView.frame;
    __block CGRect oldFrame = self.frame;
    __block CGRect newcontrolViewRect = CGRectMake(controlViewRect.origin.x, 0.0, controlViewRect.size.width, controlViewRect.size.height);
    __block CGRect newfilterlViewRect = CGRectMake(filterViewRect.origin.x, oldFrame.size.height - filterViewRect.size.height, filterViewRect.size.width, filterViewRect.size.height);
    [UIView animateWithDuration:FILTER_CLASS_VIEW_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.frame = CGRectMake(oldFrame.origin.x, -oldFrame.size.height, oldFrame.size.width, oldFrame.size.height);
        } 
        completion:^(BOOL _finished) {
            [self removeFromSuperview];
            [UIView animateWithDuration:EDIT_VIEW_ANIMATION_DURATION
                animations:^{
                    self.imageEditView.controlContainerView.frame = newcontrolViewRect;
                    self.imageEditView.filterContainerView.frame = newfilterlViewRect;
                } 
                completion:^(BOOL _finished) {
                }
             ];    
        }
     ];    
}

#pragma mark -
#pragma mark ImageFilterClassView

+ (id)initInView:(ImageEditView*)_imageEditView {
    ImageFilterClassView* filterClassView = (ImageFilterClassView*)[UIView loadView:[self class]]; 
    filterClassView.imageEditView = _imageEditView;
    return filterClassView;
}

#pragma mark -
#pragma mark UIView

- (id)initWithCoder:(NSCoder*)_coder { 
    self = [super initWithCoder:_coder];
    if (self) {
    }
    return self;
}

- (void)didMoveToSuperview {
    self.filterClasses = [[FilterFactory instance] filterClasses];
    [self showView];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return IMAGE_FILTER_CLASS_TABEL_CELL_HEIGHT;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filterClasses count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    ImageFilterClassCell* cell = (ImageFilterClassCell*)[UITableViewCell loadCell:[ImageFilterClassCell class]];
    NSDictionary* filterClassInfo = [self.filterClasses objectAtIndex:indexPath.row];
    cell.filterClassIcon.image = [UIImage imageNamed:[filterClassInfo objectForKey:@"imageFilename"]];
    cell.filterClassLabel.text = [filterClassInfo objectForKey:@"name"];
    cell.filterClass = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    NSDictionary* filterClassInfo = [self.filterClasses objectAtIndex:indexPath.row];
    self.imageEditView.imageFilterClassView.image = [UIImage imageNamed:[filterClassInfo objectForKey:@"imageFilename"]];
    self.imageEditView.displayedFilterClass = indexPath.row;
    [self hideView];
}

@end
