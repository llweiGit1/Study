//
//  LoginViewController.m
//  Study
//
//  Created by MaxPlus on 15/9/17.
//  Copyright (c) 2015年 MaxPlus. All rights reserved.
//

#import "LoginViewController.h"
#import "KeyboardManager.h"
#import <MBProgressHUD.h>
#import "NetRequest.h"

#define SERVICE @"moodle_mobile_app"
#define SETTINGS [NSUserDefaults standardUserDefaults]

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *blankButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;


@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@end

static MBProgressHUD *hud;

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置页面控件细节
    [self displayTheView];
    // 登录页面的动画效果设置
//    [self animationOfLoginView];
//    [self loginJudge];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    // 控制整个功能是否启用
    manager.enable = YES;
    // 控制点击背景是否收起键盘
    manager.shouldResignOnTouchOutside = YES;
    // 控制键盘上的工具条文字颜色是否用户自定义
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    // 控制是否显示键盘上的工具条
    manager.enableAutoToolbar = NO;
    
//    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayTheView {
//   [self constraintOfSubview:self.usernameTextField multiplier:1.0/16.0];
//   [self constraintOfSubview:self.passwordTextField multiplier:1.0/16.0];
    // 设置‘登录’输入框左边图标
    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 16, 20)];
    userImg.image = [UIImage imageNamed:@"account.png"];
    [self.usernameTextField addSubview:userImg];
//    self.usernameTextField.inputAccessoryView = [[UIView alloc] init];
    
    // 设置‘登录’输入框文字左边间距
    CGRect frame = [self.usernameTextField frame];
    frame.size.width = 28.0f;
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTextField.leftView = leftview;
    
    // 设置‘密码’输入框左边图标
    UIImageView *passImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 19, 20)];
    passImg.image = [UIImage imageNamed:@"password.png"];
    [self.passwordTextField addSubview:passImg];
//    self.passwordTextField.inputAccessoryView = [[UIView alloc] init];
    self.passwordTextField.secureTextEntry = YES;
    
    // 设置‘密码’输入框文字左边间距
    CGRect frame1 = [self.passwordTextField frame];
    frame1.size.width = 28.0f;
    UIView *leftview1 = [[UIView alloc] initWithFrame:frame1];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = leftview1;
    
    // 设置两个输入框的代理为登录控制器本身
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate =self;
    
    // 设置登录按钮的边框及圆角效果
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.borderWidth = 1.0;
    // 设置颜色空间为rgb，用于生成ColorRef。
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
    // 设置边框颜色
    self.loginButton.layer.borderColor = borderColorRef;
    self.loginButton.layer.cornerRadius = 5.0;
    
    if ([SETTINGS boolForKey:@"check"]) {
        [self.blankButton setImage:[UIImage imageNamed:@"gou.png"] forState:UIControlStateNormal];
    }
    self.blankButton.layer.masksToBounds = YES;
    self.blankButton.layer.borderWidth = 0.7;
    // 新建一个红色的ColorRef，用于设置边框（四个数字分别是 r, g, b, alpha）
    CGColorRef borderColorRef1 = CGColorCreate(colorSpace,(CGFloat[]){ 0.1, 0.1, 0.1, 0.2});
    // 设置边框颜色
    self.blankButton.layer.borderColor = borderColorRef1;
    self.blankButton.layer.cornerRadius = 5.0;

}

- (void)constraintOfSubview:(id)sender  multiplier:(CGFloat)multiplier {
[self.view addConstraint:[NSLayoutConstraint
                          
                          constraintWithItem:sender
                          
                          attribute:NSLayoutAttributeHeight
                          
                          relatedBy:NSLayoutRelationEqual
                          
                          toItem:self.view
                          
                          attribute:NSLayoutAttributeHeight
                          
                          multiplier:multiplier
                          
                          constant:0]];
}

//- (void)animationOfLoginView {
//    self.iconImage.transform = CGAffineTransformMakeTranslation(0, 100);
//    self.usernameTextField.transform = CGAffineTransformMakeTranslation(-200, 0);
//    self.passwordTextField.transform = CGAffineTransformMakeTranslation(-200, 0);
//    self.loginButton.transform = CGAffineTransformMakeTranslation(-200, 0);
//    
//    [UIView animateWithDuration:0.7
//                     animations:^{
//                         self.iconImage.transform = CGAffineTransformMakeTranslation(0, 0);
//                         self.usernameTextField.transform = CGAffineTransformMakeTranslation(0, 0);
//                         self.passwordTextField.transform = CGAffineTransformMakeTranslation(0, 0);
//                         self.loginButton.transform = CGAffineTransformMakeTranslation(0, 0);
//                     }];
//}


#pragma marks -- UITextField Dlegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 如果是输入账号，显示跳转到下一项
    if (textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    // 如果是输入密码，显示完成
    if (textField == self.passwordTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // 开始输入的时候，输入框内容清空
    textField.placeholder = @"";
}

#pragma marks -- Button Press Methods
- (IBAction)blankButtonPressed:(id)sender {
    if (![SETTINGS boolForKey:@"check"]) {
        NSLog(@"记住密码");
        [sender setImage:[UIImage imageNamed:@"gou.png"] forState:UIControlStateNormal];
        [SETTINGS setBool:YES forKey:@"check"];
        if ([SETTINGS objectForKey:@"password"] != nil) {
        [SETTINGS removeObjectForKey:@"password"];
        NSLog(@"删除原来密码");
        }
        [SETTINGS setObject:_passwordTextField.text forKey:@"password"];
        NSLog(@"保存密码");
        [SETTINGS synchronize];
    } else {
        NSLog(@"取消记住密码");
        if ([SETTINGS objectForKey:@"password"] != nil) {
        [SETTINGS removeObjectForKey:@"password"];
        NSLog(@"删除保存的密码");
        }
        [SETTINGS setBool:NO forKey:@"check"];
        [SETTINGS synchronize];
        [sender setImage:nil forState:UIControlStateNormal];
    }
    
}

- (IBAction)loginButtonPressed:(id)sender {
    // 如果任一输入框为空，显示警告视图
    if (_usernameTextField.text.length == 0 || _passwordTextField.text.length == 0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"用户名或密码不能为空" message:@"请键入用户名或密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    } else {
            [self loginRequest];
        }
}

//- (void)loginJudge {
//    if ([SETTINGS objectForKey:@"username"] != nil) {
//        _usernameTextField.text = [SETTINGS objectForKey:@"username"];
//        NSLog(@"用户名已填充");
//        if ([SETTINGS objectForKey:@"password"] != nil) {
//            _passwordTextField.text = [SETTINGS objectForKey:@"password"];
//            NSLog(@"密码已填充,自动登录");
////            [self loginRequest];
//        }
//    }
//}


- (void)loginRequest {
    // 显示登录中指示器
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = @"登录中";
    hud.dimBackground = YES;
    [hud show:YES];
    // 设置网络请求参数
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_usernameTextField.text, @"username", _passwordTextField.text, @"password", SERVICE, @"service", nil];
    NSLog(@"%@", params);
    
    // 初始化网路请求类
    NetRequest *request = [NetRequest sharedNetRequest];
    // 进行网络请求
    [request postWithParams:params successResult:^(id responseObject) {
        // 验证成功，返回token，跳转首页
        if ([responseObject objectForKey:@"token"]) {
            NSLog(@"%d------%@",[SETTINGS boolForKey:@"check"], [SETTINGS objectForKey:@"password"]);
            if ([SETTINGS boolForKey:@"check"]  && ![SETTINGS objectForKey:@"password"]) {
                [SETTINGS setObject:_passwordTextField.text forKey:@"password"];
                NSLog(@"%@+++++++",[SETTINGS objectForKey:@"password"]);
            }
            NSLog(@"%@", responseObject);
            if ([SETTINGS objectForKey:@"username"] != nil) {
                [SETTINGS removeObjectForKey:@"username"];
            }
            [SETTINGS setObject:_usernameTextField.text forKey:@"username"];
            [SETTINGS  synchronize];
            [hud hide:YES];
            UIStoryboard *homeSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            [self presentViewController:[homeSB instantiateInitialViewController] animated:NO completion:nil];
            
        }
        // 验证失败，显示错误提醒
        else if ([responseObject objectForKey:@"error"]) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"用户名或密码错误";
            hud.margin = 10.f;
            [hud hide:YES afterDelay:2];
            NSLog(@"%@", responseObject[@"error"]);
            if ([SETTINGS objectForKey:@"password"] != nil) {
                NSLog(@"密码出错，删除错误密码");
                [SETTINGS removeObjectForKey:@"password"];
                [SETTINGS synchronize];
            }
            
        }
        else {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"出现未知错误";
            hud.margin = 10.f;
            [hud hide:YES afterDelay:2];
        }
        
        
    } faild:nil
     //         ^(NSError *error) {
     //            hud.labelText = @"登录出错！";
     //            NSLog(@"%@", [error description]);
     //            [hud hide:YES afterDelay:2];
     //        }
     ];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([SETTINGS objectForKey:@"username"] != nil) {
        _usernameTextField.text = [SETTINGS objectForKey:@"username"];
        NSLog(@"用户名已填充-----%@",[SETTINGS objectForKey:@"password"]);
        if ([SETTINGS objectForKey:@"password"] != nil) {
            _passwordTextField.text = [SETTINGS objectForKey:@"password"];
            NSLog(@"密码已填充,自动登录");
            [self loginRequest];
        }
    }
}



//- (void)dealloc
//{
//    self.returnKeyHandler = nil;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
