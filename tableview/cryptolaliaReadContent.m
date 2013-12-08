//
//  cryptolaliaReadContent.m
//  tableview
//
//  Created by li lin on 12/8/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "cryptolaliaReadContent.h"
#import "bleCenterManager.h"

@implementation cryptolaliaReadContent

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
        [self addCharacteristic:KEY_WORD withAddress:kSensorTag_READCONTENT_CHAR];
    }
    
    return self;
}
@end
