//
//  cryptolaliaInputPin.h
//  tableview
//
//  Created by li lin on 12/2/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMSCBPeripheral.h"
@interface cryptolaliaInputPin : UIViewController
@property (nonatomic, strong) YMSCBPeripheral *bleDevice;
@property (nonatomic, strong) YMSCBService    *verifyPin;
@property (nonatomic, strong) NSArray *serviceUUIDs;
@end
