//
//  AppHelper.m
//  iDoctor
//
//  Created by Emmanuel Pastor on 30/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppHelper.h"
//#import "SVProgressHUD.h"


@implementation AppHelper

static NSArray* alpha;

+(NSArray *) alphabet{
    if(alpha == nil){
        alpha = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",
          @"L",@"M",@"N", @"Ñ", @"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",nil];
    }
    return alpha;
}

+(NSString *)date:(NSDate *)date ToStringWithFormat:(NSString *)format{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [dateFormatter release];
    return dateString;
}

+(NSDate *)string:(NSString *)string ToDateWithFormat:(NSString *)format{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *utcDate = [dateFormatter dateFromString:string];
    [dateFormatter release];
    return utcDate;
}



@end
