//
//  AppHelper.h
//  iDoctor
//
//  Created by Emmanuel Pastor on 30/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppHelper : NSObject{
    
}

+(NSArray *)alphabet;
+(NSString *)date:(NSDate *)date ToStringWithFormat:(NSString *)format;
+(NSDate *)string:(NSString *)string ToDateWithFormat:(NSString *)format;


@end
