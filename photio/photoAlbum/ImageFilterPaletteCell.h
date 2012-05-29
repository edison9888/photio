//
//  ImageFilterPaletteCell.h
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterFactory.h"

@class FilterPalette;

@interface ImageFilterPaletteCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView*  filterPaletteIcon;
@property(nonatomic, strong) IBOutlet UILabel*      filterPaletteLabel;
@property(nonatomic, strong) FilterPalette*         filterPalette;
@end
