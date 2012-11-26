//
//  EasyHttp.h
//  MyChime
//
//  Created by Kyosuke INOUE on 12/11/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasyHttp : NSObject
+ (NSString *)sendPostRequest:(NSString *)url sendData:(NSData *)sendData;
+ (NSString *)sendPostRequest:(NSString *)url sendString:(NSString *)sendString encode:(int)encode;
+ (NSString *)sendPostRequest:(NSString *)url sendParams:(NSDictionary *)sendParams;
+ (NSString *)sendGetRequest:(NSString *)url;
+ (NSString *)sendGetRequest:(NSString *)url sendString:(NSString *)sendString;
+ (NSString *)sendGetRequest:(NSString *)url sendString:(NSString *)sendString encode:(int)encode;
+ (NSString *) urlEncode: (id)obj;
+ (NSString *) makeQuerystringFromDict: (NSDictionary *)dict;
@end
