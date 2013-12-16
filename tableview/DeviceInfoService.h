//
//  DeviceInfoService.h
//  tableview
//
//  Created by li lin on 12/16/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "YMSCBService.h"

@interface DeviceInfoService : YMSCBService
/** @name Properties */
/// Model Number
@property (nonatomic, strong) NSString *model_number;
/// Serial Number
/// Firmware Revision
@property (nonatomic, strong) NSString *firmware_rev;

/// Software Revision
@property (nonatomic, strong) NSString *software_rev;
/// Manufacturer Name
@property (nonatomic, strong) NSString *manufacturer_name;

/** @name Read Device Information */
/**
 Issue set of read requests to obtain device information which is store in the class properties.
 */
- (void)readDeviceInfo;

@end
