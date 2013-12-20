//
//  cryptolaliaManager.h
//  tableview
//
//  Created by li lin on 12/20/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface cryptolaliaManager : NSObject


+(void) scanDevicewithID:(NSString *) deviceID didDiscover:(void (^)(CBPeripheral *, NSDictionary *, NSNumber *))discovered didFail:(void(^)(NSError *))fail;
+(void) stopScan;
-(void) connect:(CBPeripheral *)device didConnect:(void (^)(void))success failBlock:(void(^)(NSError *))fail;
-(void) disConnect:(CBPeripheral *)device;
-(void) verifyPinWith:(NSString *)pin successBlock:(void (^)(void))success failBlock:(void (^)(void))fail;
-(void) readContentSuccess: (void(^)(NSString *))success failBlock:(void(^)(NSError *))fail;
-(void) updateContentWith:(NSString *)content successBlock:(void (^)(void))success failBlock:(void(^)(NSError *))fail;
-(void) updatePinWith:(NSString *)newPin successBlock:(void (^)(void))success failBlock:(void(^)(NSError *))fail;
@end
