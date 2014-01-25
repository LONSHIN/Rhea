//
//  REInputVinCodeViewController.m
//  Rhea
//
//  Created by Tiger on 14-1-17.
//  Copyright (c) 2014年 Tiger. All rights reserved.
//

#import "REInputVinCodeViewController.h"
#import "RELibraryAPI.h"
#import "DAKeyboardControl.h"

@interface REInputVinCodeViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) RECar *currentEditCar;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) REAddCarSucceededBlcok succeededBlock;

@property (nonatomic, assign) REUpdateCarListType updateCarListType;

@end



@implementation REInputVinCodeViewController


- (id)initWithCar:(RECar *)car succeededBlock:(REAddCarSucceededBlcok)succeededBlcok
{
    if (self = [super init]) {
         self.currentEditCar = [[RECar alloc] init];
        if (car == nil) {
            self.updateCarListType = REUpdateCarListTypeSaveNewCar;
        }else {
            self.updateCarListType = REUpdateCarListTypeUpdateExistCar;
            [self.currentEditCar updateWithCar:car];
        }
        self.succeededBlock = succeededBlcok;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configBackground];
    self.title = self.updateCarListType == REUpdateCarListTypeSaveNewCar ? @"添加VIN码" : @"修改VIN码";
    [self layoutViews];
    [self configRightBarButton];
    
    [self.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView) {
        
    }];
}


- (void)dealloc
{
    [self.view removeKeyboardControl];
}


- (void)configRightBarButton
{
    UIButton *button = [UIButton buttonWithText:@"查询"
                                           font:[UIFont systemFontOfSize:14.0f]
                                      textColor:[UIColor whiteColor]
                               highlightedColor:[UIColor lightGrayColor]
                                         target:self
                                         action:@selector(handleRightBarButtonTapped:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}


- (void)layoutViews
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 75.0f)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, bgView.height - 0.5f, bgView.width, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"afafaf"];
    [bgView addSubview:lineView];
    
    UILabel *label = [UILabel labelWithText:@"VIN码是车辆识别代号，在行驶证(或车头前)可以找到："
                            backgroundColor:[UIColor clearColor]
                                  textColor:[UIColor blackColor]
                                       font:[UIFont systemFontOfSize:12.0f]];
    label.frame = CGRectMake(15.0f, 12.0f, label.width, label.height);
    [bgView addSubview:label];
    
    UIImageView *textFieldBgView = [[UIImageView alloc] initWithFrame:CGRectMake(7.0f, 35.0f, 306.0f, 30.0f)];
    textFieldBgView.image = [[UIImage imageNamed:@"input_bar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0f, 3.0f, 4.0f, 3.0f)];
    [bgView addSubview:textFieldBgView];
    [self.view addSubview:bgView];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 35.0f, 298.0f, 30.0f)];
    textField.placeholder = @"请输入完整17位VIN码";
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.text = self.currentEditCar.intactVinCode;
    [textField becomeFirstResponder];
    [textFieldBgView addSubview:textField];
    self.textField = textField;
    
    [self.view addSubview:self.textField];
    
    UIImageView *exampleView = [UIImageView imageViewWithImageName:@"vin_engine_code_example"];
    exampleView.frame = CGRectMake(7.0f, bgView.height + 7.0f, exampleView.width, exampleView.height);
    [self.view addSubview:exampleView];
}


#pragma mark -  Button Action

- (void)handleRightBarButtonTapped:(UIButton *)sender
{
    [self textFieldShouldReturn:self.textField];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length != 17) {
        [SVProgressHUD showImage:nil status:@"请输入正确的17位VIN码"];
    }else{
        self.currentEditCar.intactVinCode = textField.text;
        if (self.updateCarListType == REUpdateCarListTypeSaveNewCar) {
            [RELibraryAPI saveCar:self.currentEditCar];
        }else if (self.updateCarListType == REUpdateCarListTypeUpdateExistCar) {
            [RELibraryAPI updateCar:self.currentEditCar];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCarListChanged object:nil];
        if (self.succeededBlock != nil) {
            self.succeededBlock(self.currentEditCar);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    NSRange lowercaseCharRange;
    lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (range.location >= 17) {
        return NO;
    }
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    return YES;
}


@end
