//
//  ObjectiveNetwork.m
//  ObjectiveRecord
//
//  Created by Emmanuel Pastor on 22/12/11.
//  Copyright (c) 2011 Medinetik. All rights reserved.
//

#import "ObjectiveNetwork.h"
#import "ObjectiveRecord.h"
#import "AFJSONRequestOperation.h"
#import "Reachability.h"


static NSString *kRESTEndPoint = @"";
static int kDefaultTimeout = 20;

@implementation ObjectiveNetwork
@synthesize reachable;


static NSString *baseURL;
static NSString *userName;
static NSString *password;
static BOOL isAuthenticated;

//Sets the REST end point
+ (void) setRESTEndPoint:(NSString *)endPoint{
    kRESTEndPoint = endPoint;
}

//Gets the default timeout
+ (int) getDefaultTimeout{
    return kDefaultTimeout;
}

//Sets the default timeout
+ (void) setDefaultTimeout:(int)timeout{
    kDefaultTimeout = timeout;
}

//Returns the Singleton Instance
+ (id)sharedInstance {
    static ObjectiveNetwork *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kRESTEndPoint]];
    });
    
    return __sharedInstance;
}

//Inits the JSON HTTP Operation with a base URL
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setParameterEncoding:AFJSONParameterEncoding];
    
    return self;
}

//Sets the Base URL
+ (void) setBaseURL:(NSString *)strBaseURL {
    baseURL = strBaseURL;
}

//Sets the HTTP Basic Authentication User and Password
+ (void) setHTTPBasicAuthenticationWithUser: (NSString *)user andPassword:(NSString *)aPassword{
    userName = user;
    password = aPassword;
}

//Verifies the user's credentials against a login WS
- (void) loginWithEndPoint:(NSString *)endPoint serializeToObjectOrNil:(NSObject *)objectOrNil WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if( !userName || !password ){
        isAuthenticated = NO;
        return;
    }else{
        [self setAuthorizationHeaderWithUsername:userName password:password];
    }
    
    [self postPath:endPoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        isAuthenticated = YES;
        [self setAuthorizationHeaderWithUsername:userName password:password];
        [ ObjectiveSerializer overwritePropertiesOfObject:objectOrNil withObject:[ ObjectiveSerializer deserialize:responseObject ] ];
        if(onSuccess){
            onSuccess( operation );
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if( onError ){
            onError( operation, error );
        }
    }];
}

//Posts an UIImage to the server
- (void) postImage:(UIImage *)image toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock{

    NSData* imageData=UIImageJPEGRepresentation(image, 0.5); 
    
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:endPoint parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    }];
    
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite) 
     {
         
         if( progressBlock ){
             //Report back progress
             progressBlock ( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite );
         }
         
     }];
    
    [operation setCompletionBlockWithSuccess:onSuccess failure:onError];
    
    [operation start];
}

//Posts Audio Data to the server
- (void) postAudioData:(NSData *)data toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock{
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:endPoint parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFileData:data name:@"recording" fileName:@"recording.caf" mimeType:@"audio/x-caf"];
    }];
    
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite) 
     {
         
         if( progressBlock ){
             //Report back progress
             progressBlock ( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite );
         }
         
     }];
    
    [operation setCompletionBlockWithSuccess:onSuccess failure:onError];
    
    [operation start];
}

//Posts Custom Data to the server
- (void) postCustomData:(NSData *)data dataName:(NSString *)dataName toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock{
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:endPoint parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        [formData appendPartWithFormData:data name:dataName];
    }];
    
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setUploadProgressBlock:^(NSInteger bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite) 
     {
         
         if( progressBlock ){
             //Report back progress
             progressBlock ( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite );
         }
         
     }];
    [operation setCompletionBlockWithSuccess:onSuccess failure:onError];
    [operation start];
}

//Detect Reachability changes
- (void) reachabilityChanged:(NSNotification *)notification{
    Reachability *reachability = (Reachability *)notification.object;
    self.reachable = reachability.isReachable;
    
    if(! self.reachable ){
        //Display the "No internet connection block"
    }
}

//Logs Errors
- (void)printError:(NSError *)error andOperation:(AFHTTPRequestOperation *)operation{
    
    NSLog(@"%@", @"\n\n\n\n");
    NSLog(@"*******************************\n%@\n*******************************", error.description);
    NSLog(@"*******************************\n%@\n*******************************", operation);
    NSLog(@"%@", @"\n\n\n\n");
    
    if(operation.response.statusCode == 401){
        [[NSNotificationCenter defaultCenter] postNotificationName: @"logout" 
                                                            object: nil];
    }
    
}

//Returns User Authentication Status
+ (BOOL) getIsAuthenticated{
    return isAuthenticated;
}

//Returns Base URL
+ (NSString *) getBaseURL{
    return baseURL;
}

//Returns REST end point
+ (NSString *) getRESTEndPoint{
    return  kRESTEndPoint;
}


@end
