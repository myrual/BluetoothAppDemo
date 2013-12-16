//
//  DeviceInfoService.m
//  tableview
//
//  Created by li lin on 12/16/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "DeviceInfoService.h"
#import "bleCenterManager.h"
#import "YMSCBCharacteristic.h"

@implementation DeviceInfoService
- (instancetype)initWithName:(NSString *)oName
                      parent:(YMSCBPeripheral *)pObj
                      baseHi:(int64_t)hi
                      baseLo:(int64_t)lo
               serviceOffset:(int)serviceOffset {
    
    self = [super initWithName:oName
                        parent:pObj
                        baseHi:hi
                        baseLo:lo
                 serviceOffset:serviceOffset];
    
    if (self) {
        [self addCharacteristic:@"model_number" withAddress:kSensorTag_DEVINFO_MODEL_NUMBER];
        [self addCharacteristic:@"firmware_rev" withAddress:kSensorTag_DEVINFO_FIRMWARE_REV];
        [self addCharacteristic:@"software_rev" withAddress:kSensorTag_DEVINFO_SOFTWARE_REV];
        [self addCharacteristic:@"manufacturer_name" withAddress:kSensorTag_DEVINFO_MANUFACTURER_NAME];
    }
    
    return self;
}




- (void)readDeviceInfo {
    
    DeviceInfoService *this = self;
    
    YMSCBCharacteristic *model_numberCt = self.characteristicDict[@"model_number"];
    [model_numberCt readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
            return;
        }
        
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
        NSLog(@"model number: %@", payload);
        _YMS_PERFORM_ON_MAIN_THREAD(^{
            this.model_number = payload;
        });
    }];

    
    
    YMSCBCharacteristic *firmware_revCt = self.characteristicDict[@"firmware_rev"];
    [firmware_revCt readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
            return;
        }
        
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
        NSLog(@"firmware rev: %@", payload);
        _YMS_PERFORM_ON_MAIN_THREAD(^{
            this.firmware_rev = payload;
        });
        
    }];

    
    YMSCBCharacteristic *software_revCt = self.characteristicDict[@"software_rev"];
    [software_revCt readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
            return;
        }
        
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
        NSLog(@"software rev: %@", payload);
        _YMS_PERFORM_ON_MAIN_THREAD(^{
            this.software_rev = payload;
        });
        
    }];
    
    YMSCBCharacteristic *manufacturer_nameCt = self.characteristicDict[@"manufacturer_name"];
    [manufacturer_nameCt readValueWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
            return;
        }
        
        NSString *payload = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
        NSLog(@"manufacturer name: %@", payload);
        _YMS_PERFORM_ON_MAIN_THREAD(^{
            this.manufacturer_name = payload;
        });
        
    }];    
}

@end
