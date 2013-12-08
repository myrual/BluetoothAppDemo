//
//  cryptolaliaCBService.m
//  tableview
//
//  Created by li lin on 12/7/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "cryptolaliaCBService.h"
#import "bleCenterManager.h"
@implementation cryptolaliaCBService

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
        // TODO: Undocumented what PnP characteristic address is. Stubbing here for now.
        //[self addCharacteristic:@"pnpid_data" withAddress:kSensorTag_DEVINFO_PNPID_DATA];
        [self addCharacteristic:KEY_PIN withAddress:kSensorTag_TEST_DATA];
    }
    
    return self;
}

- (void)readDeviceInfo {
    NSLog(@"I am reading out data from 3334");
    YMSCBCharacteristic *system_idCt = self.characteristicDict[KEY_WORD];
    __weak cryptolaliaCBService *this = self;
    unsigned char toWrite[9] = {0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99};
    [system_idCt writeValue:[NSData dataWithBytes:toWrite length:1] withBlock:^(NSError *error) {
        if (error) {
            NSLog(@"ERROR with %@", error);
        } else {
            NSLog(@"GOD");
        }
        [system_idCt readValueWithBlock:^(NSData *data, NSError *error) {
            
            
            NSMutableString *tmpString = [NSMutableString stringWithFormat:@""];
            unsigned char bytes[data.length];
            [data getBytes:bytes];
            for (int ii = (int)data.length; ii >= 0;ii--) {
                [tmpString appendFormat:@"%02hhx",bytes[ii]];
                if (ii) {
                    [tmpString appendFormat:@":"];
                }
            }
            
            NSLog(@"readout word %@", tmpString);
            
            _YMS_PERFORM_ON_MAIN_THREAD(^{
                this.word = tmpString;
            });
        }];
        
        
    }];
}
@end
