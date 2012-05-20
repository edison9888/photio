//
//  ImageFilterClassCell.h
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterFactory.h"

@interface ImageFilterClassCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView*  filterClassIcon;
@property(nonatomic, strong) IBOutlet UILabel*      filterClassLabel;
@property(nonatomic, assign) FilterClass            filterClass;
@end
