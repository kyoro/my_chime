//
//  LoginController.m
//  MyChime
//
//  Created by 恭輔 井上 on 12/11/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"
NSString *API_BASE = @"http://chime.hakamastyle.net/api";

@interface LoginController ()

@end

@implementation LoginController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"APP_TOKEN"];
    [defaults synchronize];
    loginButton.enabled = NO;
    
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loginButtonEnable
{
    if([usernameTextField.text length] > 0 && [passwordTextField.text length] > 0){
        loginButton.enabled = YES;
        loginButton.highlighted = YES;
    }else{
        loginButton.enabled = NO;
        loginButton.highlighted = NO;
    }  
}

- (void)setDefaultStatus
{
    [SVProgressHUD dismiss];
    usernameTextField.enabled = YES;
    passwordTextField.enabled = YES;
    [self loginButtonEnable];
}


- (IBAction)inputChanged:(id)sender {
    [self loginButtonEnable];
}

- (IBAction)inputFinished:(id)sender {
    [usernameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (IBAction)touchLoginButton:(id)sender {
    [self inputFinished:sender];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"DEVICE_TOKEN"];
    if(deviceToken == nil){
        [WToast showWithText:@"Push Notification is not allowed"];
        return;
    }
    [SVProgressHUD showWithStatus:@"Connecting ..."];
    usernameTextField.enabled = NO;
    passwordTextField.enabled = NO;
    loginButton.enabled = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                usernameTextField.text, @"username",
                                passwordTextField.text, @"password",
                                deviceToken, @"device_token", nil];
        NSString* res = [EasyHttp sendPostRequest:[self makeApiUrl:@"sessions"] sendParams:params];
        if([res length] == 0){
            dispatch_async(dispatch_get_main_queue(),^{
                [self setDefaultStatus];
                [WToast showWithText:@"Network Connection Error"];
            });
            return;
        }
        //JSON
        NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:
                                    NSJSONReadingAllowFragments error:nil]; 
        NSString *authenticated = [jsonObject objectForKey:@"authenticated"];
        if([authenticated isEqualToString:@"ok"]){
            dispatch_async(dispatch_get_main_queue(),^{
                [self setDefaultStatus];
                //Save token
                NSString *token = [jsonObject objectForKey:@"token"];
                [defaults setObject:token forKey:@"APP_TOKEN"];
                [defaults setObject:usernameTextField.text forKey:@"USER_NAME"];
                [defaults synchronize];
                
                [WToast showWithText:@"Login Succeed !"];
                [self dismissModalViewControllerAnimated:YES];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(),^{
                [self setDefaultStatus];
                [WToast showWithText:@"Invalid Username or Password"];
            });
        }
    });    
}
- (NSString *) makeApiUrl:(NSString *)endpoint
{
    return [NSString stringWithFormat:@"%@/%@",API_BASE,endpoint];
}

@end
