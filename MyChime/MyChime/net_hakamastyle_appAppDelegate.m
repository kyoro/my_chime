//
//  net_hakamastyle_appAppDelegate.m
//  MyChime
//
//  Created by 恭輔 井上 on 12/11/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "net_hakamastyle_appAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation net_hakamastyle_appAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //デバイスの登録
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    NSLog(@"Regist.");
    // Override point for customization after application launch.
    return YES;
}


// デバイストークンを受信した際の処理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    
    NSString *deviceToken = [[[[devToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] 
                            stringByReplacingOccurrencesOfString:@">" withString:@""] 
                            stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"deviceToken: %@", deviceToken);
    //[self.stash setObject:deviceToken forKey:@"deviceToken"];
    //da94a045ce4376e1c148cae49f204a999ee3e9bd06c3fca77434d53f04d370a3
    
    //Token登録
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"DEVICE_TOKEN"];
    [defaults setObject:deviceToken forKey:@"DEVICE_TOKEN"];
    [defaults synchronize];
}

// プッシュ通知を受信した際の処理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
#if !TARGET_IPHONE_SIMULATOR
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
    NSDictionary *customInfo = [userInfo objectForKey:@"custom"];
    NSString *ckey = [customInfo objectForKey:@"custom_key"];
    NSLog(@"Custom Key: %@", ckey);
    
    if(sound != nil){
        NSString *soundFilePrefix = [[sound componentsSeparatedByString:@"."] objectAtIndex:0];
        SystemSoundID mSound = 0;
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        CFURLRef soundUrl;
        if([soundFilePrefix isEqualToString:@"famima"]){
            soundUrl = CFBundleCopyResourceURL(mainBundle, CFSTR("famima"), CFSTR("mp3"), NULL );
        }else{
            soundUrl = CFBundleCopyResourceURL(mainBundle, CFSTR("S2"), CFSTR("mp3"), NULL );
        }
        AudioServicesCreateSystemSoundID(soundUrl, &mSound );
        AudioServicesPlaySystemSound( mSound );
        [WToast showWithText:@"Chime was recived"];
    }
    
#endif
}

//エラー
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)err{
    NSLog(@"Errorinregistration:%@",err);
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
