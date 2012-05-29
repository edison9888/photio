//
//  ImageFilterPaletteCell.m
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageFilterPaletteCell.h"
#import "FilterPalette.h"

@implementation ImageFilterPaletteCell

@synthesize filterPaletteIcon, filterPaletteLabel, filterPalette;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
