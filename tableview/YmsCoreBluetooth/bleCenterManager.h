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

#define kSensorTag_BASE_ADDRESS_HI 0xF000000004514000
#define kSensorTag_BASE_ADDRESS_LO 0xB000000000000000
#define kSensorTag_GAP_SERVICE_UUID        0x1800
#define kSensorTag_GATT_SERVICE_UUID       0x1801
#define kSensorTag_DEVINFO_SERV_UUID       0x180A

#define kSensorTag_DEVINFO_SYSTEM_ID       0x2A23
#define kSensorTag_DEVINFO_MODEL_NUMBER    0x2A24
#define kSensorTag_DEVINFO_SERIAL_NUMBER   0x2A25
#define kSensorTag_DEVINFO_FIRMWARE_REV    0x2A26
#define kSensorTag_DEVINFO_HARDWARE_REV    0x2A27
#define kSensorTag_DEVINFO_SOFTWARE_REV    0x2A28
#define kSensorTag_DEVINFO_MANUFACTURER_NAME 0x2A29
#define kSensorTag_DEVINFO_11073_CERT_DATA 0x2A2A
/*
 * TODO: Data sheet shows that PnPID address is equal to 11083_CERT_DATA.
 * Belive this is in error.
 */
#define kSensorTag_DEVINFO_PNPID_DATA      0x2A2A

#define kSensorTag_SIMPLEKEYS_SERVICE      0xFFE0
#define kSensorTag_SIMPLEKEYS_DATA         0xFFE1

#define kSensorTag_TEMPERATURE_SERVICE     0xAA00
#define kSensorTag_TEMPERATURE_DATA        0xAA01
#define kSensorTag_TEMPERATURE_CONFIG      0xAA02

#define kSensorTag_ACCELEROMETER_SERVICE   0xAA10
#define kSensorTag_ACCELEROMETER_DATA      0xAA11
#define kSensorTag_ACCELEROMETER_CONFIG    0xAA12
#define kSensorTag_ACCELEROMETER_PERIOD    0xAA13

#define kSensorTag_HUMIDITY_SERVICE        0xAA20
#define kSensorTag_HUMIDITY_DATA           0xAA21
#define kSensorTag_HUMIDITY_CONFIG         0xAA22

#define kSensorTag_MAGNETOMETER_SERVICE    0xAA30
#define kSensorTag_MAGNETOMETER_DATA       0xAA31
#define kSensorTag_MAGNETOMETER_CONFIG     0xAA32
#define kSensorTag_MAGNETOMETER_PERIOD     0xAA33

#define kSensorTag_BAROMETER_SERVICE       0xAA40
#define kSensorTag_BAROMETER_DATA          0xAA41
#define kSensorTag_BAROMETER_CONFIG        0xAA42
#define kSensorTag_BAROMETER_CALIBRATION   0xAA43


#define kSensorTag_GYROSCOPE_SERVICE       0xAA50
#define kSensorTag_GYROSCOPE_DATA          0xAA51
#define kSensorTag_GYROSCOPE_CONFIG        0xAA52

#define kSensorTag_TEST_SERVICE            0x3333
#define kSensorTag_VERIFYPIN_SERVICE       kSensorTag_TEST_SERVICE
#define kSensorTag_TEST_DATA               0x3334
#define kSensorTag_VALUE1               0x4444
#define kSensorTag_VALUE2               0x5555
#define kSensorTag_READCONTENT_SERVICE     0x3335
#define kSensorTag_READCONTENT_CHAR        0x3336
@end
