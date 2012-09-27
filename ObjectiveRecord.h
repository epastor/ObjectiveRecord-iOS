//
//  ObjectiveRecord.h
//  ObjectiveRecord
//
//  Created by Emmanuel Pastor on 22/12/11.
//  Copyright (c) 2011 Medinetik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveNetwork.h"
#import "ObjectiveSerializer.h"
#import "NSString+InflectionSupport.h"


@interface ObjectiveRecord : NSObject{
    
}
+ (void)findObjectId:(NSString *)objectId WithSuccessCallback:(void (^)(ObjectiveRecord *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

+ (void)allWithSuccessCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

+ (void)allWithParam:(NSString *)param value:(NSString *)value successCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

+ (void)allCancelableWithParam:(NSString *)param value:(NSString *)value successCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

+ (void)allWithParams:(NSString *)params customMethod:(NSString *)customURL successCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

- (void)lazyLoadAssociation:(NSString *)associationName WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;


//POST Requesters :::::

- (void)createWithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;
- (void)createAssociation:(ObjectiveRecord *)associate withSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;
- (void) postImage:(UIImage *)image toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;
- (void) postAudioData:(NSData *)data toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;
- (void) postCustomData:(NSData *)data dataName:(NSString *)dataName toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock;

//PUT Requesters :::::

- (void)updateWithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

//DELETE Requesters :::::

- (void)destroyWithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;
- (void)destroyAssociation:(ObjectiveRecord *)associate WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError;

//Helpers :::::
+ (NSString *)getResourceName;
+ (NSString *)getResourcePath:(NSString *)objectIdOrNil forAssociationOrNil:(NSString *) associationOrNil andAssociatedObjectIdOrNil:(NSString *)associatedObjectIdOrNil;
+ (NSString *)appendSerializationExtension:(NSString *)path;
- (NSString *)getResourcePath:(NSString *)objectIdOrNil forAssociationOrNil:(NSString *) associationOrNil andAssociatedObjectIdOrNil:(NSString *)associatedObjectIdOrNil;
- (NSString *)getResourceId;
- (BOOL)isEqualToRecord:(ObjectiveRecord *)record;
- (BOOL)belongsToRecord:(ObjectiveRecord *)record;
- (BOOL)hasRecord:(ObjectiveRecord *)record;
- (void)printError:(NSError *)error andOperation:(AFHTTPRequestOperation *)operation;







@end
