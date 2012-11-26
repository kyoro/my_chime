//
//  ViewMainController.m
//  MyChime
//
//  Created by 恭輔 井上 on 12/11/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewMainController.h"
NSString *API_BASE2 = @"http://chime.hakamastyle.net/api";

@interface ViewMainController (){
    NSString *token;
}
@end

@implementation ViewMainController
@synthesize statusLabel;
@synthesize loadButton;
@synthesize selectedUserView;
@synthesize selectedUserNameLabel;

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
}

- (IBAction)getDeviceId:(id)sender {
    //net_hakamastyle_appAppDelegate *appDelegate = (net_hakamastyle_appAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"%@",appDelegate.stash);
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    token = [defaults stringForKey:@"APP_TOKEN"];
    if(token == nil){
        LoginController *loginWindow = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
        [self presentModalViewController:loginWindow animated:YES];
        return;
    }
    NSString *username = [defaults stringForKey:@"USER_NAME"];
    statusLabel.text =  [NSString stringWithFormat:@"%@ %@",@"Login as ",username];
    [self showPairView];
    NSLog(@"%@",token);  
}

- (void)viewDidUnload
{
    [self setStatusLabel:nil];
    [self setLoadButton:nil];
    [self setSelectedUserView:nil];
    [self setSelectedUserNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)touchLoadButton:(id)sender {
    [SVProgressHUD showWithStatus:@"Logout ..."];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    token = [defaults stringForKey:@"APP_TOKEN"];
    NSString *deviceToken = [defaults stringForKey:@"DEVICE_TOKEN"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                token, @"token",
                                deviceToken, @"device_token", nil];
        NSString *apiUrl = [NSString stringWithFormat:@"%@%@",API_BASE2,@"/sessions/device/logout"];
        
        NSString* res = [EasyHttp sendPostRequest:apiUrl sendParams:params];
        if([res length] == 0){
            dispatch_async(dispatch_get_main_queue(),^{
                [WToast showWithText:@"Network Connection Error"];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [defaults removeObjectForKey:@"PAIR"];
            [defaults synchronize];
            [self showPairView];
            [SVProgressHUD dismiss];
            LoginController *loginWindow = [self.storyboard instantiateViewControllerWithIdentifier:@"loginController"];
            [self presentModalViewController:loginWindow animated:YES];    
        });
        
    });
}

- (IBAction)selectUserButton:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"Pair User" message: @"Please input username" delegate: nil cancelButtonTitle: @"Cancel" otherButtonTitles: @"OK", nil];
    alertView.delegate = self;
    [alertView setAlertViewStyle: UIAlertViewStylePlainTextInput];// ここでタイプを設定
    [alertView show];
}

- (IBAction)touchCallButton:(id)sender {
    [SVProgressHUD showWithStatus:@"Calling ..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *pairName = [defaults stringForKey:@"PAIR"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: nil];
        NSString *apiUrl = [NSString stringWithFormat:@"%@%@%@%@",API_BASE2,@"/users/",pairName, @"/call"];
        NSString* res = [EasyHttp sendPostRequest:apiUrl sendParams:params];
        if([res length] == 0){
            dispatch_async(dispatch_get_main_queue(),^{
                [WToast showWithText:@"Network Connection Error"];
            });
            return;
        }
        NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:
                                    NSJSONReadingAllowFragments error:nil]; 
        NSString *result = [jsonObject objectForKey:@"result"];
        NSLog(@"%@",result);
        if([result isEqualToString:@"ok"]){
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD dismiss];
                [WToast showWithText:@"Called"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD dismiss];
                [WToast showWithText:@"Faild to call"];
            });        
        }

        

    });
    
    
}

-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    UITextField *userNameText = [alertView textFieldAtIndex:0];
    NSLog(@"%@",userNameText.text); 
    if(buttonIndex == 0){
        
        NSLog(@"CANCEL");
        return;
    }
    [SVProgressHUD showWithStatus:@"Searching ..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys: nil];
        NSString *apiUrl = [NSString stringWithFormat:@"%@%@%@%@",API_BASE2,@"/users/",userNameText.text, @"/available"];
        NSString* res = [EasyHttp sendPostRequest:apiUrl sendParams:params];
        if([res length] == 0){
            dispatch_async(dispatch_get_main_queue(),^{
                [WToast showWithText:@"Network Connection Error"];
            });
            return;
        }
        NSData *data = [res dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:
                                    NSJSONReadingAllowFragments error:nil]; 
        NSString *result = [jsonObject objectForKey:@"result"];
        NSLog(@"%@",result);
        if([result isEqualToString:@"ok"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userNameText.text forKey:@"PAIR"];
            [defaults synchronize];
            
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD dismiss];
                /*
                UIAlertView *alert =[[UIAlertView alloc]
                                     initWithTitle:@"Succeed!" message:@"Pairing is completed." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
                [alert show];*/
                [self showPairView];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(),^{
                [SVProgressHUD dismiss];
                UIAlertView *alert =[[UIAlertView alloc]
                                     initWithTitle:@"Not Found" message:@"Unknown username." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil ];
                [alert show];
                [self showPairView];
            });        
        }
        NSLog(@"%@",apiUrl);
        
    });
       
}

-(void)showPairView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pairName = [defaults stringForKey:@"PAIR"];
    if(pairName == nil){
        selectedUserView.hidden = YES;
        return;
    }else{
        selectedUserNameLabel.text = pairName;
        selectedUserView.hidden = NO;
    }    
}
            
@end
