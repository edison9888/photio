//
//  Camera.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CameraUsed;

@interface Camera : NSManagedObject

@property (nonatomic, retain) NSNumber * cameraId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * maximumValue;
@property (nonatomic, retain) NSNumber * minimumValue;
@property (nonatomic, retain) NSNumber * hasParameter;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) NSNumber * hasAutoAdjust;
@property (nonatomic, retain) NSNumber * autoAdjustEnabled;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSNumber * purchased;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) NSNumber * usageRate;
@property (nonatomic, retain) NSSet *cameraUsed;
@end

@interface Camera (CoreDataGeneratedAccessors)

- (void)addCameraUsedObject:(CameraUsed *)value;
- (void)removeCameraUsedObject:(CameraUsed *)value;
- (void)addCameraUsed:(NSSet *)values;
- (void)removeCameraUsed:(NSSet *)values;

@end
