//
//  cryptolaliaViewController.m
//  tableview
//
//  Created by li lin on 12/2/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "cryptolaliaViewController.h"
#import "cryptolaliaInputPin.h"
#import "bleCenterManager.h"
#import "YMSCBService.h"
#import "YMSCBPeripheral.h"
#import "YMSCBCharacteristic.h"
#import "cryptolaliaCBService.h"
#import "cryptolaliaReadContent.h"
#import "DeviceInfoService.h"
@interface cryptolaliaViewController ()
@property (nonatomic, strong) bleCenterManager *manager;
@property (nonatomic, strong) NSMutableArray *bleDeviceArray;
@property (nonatomic, strong) NSMutableArray *bleDeviceADVArray;
@end

@implementation cryptolaliaViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    bleCenterManager *manager = [bleCenterManager initSharedServiceWithDelegate:self];
    self.manager = manager;
    NSMutableArray  *deviceArray = [[NSMutableArray alloc] init];
    self.bleDeviceArray = deviceArray;
    self.bleDeviceADVArray = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.manager startScan];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bleDeviceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    YMSCBPeripheral *bleDevice = [self.bleDeviceArray objectAtIndex:indexPath.row];
    NSDictionary *advDict = [self.bleDeviceADVArray objectAtIndex:indexPath.row];
//    NSString *text = bleDevice.cbPeripheral.name;
    NSString *text = @"";
    NSString *localName = nil;
    localName =[advDict objectForKey:@"kCBAdvDataLocalName"];
    if (localName) {
        cell.textLabel.text = [text stringByAppendingString:localName];
    }else{
        cell.textLabel.text = @"NA localName";
    }
    NSArray *serviceUUID = [advDict objectForKey:@"kCBAdvDataServiceUUIDs"];
    for (CBUUID *uuid in serviceUUID) {
        NSLog(@"found uuid in advertisze with %@", uuid);
    }

    cell.detailTextLabel.text =[bleDevice.cbPeripheral.identifier UUIDString];
//    NSLog(@"device adv data is %@", advDict);
//    NSLog(@"device is %@", [bleDevice.cbPeripheral.identifier UUIDString]);
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    YMSCBPeripheral *CBPeripheral = [self.bleDeviceArray objectAtIndex:indexPath.row];
    if (CBPeripheral.isConnected) {
        YMSCBPeripheral *yp = [self.bleDeviceArray objectAtIndex:indexPath.row];
        cryptolaliaInputPin *detailViewController = [[cryptolaliaInputPin alloc] initWithNibName:@"cryptolaliaInputPin" bundle:nil];
        detailViewController.bleDevice = yp;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else{
        [CBPeripheral connectWithOptions:nil withBlock:^(YMSCBPeripheral *yp, NSError *error){
            NSLog(@"connected with %@ success", yp);
            DeviceInfoService *firmware = [[DeviceInfoService alloc] initWithName:@"deviceInfo" parent:yp baseHi:0 baseLo:0 serviceOffset:kSensorTag_DEVINFO_SERV_UUID];
            cryptolaliaCBService *verifyPinService = [[cryptolaliaCBService alloc] initWithName:@"testConfigService" parent:yp baseHi:0 baseLo:0 serviceOffset:kSensorTag_VERIFYPIN_SERVICE];
            cryptolaliaReadContent *readContent = [[cryptolaliaReadContent alloc] initWithName:@"readContent" parent:yp baseHi:0 baseLo:0 serviceOffset:kSensorTag_READCONTENT_SERVICE];
            NSDictionary *serviceDict = @{@"deviceInfo_Firmware_Service": firmware, @"testConfigService":verifyPinService, @"readContent" : readContent
                                          };
            yp.serviceDict = serviceDict;
            
            [yp discoverServices:[yp services] withBlock:^(NSArray *yservices, NSError *error) {
                if (error) {
                    return;
                }
                cryptolaliaInputPin *detailViewController = [[cryptolaliaInputPin alloc] initWithNibName:@"cryptolaliaInputPin" bundle:nil];
                detailViewController.bleDevice = yp;
                NSLog(@"discover service for %@ success with result %@", [yp services], yservices);
                for (YMSCBService *service in yservices) {
                    if ([service.name isEqualToString:@"testConfigService"]) {
                        cryptolaliaCBService *thisService = (cryptolaliaCBService *)service;
                        detailViewController.verifyPin = thisService;
                        NSLog(@"found test data with uuid %@", thisService.cbService.UUID);
                        [thisService discoverCharacteristics:[thisService characteristics] withBlock:^(NSDictionary *chDict, NSError *error) {
                            if (error) {
                                return;
                            }
                            YMSCBCharacteristic *foundCharacter = [chDict objectForKey:KEY_PIN];
                            if (foundCharacter) {
                                NSLog(@"found character uuid with %@ and name %@", foundCharacter.uuid, foundCharacter.name);
                            }
                            if (foundCharacter.cbCharacteristic == nil) {
                                [thisService.characteristicDict removeObjectForKey:KEY_PIN];
                            }
                            foundCharacter = [chDict objectForKey:VALUE_1];
                            if (foundCharacter) {
                                NSLog(@"found character uuid with %@ and name %@", foundCharacter.uuid, foundCharacter.name);
                            }
                            if (foundCharacter.cbCharacteristic == nil) {
                                [thisService.characteristicDict removeObjectForKey:VALUE_1];
                            }
                            foundCharacter = [chDict objectForKey:VALUE_2];
                            if (foundCharacter) {
                                NSLog(@"found character uuid with %@ and name %@", foundCharacter.uuid, foundCharacter.name);
                            }
                            if (foundCharacter.cbCharacteristic == nil) {
                                [thisService.characteristicDict removeObjectForKey:VALUE_2];
                            }
                            foundCharacter = [chDict objectForKey:UPDATE_PIN];
                            if (foundCharacter) {
                                NSLog(@"found character uuid with %@ and name %@", foundCharacter.uuid, foundCharacter.name);
                            }
                            if (foundCharacter.cbCharacteristic == nil) {
                                [thisService.characteristicDict removeObjectForKey:VALUE_2];
                            }

                            
                        }];
                    }
                    if ([service.name isEqualToString:@"deviceInfo"]) {
                        NSLog(@"found device info with uuid %@", service.cbService.UUID);
                        DeviceInfoService *thisService = (DeviceInfoService *)service;
                        detailViewController.deviceInfo = thisService;
                        NSLog(@"found test data with uuid %@", thisService.cbService.UUID);
                        [detailViewController.deviceInfo discoverCharacteristics:[thisService characteristics] withBlock:^(NSDictionary *chDict, NSError *error) {
                            if (error) {
                                NSLog(@"found error when read device info");
                                return;
                            }
                            NSLog(@"found device info with %@", chDict);
                        }];
                    }
                    if ([service.name isEqualToString:@"readContent"]) {
                        NSLog(@"found read content with uuid %@", service.cbService.UUID);
                        cryptolaliaReadContent *thisService = (cryptolaliaReadContent *)service;
                        detailViewController.readContent = thisService;
                        NSLog(@"found test data with uuid %@", thisService.cbService.UUID);
                        [thisService discoverCharacteristics:[thisService characteristics] withBlock:^(NSDictionary *chDict, NSError *error) {
                            if (error) {
                                return;
                            }
                            
                            YMSCBCharacteristic *foundCharacter2 = [chDict objectForKey:KEY_WORD];
                            if (foundCharacter2) {
                                NSLog(@"found character2 uuid with %@ and name %@", foundCharacter2.uuid, foundCharacter2.name);
                            }
                            if (foundCharacter2.cbCharacteristic == nil) {
                                [thisService.characteristicDict removeObjectForKey:KEY_WORD];
                            }
                        }];
                    }
                }

                for (NSInteger i = 0; i < [self.bleDeviceArray count]; i++) {
                    if ([self.bleDeviceArray objectAtIndex:i] == yp) {
                        NSDictionary *advertisementData = nil;
                        advertisementData = [self.bleDeviceADVArray objectAtIndex:i];
                        detailViewController.serviceUUIDs = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
                        break;
                    }
                }
                [self.navigationController pushViewController:detailViewController animated:YES];

            }];

        }];
    }
}

#pragma mark - CBCentralManagerDelegate Methods


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            break;
        case CBCentralManagerStatePoweredOff:
            break;
            
        case CBCentralManagerStateUnsupported: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dang."
                                                            message:@"Unfortunately this device can not talk to Bluetooth Smart (Low Energy) Devices"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            
            [alert show];
            break;
        }
        case CBCentralManagerStateResetting: {
//            [self.peripheralsTableView reloadData];
            break;
        }
        case CBCentralManagerStateUnauthorized:
            break;
            
        case CBCentralManagerStateUnknown:
            break;
            
        default:
            break;
    }
    
    
    
}


#if 0
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    bleCenterManager *centralManager = [bleCenterManager sharedService];
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    yp.delegate = self;
    

    [yp.cbPeripheral readRSSI];
    cryptolaliaInputPin *detailViewController = [[cryptolaliaInputPin alloc] initWithNibName:@"cryptolaliaInputPin" bundle:nil];
    detailViewController.bleDevice = yp;
    for (NSInteger i = 0; i < [self.bleDeviceArray count]; i++) {
        if ([self.bleDeviceArray objectAtIndex:i] == yp) {
            NSDictionary *advertisementData = nil;
            advertisementData = [self.bleDeviceADVArray objectAtIndex:i];
            detailViewController.serviceUUIDs = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
            break;
        }
    }
    [self.navigationController pushViewController:detailViewController animated:YES];

#if 0
    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
        if (cell.yperipheral == yp) {
            [cell updateDisplay];
            break;
        }
    }
#endif
}
#endif


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
#if 0
    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
        [cell updateDisplay];
    }
#endif
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSInteger i;
    
    bleCenterManager *centralManager = [bleCenterManager sharedService];

    
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    for (i = 0; i < [self.bleDeviceArray count]; i++) {
        if ([self.bleDeviceArray objectAtIndex:i] == yp) {
            return;
        }
    }
    if (i == [self.bleDeviceArray count]) {
        //found new device which is not listed in table view
        NSLog(@"Found new device");
        [self.bleDeviceArray addObject:yp];
        [self.bleDeviceADVArray addObject:advertisementData];
        [self.tableView reloadData];
    }
#if 0
    if (yp.isRenderedInViewCell == NO) {
        [self.peripheralsTableView reloadData];
        yp.isRenderedInViewCell = YES;
    }
    
    if (centralManager.isScanning) {
        for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
            if (cell.yperipheral.cbPeripheral == peripheral) {
                if (peripheral.state == CBPeripheralStateDisconnected) {
                    cell.rssiLabel.text = [NSString stringWithFormat:@"%d", [RSSI integerValue]];
                    cell.peripheralStatusLabel.text = @"ADVERTISING";
                    [cell.peripheralStatusLabel setTextColor:[[DEATheme sharedTheme] advertisingColor]];
                } else {
                    continue;
                }
            }
        }
    }
#endif
}


- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    bleCenterManager *centralManager = [bleCenterManager sharedService];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
            yp.delegate = self;
        }
    }
#if 0
    [self.peripheralsTableView reloadData];
#endif
}


- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    bleCenterManager *centralManager = [bleCenterManager sharedService];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
            yp.delegate = self;
        }
    }
#if 0
    [self.peripheralsTableView reloadData];
#endif
}


@end
