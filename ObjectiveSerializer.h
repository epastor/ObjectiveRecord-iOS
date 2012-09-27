//
//  ObjectiveSerializer.h
//  ObjectiveRecord
//
//  Created by Emmanuel Pastor on 22/12/11.
//  Copyright (c) 2011 Medinetik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+InflectionSupport.h"

@interface ObjectiveSerializer : NSObject{

}

+(id) deserialize:(id)data;
+(id) serialize:(id)data forClass:(Class)aClass;
+(void) overwritePropertiesOfObject:(id)object withObject:(id)overwriter;
+ (NSString *) convertProperty:(NSString *)propertyName andClassName:(NSString *)className;
+(BOOL) couldBeDate:(NSString *)string;
@end
