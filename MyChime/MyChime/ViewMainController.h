//
//  ViewMainController.h
//  MyChime
//
//  Created by 恭輔 井上 on 12/11/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"
#import "EasyHttp.h"
#import "SVProgressHUD.h"
#import "WToast.h"

@interface ViewMainController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIView *selectedUserView;
@property (weak, nonatomic) IBOutlet UILabel *selectedUserNameLabel;
- (IBAction)touchLoadButton:(id)sender;
- (IBAction)selectUserButton:(id)sender;
- (IBAction)touchCallButton:(id)sender;

@end
