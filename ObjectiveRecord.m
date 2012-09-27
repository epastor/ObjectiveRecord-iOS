//
//  ObjectiveRecord.m
//  ObjectiveRecord
//
//  Created by Emmanuel Pastor on 22/12/11.
//  Copyright (c) Medinetik. All rights reserved.
//

#import "ObjectiveRecord.h"
#import "NSObject+PropertySupport.h"
#import "AFJSONRequestOperation.h"
#import "Patient.h"


@implementation ObjectiveRecord

static NSMutableArray *operationQueue;


//GET Requesters :::::

+ (void)findObjectId:(NSString *)objectId WithSuccessCallback:(void (^)(ObjectiveRecord *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"GET" path:[self appendSerializationExtension:[self getResourcePath:objectId forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil]] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.request.URL);
        NSLog(@"%@", operation.responseString);
        NSLog(@"%@", [ responseObject objectForKey:@"patient" ] );
        ObjectiveRecord *record = [ObjectiveSerializer deserialize:responseObject];
        
        if(onSuccess){
            onSuccess( record ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
}

+ (void)allWithSuccessCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"GET" path:[self appendSerializationExtension:[self getResourcePath:nil forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil]] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", operation.request.URL);
        NSMutableArray *collection = [ ObjectiveSerializer deserialize:responseObject ];
        if(onSuccess){
            onSuccess( collection ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
    
}

+ (void)allWithParam:(NSString *)param value:(NSString *)value successCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"GET" path:[[self appendSerializationExtension:[self getResourcePath:nil forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil]] stringByAppendingFormat:@"?%@=%@", param, value] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *collection = [ ObjectiveSerializer deserialize:responseObject ];
        if(onSuccess){
            onSuccess( collection ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
}

+ (void)allCancelableWithParam:(NSString *)param value:(NSString *)value successCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"GET" path:[[self appendSerializationExtension:[self getResourcePath:nil forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil]] stringByAppendingFormat:@"?%@=%@", param, value] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    if(!operationQueue) operationQueue = [NSMutableArray new];
    for(AFJSONRequestOperation *op in operationQueue){
        
        [op cancel];
        
        NSLog(@"%@", @"Canceled!");
    }
    [operationQueue addObject:operation];
        
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *collection = [ ObjectiveSerializer deserialize:responseObject ];
        if(onSuccess){
            onSuccess( collection );
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
}

+ (void)allWithParams:(NSString *)params customMethod:(NSString *)customURL successCallback:(void(^)(NSMutableArray *))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@/%@%@", [self getResourcePath:nil forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil], [self appendSerializationExtension:customURL], params] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSMutableArray *collection = [ ObjectiveSerializer deserialize:responseObject ];
        if(onSuccess){
            onSuccess( collection ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
}

- (void)lazyLoadAssociation:(NSString *)associationName WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"GET" path:[[self class] appendSerializationExtension:[self getResourcePath:[NSString stringWithFormat:@"%@", [self getResourceId]] forAssociationOrNil:associationName andAssociatedObjectIdOrNil:nil]] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setValue:[ObjectiveSerializer deserialize:responseObject] forKey:associationName];
        if(onSuccess){
            onSuccess( operation ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
}


//POST Requesters :::::

- (void)createWithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
   NSDictionary *dictRepresentation = [ObjectiveSerializer serialize:self forClass:[self class]];
    
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"POST" path:[[self class] appendSerializationExtension:[self getResourcePath:nil forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil]] parameters:[NSDictionary dictionaryWithObject:dictRepresentation forKey:[[self className] underscore]]];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        ObjectiveRecord *record = [ObjectiveSerializer deserialize:responseObject];
        [ObjectiveSerializer overwritePropertiesOfObject:self withObject:record];
        if(onSuccess){
            onSuccess( operation ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
    

    
}

- (void)createAssociation:(ObjectiveRecord *)associate withSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSDictionary *dictRepresentation = [ObjectiveSerializer serialize:associate forClass:[self class]];
    
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"POST" path:[[self class] appendSerializationExtension:[self getResourcePath:[NSString stringWithFormat:@"%@", [self getResourceId]] forAssociationOrNil:[[associate class] getResourceName] andAssociatedObjectIdOrNil:[associate getResourceId]]] parameters:[NSDictionary dictionaryWithObject:dictRepresentation forKey:[[self className] underscore]]];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(onSuccess){
            onSuccess( operation ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
}

- (void) postImage:(UIImage *)image toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getResourcePath:[self getResourceId] forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil], endPoint];
    
    [[ObjectiveNetwork sharedInstance] postImage:image toEndPoint:path WithSuccessCallback:^(AFHTTPRequestOperation *operation, id object){
        NSLog(@"SUCCESS: %@", operation.responseString);
        if( onSuccess ){
            onSuccess( operation, object );
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError( operation, error );
        }
        
    } progressCallback:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpected){
        NSLog(@"PROGRESS: %d", bytesWritten);
        if( progressBlock ){
            progressBlock( bytesWritten, totalBytesWritten, totalBytesExpected );
        }
    }];
    
};

- (void) postAudioData:(NSData *)data toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getResourcePath:[self getResourceId] forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil], endPoint];
    
    [[ObjectiveNetwork sharedInstance] postAudioData:data toEndPoint:path WithSuccessCallback:^(AFHTTPRequestOperation *operation, id object) {
        
        if( onSuccess ){
            id jsonObject = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:nil];
            ObjectiveRecord *record = [ObjectiveSerializer deserialize:jsonObject];
            onSuccess( operation, record );
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError( operation, error );
        }
    } progressCallback:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if( progressBlock ){
            progressBlock( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite );
        }
    }];    
};

- (void) postCustomData:(NSData *)data dataName:(NSString *)dataName toEndPoint:(NSString *)endPoint WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation, id object))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError progressCallback:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSString *path = [NSString stringWithFormat:@"%@/%@", [self getResourcePath:[self getResourceId] forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil], endPoint];
    
    [[ObjectiveNetwork sharedInstance] postCustomData:data dataName:dataName toEndPoint:path WithSuccessCallback:^(AFHTTPRequestOperation *operation, id object) {
        
        if( onSuccess ){
            NSLog(@"%d", operation.response.statusCode);
            NSLog(@"%@", operation.request.HTTPMethod);
            NSLog(@"%@", operation.request.URL);
            NSLog(@"%@", operation.responseString);
            onSuccess( operation, nil );
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError( operation, error );
        }
    } progressCallback:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if( progressBlock ){
            progressBlock( bytesWritten, totalBytesWritten, totalBytesExpectedToWrite );
        }
    }];    
};

//PUT Requesters :::::

- (void)updateWithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSDictionary *dictRepresentation = [ObjectiveSerializer serialize:self forClass:[self class]];
    
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"PUT" path:[[self class] appendSerializationExtension:[self getResourcePath:[self getResourceId] forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil]] parameters:[NSDictionary dictionaryWithObject:dictRepresentation forKey:[[self className] underscore]]];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Update operation succeeded DATA: %@ from %@", operation.responseString, operation.request.URL);
        if(onSuccess){
            onSuccess( operation ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
}

// DELETE Requesters :::::

- (void)destroyWithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"DELETE" path:[[self class] appendSerializationExtension:[self getResourcePath:[NSString stringWithFormat:@"%@", [self getResourceId]] forAssociationOrNil:nil andAssociatedObjectIdOrNil:nil]] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(onSuccess){
            onSuccess( operation ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
    
    
}

- (void)destroyAssociation:(ObjectiveRecord *)associate WithSuccessCallback:(void(^)(AFHTTPRequestOperation *operation))onSuccess failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onError{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSMutableURLRequest *request = [[ObjectiveNetwork sharedInstance] requestWithMethod:@"DELETE" path:[[self class] appendSerializationExtension:[self getResourcePath:[NSString stringWithFormat:@"%@", [self getResourceId]] forAssociationOrNil:[[associate class] getResourceName] andAssociatedObjectIdOrNil:[associate getResourceId]]] parameters:nil];
    
    [ request setCachePolicy:NSURLRequestReloadRevalidatingCacheData ];
    [ request setTimeoutInterval:[ ObjectiveNetwork getDefaultTimeout ] ];
    
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"destroyed association with url: %@", operation.request.URL);
        if(onSuccess){
            onSuccess( operation ); 
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[ObjectiveNetwork sharedInstance] printError:error andOperation:operation];
        if( onError ){
            onError(operation, error);
        }
    }];
    
    [operation start];
    
}






//==================== HELPERS ============================//

- (void)printError:(NSError *)error andOperation:(AFHTTPRequestOperation *)operation{
    NSLog(@"%@", @"\n\n\n\n");
    NSLog(@"*******************************\n%@\n*******************************", error.description);
    NSLog(@"*******************************\n%@\n*******************************", operation);
    NSLog(@"%@", @"\n\n\n\n");
}

- (NSString *)getResourcePath:(NSNumber *)objectIdOrNil forAssociationOrNil:(NSString *) associationOrNil andAssociatedObjectIdOrNil:(NSString *)associatedObjectIdOrNil{
    NSString *association = @"";
    if(associationOrNil){
        association = [@"/" stringByAppendingString:[[associationOrNil lowercaseString] underscore]];
        if(associatedObjectIdOrNil){
            association = [association stringByAppendingFormat:@"/%@", associatedObjectIdOrNil];
        }
    }
    if(objectIdOrNil != nil){        
        return [[[[[self class] getResourceName] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%@", objectIdOrNil]] stringByAppendingString:association ];
    }else{
        return [[[self class] getResourceName] stringByAppendingString:association ];
    }
}

+ (NSString *)getResourcePath:(NSNumber *)objectIdOrNil forAssociationOrNil:(NSString *) associationOrNil andAssociatedObjectIdOrNil:(NSString *)associatedObjectIdOrNil{
    NSString *association = @"";
    if(associationOrNil){
        association = [@"/" stringByAppendingString:[[associationOrNil lowercaseString] underscore]];
        if(associatedObjectIdOrNil){
            association = [association stringByAppendingFormat:@"/%@", associatedObjectIdOrNil];
        }
    }
    if(objectIdOrNil != nil){        
        return [[[[self getResourceName] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%@", objectIdOrNil]] stringByAppendingString:association ];
    }else{
        return [[self getResourceName] stringByAppendingString:association ];
    }
}

+ (NSString *)getResourceName{
    return [[NSStringFromClass([self class]) underscore] stringByAppendingString:@"s"];
}


-(NSString *)getResourceId{
    Class myClass = [self class];
    NSString *myIdPoperty = [[NSStringFromClass(myClass) stringByAppendingString:@"Id"] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[NSStringFromClass(myClass) substringToIndex:1] lowercaseString]];
    return([self valueForKey:myIdPoperty]);
}

+(NSString *)appendSerializationExtension:(NSString *)path{
    return [path stringByAppendingString:@".json"];
}

-(BOOL)isEqualToRecord:(ObjectiveRecord *)record{
    if(([self class] == [record class]) && ([[self getResourceId] caseInsensitiveCompare:[record getResourceId]] == NSOrderedSame)){
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)belongsToRecord:(ObjectiveRecord *)record{
    Class recordClass = [record class];
    NSString *recordIdProperty = [[NSStringFromClass(recordClass) stringByAppendingString:@"Id"] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[NSStringFromClass(recordClass) substringToIndex:1] lowercaseString]];
    return ([[self valueForKey:recordIdProperty] caseInsensitiveCompare:[record valueForKey:recordIdProperty]] == NSOrderedSame);
}
-(BOOL)hasRecord:(ObjectiveRecord *)record{
    NSString *recordResouceName = [[record class] getResourceName];
    NSMutableArray *children = [self valueForKey:recordResouceName];
    if(children && [children isKindOfClass:[NSMutableArray class]]){
        for(ObjectiveRecord * child in children){
            if([child isEqualToRecord:record]){
                return  YES;
            }
        }
    }
    return NO;
}



@end
