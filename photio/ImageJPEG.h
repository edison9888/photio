//
//  ImageJPEG.h
//  photio
//
//  Created by Troy Stribling on 6/26/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ImageJPEG : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSNumber * imageId;

@end
