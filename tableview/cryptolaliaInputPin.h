//
//  cryptolaliaInputPin.h
//  tableview
//
//  Created by li lin on 12/2/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMSCBPeripheral.h"
#import "cryptolaliaCBService.h"
#import "cryptolaliaReadContent.h"
@interface cryptolaliaInputPin : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) YMSCBPeripheral *bleDevice;
@property (nonatomic, strong) cryptolaliaCBService    *verifyPin;
@property (nonatomic, strong) cryptolaliaReadContent  *readContent;
@property (nonatomic, strong) NSArray *serviceUUIDs;
@end
