//
//  LoginController.h
//  MyChime
//
//  Created by 恭輔 井上 on 12/11/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasyHttp.h"
#import "SVProgressHUD.h"
#import "WToast.h"

@interface LoginController : UIViewController{
    NSOperationQueue* queue;
}
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)inputChanged:(id)sender;
- (IBAction)inputFinished:(id)sender;
- (IBAction)touchLoginButton:(id)sender;

@end
