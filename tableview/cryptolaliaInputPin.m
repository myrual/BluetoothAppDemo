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
    NSLog(@"confirm button pressed");
//    [self.view endEditing:YES];
    [self.pinField resignFirstResponder];
    NSString *inputText = [self.pinField text];
    if (inputText) {
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
    [demoButton setTitle:@"aaa" forState:UIControlStateNormal];
    demoButton.frame = CGRectMake(100, 300, 40, 40);
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
    YMSCBCharacteristic *writePinChara = self.verifyPin.characteristicDict[KEY_PIN];
    [writePinChara readValueWithBlock:^(NSData *data, NSError *error){
        if(error){
            NSLog(@"found error in first read %@", error);
            return;
        }
        NSLog(@"read first data with %@", data);
        [writePinChara writeByte:0x33 withBlock:^(NSError *error){
            [writePinChara readValueWithBlock:^(NSData *data, NSError *error){
                if(error){
                    NSLog(@"found error %@", error);
                    return;
                }
                NSLog(@"read verify pin data from write pin service with %@", data);
            }];
            
        }];
    }];
    for (YMSCBCharacteristic *each in self.verifyPin.characteristicDict) {
        NSLog(@"found chara wiht uuid %@", self.verifyPin.characteristicDict[each]);
    }
}

@end
