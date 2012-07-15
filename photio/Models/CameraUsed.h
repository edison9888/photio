//
//  CameraUsed.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Camera, CameraUsed;

@interface CameraUsed : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * autoAdjusted;
@property (nonatomic, retain) Camera *camera;
@property (nonatomic, retain) CameraUsed *capture;

@end
