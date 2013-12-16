//
//  cryptolaliaCBService.h
//  tableview
//
//  Created by li lin on 12/7/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "YMSCBService.h"
#import "YMSCBCharacteristic.h"


#define KEY_PIN  @"pin"
#define VALUE_1 @"value1"
#define VALUE_2 @"value2"
#define UPDATE_PIN @"updatepin"

@interface cryptolaliaCBService : YMSCBService
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *pin;

- (void)readDeviceInfo;
@end
