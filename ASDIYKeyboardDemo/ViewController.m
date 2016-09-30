//
//  ViewController.m
//  ASDIYKeyboardDemo
//
//  Created by 孙攀翔 on 30/9/2016.
//  Copyright © 2016 AngelSun. All rights reserved.
//

#import "ViewController.h"
#import "ASDIYKeyBoard.h"

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width

@interface ViewController ()<UITextFieldDelegate>
{
    
    ASDIYKeyBoard *pwdKeyBoard;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"ASDIYKeyboard";
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 84, 70, 20)];
    accountLabel.text = @"用户名：";
    accountLabel.textColor = [UIColor grayColor];
    accountLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:accountLabel];
    
    UITextField *accountField = [[UITextField alloc] initWithFrame:CGRectMake(90, 79, ScreenWidth-110, 30)];
    accountField.placeholder = @"请输入用户名";
    accountField.delegate = self;
    accountField.textColor = [UIColor grayColor];
    accountField.font = [UIFont systemFontOfSize:14];
    accountField.returnKeyType = UIReturnKeyDone;
    accountField.keyboardType = UIKeyboardTypeURL;
    accountField.layer.cornerRadius = 4.0;
    accountField.layer.borderColor = [UIColor grayColor].CGColor;
    accountField.layer.borderWidth = 1;
    [self.view addSubview:accountField];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 124, 70, 20)];
    pwdLabel.text = @"密码：";
    pwdLabel.textColor = [UIColor grayColor];
    pwdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:pwdLabel];
    
    UITextField *pwdField = [[UITextField alloc] initWithFrame:CGRectMake(90, 119, ScreenWidth-110, 30)];
    pwdField.placeholder = @"请输入密码";
    pwdField.delegate = self;
    pwdField.textColor = [UIColor grayColor];
    pwdField.font = [UIFont systemFontOfSize:14];
    pwdField.returnKeyType = UIReturnKeyDone;
    pwdField.keyboardType = UIKeyboardTypeURL;
    pwdField.layer.cornerRadius = 4.0;
    pwdField.layer.borderColor = [UIColor grayColor].CGColor;
    pwdField.layer.borderWidth = 1;
    [self.view addSubview:pwdField];
    
    pwdKeyBoard = [[ASDIYKeyBoard alloc] init];
    [pwdKeyBoard setTextInput:pwdField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
