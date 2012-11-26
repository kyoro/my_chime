//
//  EasyHttp.m
//  MyChime
//
//  Created by Kyosuke INOUE on 12/11/17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EasyHttp.h"

@implementation EasyHttp

+ (NSString *)sendPostRequest:(NSString *)url sendData:(NSData *)sendData {
    NSURL *nsurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: nsurl];
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [sendData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: sendData];
    
    NSError *error;
    NSURLResponse *response;
    NSData *buffer = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (buffer != nil) {
        // response
        int encodeArray[] = {
            NSUTF8StringEncoding,			// UTF-8
            NSShiftJISStringEncoding,		// Shift_JIS
            NSJapaneseEUCStringEncoding,	// EUC-JP
            NSISO2022JPStringEncoding,		// JIS
            NSUnicodeStringEncoding,		// Unicode
            NSASCIIStringEncoding			// ASCII
        };
        NSString *dataString = nil;
        int max = sizeof(encodeArray) / sizeof(encodeArray[0]);
        for (int i=0; i<max; i++) {
            dataString = [
                          [NSString alloc]
                          initWithData : buffer
                          encoding : encodeArray[i]
                          ];
            if (dataString != nil) {
                break;
            }
        }
        return dataString;
    } else {
        // error handling
        return nil;
    }
}

+ (NSString *)sendPostRequest:(NSString *)url sendParams:(NSDictionary *)sendParams {
    NSString *str = [EasyHttp makeQuerystringFromDict:sendParams];
    return [EasyHttp sendPostRequest:url sendString:str encode:NSUTF8StringEncoding];
}

+ (NSString *)sendPostRequest:(NSString *)url sendString:(NSString *)sendString encode:(int)encode {
    NSData *requestData = [sendString dataUsingEncoding:encode allowLossyConversion:YES];
    return [self sendPostRequest:url sendData:requestData];
}

+ (NSString *)sendGetRequest:(NSString *)url {
	NSURL *nsurl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:nsurl];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [
                    NSURLConnection
                    sendSynchronousRequest : request
                    returningResponse : &response
                    error : &error
                    ];
    
	// error
	NSString *errorStr = [error localizedDescription];
	if (0 < [errorStr length]) {
		return nil;
	}
    
	// response
	int encodeArray[] = {
		NSUTF8StringEncoding,			// UTF-8
		NSShiftJISStringEncoding,		// Shift_JIS
		NSJapaneseEUCStringEncoding,	// EUC-JP
		NSISO2022JPStringEncoding,		// JIS
		NSUnicodeStringEncoding,		// Unicode
		NSASCIIStringEncoding			// ASCII
	};
    
	NSString *dataString = nil;
	int max = sizeof(encodeArray) / sizeof(encodeArray[0]);
	for (int i=0; i<max; i++) {
		dataString = [
                      [NSString alloc]
                      initWithData : data
                      encoding : encodeArray[i]
                      ];
		if (dataString != nil) {
			break;
		}
	}
	return dataString;
}

+ (NSString *)sendGetRequest:(NSString *)url sendString:(NSString *)sendString {
    return [self sendGetRequest:[NSString stringWithFormat:@"%@%@%@", url, @"?", sendString]];
}

+ (NSString *)sendGetRequest:(NSString *)url sendString:(NSString *)sendString encode:(int)encode {
    return [self sendGetRequest:[NSString stringWithFormat:@"%@%@%@", url, @"?", [sendString dataUsingEncoding:encode allowLossyConversion:YES]]];
}


+ (NSString *) urlEncode: (id)obj {
    NSString *string = [NSString stringWithFormat: @"%@", obj];
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

+ (NSString *) makeQuerystringFromDict: (NSDictionary *)dict {
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in dict) {
        id value = [dict objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@",
                          [EasyHttp urlEncode: key], [EasyHttp urlEncode: value]];
        [parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}


@end
