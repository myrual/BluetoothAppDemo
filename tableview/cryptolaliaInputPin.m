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

-(void)buttonPressed{
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

        YMSCBCharacteristic *writeValueChara = self.verifyPin.characteristicDict[VALUE_1];
        YMSCBCharacteristic *writePinChara = self.verifyPin.characteristicDict[KEY_PIN];
        YMSCBCharacteristic *updatePinChara = self.verifyPin.characteristicDict[UPDATE_PIN];
        
        [writePinChara writeValue:pinData2Chip withBlock:^(NSError *error){
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
                    [writeValueChara writeValue:pinData2Chip withBlock:^(NSError *error){
                        NSLog(@"found error with %@", error);
                    }];
                }];
                
            }];
            
        }];
        
        
        for (YMSCBCharacteristic *each in self.verifyPin.characteristicDict) {
            NSLog(@"found chara wiht uuid %@", self.verifyPin.characteristicDict[each]);
        }

        NSLog(@"found user input %@", inputText);
        self.contentField.text = [@"found user input with " stringByAppendingString:inputText];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.string = self.contentField.text;
        
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
    contentField.allowsEditingTextAttributes = NO;
    self.contentField = contentField;
    [self.view addSubview:contentField];
    
    UIButton *demoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [demoButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchDown];
    [demoButton setTitle:@"Confirm" forState:UIControlStateNormal];
    demoButton.frame = CGRectMake(100, 300, 100, 80);
    [self.view addSubview:demoButton];
        
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.pinField) {
        return YES;
    }
    return NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.pinField) {
        NSString *inputText = [textField text];
        NSLog(@"found user input with %@", inputText);
    }
    ;
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
