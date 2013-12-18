//
//  cryptolaliaInputPin.m
//  tableview
//
//  Created by li lin on 12/2/13.
//  Copyright (c) 2013 li lin. All rights reserved.
//

#import "cryptolaliaInputPin.h"
#import "YMSCBPeripheral.h"
#import "YMSCBCharacteristic.h"
#import "YMSCBService.h"

@interface cryptolaliaInputPin () <UITextFieldDelegate>
@property UITextField *pinField;
@property UITextField *contentField;
@property UIButton *confirmButton;
-(void) writePin2ServiceWith:(NSString *)pinText;
-(NSString *) readPinFromService;
-(NSString *) readCryptolalia;

@end

@implementation cryptolaliaInputPin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSData *)prepareDataFromInput:(NSString *) inputText{
    NSMutableData *pinData2Chip = [[NSMutableData alloc] initWithCapacity:8];
    NSData *pinData = [inputText dataUsingEncoding:NSStringEncodingConversionAllowLossy];
    [pinData2Chip appendData:pinData];
    NSLog(@"pin data is %@", pinData);
    if ([pinData length] < 8) {
        NSInteger toPading = 8 - [pinData length];
        unsigned char toPadingContent[toPading];
        for (NSInteger i = 0; i < toPading; i++) {
            toPadingContent[i] = 0x30;
        }
        NSData *paddingData = [NSData dataWithBytes:toPadingContent length:toPading];
        [pinData2Chip appendData:paddingData];
    }
    return pinData2Chip;
}

-(void)buttonPressed{
    NSLog(@"confirm button pressed");
//    [self.view endEditing:YES];
    [self.pinField resignFirstResponder];
    NSString *inputText = [self.pinField text];
    if (inputText) {
        YMSCBCharacteristic *writeValueChara = self.verifyPin.characteristicDict[VALUE_1];
        YMSCBCharacteristic *writePinChara = self.verifyPin.characteristicDict[KEY_PIN];
        [writePinChara writeValue:[self prepareDataFromInput:[self.pinField text]] withBlock:^(NSError *error){
            if (error) {
                NSLog(@"verify pin error %@", error);
                return;
            }
            [writePinChara readValueWithBlock:^(NSData *data, NSError *error){
                if(error){
                    NSLog(@"found error  after write pin and read pin%@", error);
                    return;
                }
                NSLog(@"read verify pin data from write pin service with %@", data);
                NSString *resultString = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
                NSLog(@"found result with %@", resultString);
                self.contentField.text = resultString;
                [writeValueChara readValueWithBlock:^(NSData *data, NSError *error){
                    if (error) {
                        NSLog(@"found error after data");
                        return;
                    }
                    NSLog(@"read out value data %@", data);

                    self.contentField.text = [[NSString alloc] initWithData:data encoding:NSStringEncodingConversionAllowLossy];
                    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
                    pasteBoard.string = self.contentField.text;
                }];
                
            }];
            
        }];
        
        NSLog(@"found user input %@", inputText);
        self.contentField.text = [@"found user input with " stringByAppendingString:inputText];
        
    }

}


-(void)updatePinbuttonPressed{
    NSMutableData *pinData2Chip = [[NSMutableData alloc] initWithCapacity:8];
    NSLog(@"confirm button pressed");
    //    [self.view endEditing:YES];
    [self.pinField resignFirstResponder];
    NSString *inputText = [self.pinField text];
    if (inputText) {
        NSData *pinData = [inputText dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        [pinData2Chip appendData:pinData];
        NSLog(@"pin data is %@", pinData);
        if ([pinData length] < 8) {
            NSInteger toPading = 8 - [pinData length];
            unsigned char toPadingContent[toPading];
            for (NSInteger i = 0; i < toPading; i++) {
                toPadingContent[i] = 0x30;
            }
            NSData *paddingData = [NSData dataWithBytes:toPadingContent length:toPading];
            [pinData2Chip appendData:paddingData];
        }
        
        YMSCBCharacteristic *updatePinChara = self.verifyPin.characteristicDict[UPDATE_PIN];
        NSLog(@"pin data 2 chip is %@", pinData2Chip);
        [updatePinChara writeValue:pinData2Chip withBlock:^(NSError *error){
            if(error){
                NSLog(@"found error for update pin with %@", error);
            }
            
        }];
    }
    
}

-(void)updateContentButtonPressed{
    NSMutableData *pinData2Chip = [[NSMutableData alloc] init];
    NSLog(@"confirm button pressed");
    //    [self.view endEditing:YES];
    [self.contentField resignFirstResponder];
    NSString *inputText = [self.contentField text];
    if (inputText) {
        NSData *pinData = [inputText dataUsingEncoding:NSStringEncodingConversionAllowLossy];
        [pinData2Chip appendData:pinData];
        NSLog(@"pin data is %@", pinData);
        if ([pinData length] < 8) {
            NSInteger toPading = 8 - [pinData length];
            unsigned char toPadingContent[toPading];
            for (NSInteger i = 0; i < toPading; i++) {
                toPadingContent[i] = 0x30;
            }
            NSData *paddingData = [NSData dataWithBytes:toPadingContent length:toPading];
            [pinData2Chip appendData:paddingData];
        }
        
        YMSCBCharacteristic *writeValueChara = self.verifyPin.characteristicDict[VALUE_1];
        NSLog(@"pin data 2 chip is %@", pinData2Chip);
        [writeValueChara writeValue:pinData2Chip withBlock:^(NSError *error){
            if(error){
                NSLog(@"found error for update pin with %@", error);
                return;
            }
            self.contentField.text = @"update content successful";
        }];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITextField *inputPinfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    inputPinfield.borderStyle = UITextBorderStyleRoundedRect;
    inputPinfield.placeholder = @"enter pin here";
    inputPinfield.delegate = self;
    inputPinfield.keyboardType = UIKeyboardTypeDecimalPad;
    self.pinField = inputPinfield;
    [self.view addSubview:inputPinfield];
    
    UITextField *contentField = [[UITextField alloc] initWithFrame:CGRectMake(10, 250, 300, 40)];
    contentField.borderStyle = UITextBorderStyleRoundedRect;
    contentField.placeholder = @"content will be here";
    contentField.delegate = self;
    self.contentField = contentField;
    [self.view addSubview:contentField];
    
    UIButton *demoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [demoButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [demoButton setTitle:@"Confirm" forState:UIControlStateNormal];
    demoButton.frame = CGRectMake(100, 300, 100, 80);
    [self.view addSubview:demoButton];
    self.confirmButton = demoButton;
    
    
    UIButton *updatePinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [updatePinButton addTarget:self action:@selector(updatePinbuttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [updatePinButton setTitle:@"UpdatePin" forState:UIControlStateNormal];
    updatePinButton.frame = CGRectMake(100, 100, 100, 80);
    [self.view addSubview:updatePinButton];


    UIButton *updateContentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [updateContentButton addTarget:self action:@selector(updateContentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [updateContentButton setTitle:@"UpdateContent" forState:UIControlStateNormal];
    updateContentButton.frame = CGRectMake(50, 50, 200, 50);
    [self.view addSubview:updateContentButton];

    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"my service has so many character with %@", self.verifyPin.characteristicDict);
}

@end
