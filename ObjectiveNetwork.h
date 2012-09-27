//
//  ObjectiveNetwork.h
//  ObjectiveRecord
//
//  Created by Emmanuel Pastor on 22/12/11.
//  Copyright (c) 2011 Medinetik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "ObjectiveRecord.h"


@interface ObjectiveNetwork : AFHTTPClient{
    BOOL reachable;
}

typedef void (^JSONResponseBlock)(id jsonObject);
typedef void (^ObjectiveRecordObjectBlock)(id orObject);

@property(nonatomic) BOOL reachable;

//Get Singleton
+ (id)sharedInstance;

//Get Default Timeout
+ (int) getDefaultTimeout;

//Set Default Timeout
+ (int) setDefaultTimeout:(int)timeout;

//User Login
- (void) loginWithEndPoint:(NSString *)endPoint serializeToObjectOrNil:(NSObject *)objectOrNil WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

//Post UIImage
- (void) postImage:(UIImage *)image toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

//Post Audio Data
- (void) postAudioData:(NSData *)data toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

//Post Custom Data
- (void) postCustomData:(NSData *)data dataName:(NSString *)dataName toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;



+ (void) setBaseURL:(NSString *)strBaseURL;
+ (void) setHTTPBasicAuthenticationWithUser: (NSString *)user andPassword:(NSString *)aPassword;
+ (BOOL) getIsAuthenticated;
+ (NSString *) getBaseURL;
+ (NSString *) getRESTEndPoint;
+ (void) setRESTEndPoint:(NSString *)endPoint;

@end
