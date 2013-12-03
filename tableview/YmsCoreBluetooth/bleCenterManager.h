//
//  bleCenterManager.h
//  tableview
//
//  Created by li lin on 12/3/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "YMSCBCentralManager.h"

@interface bleCenterManager : YMSCBCentralManager

/**
 Return singleton instance.
 @param delegate UI delegate.
 */
+ (bleCenterManager *)initSharedServiceWithDelegate:(id)delegate;

/**
 Return singleton instance.
 */

+ (bleCenterManager *)sharedService;

@end
