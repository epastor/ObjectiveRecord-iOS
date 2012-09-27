//
//  ObjectiveSerializer.m
//  ObjectiveRecord
//
//  Created by Emmanuel Pastor on 22/12/11.
//  Copyright (c) 2011 Medinetik. All rights reserved.
//

#import "ObjectiveSerializer.h"
#import "NSObject+PropertySupport.h"
#import "AppHelper.h"

@implementation ObjectiveSerializer

+(id) deserialize:(id)data{
    id entity = nil;
    if([data isKindOfClass: [NSDictionary class]]){
        NSString *entityName = [[data allKeys] objectAtIndex:0];
        NSLog(@"%@", entityName);
        Class entityClass = NSClassFromString([entityName toClassName]);
        entity = [[entityClass alloc]init];
        
        NSDictionary *properties = (NSDictionary *)[[(NSDictionary *)data allValues] objectAtIndex:0];
        if([properties isKindOfClass:[NSDictionary class]]){
            NSDictionary *objectPropertyNames = [entityClass propertyNamesAndTypes];
        
            for(NSString *property in properties){
                NSString *propertyCamalized = [[self convertProperty:property andClassName:entityName] camelize];
                if ([[objectPropertyNames allKeys]containsObject:propertyCamalized]) {
                    id value = [self deserialize:[properties objectForKey:property]];
                    [entity setValue:value forKey:propertyCamalized];
                }
            }
        }
    }else if([data isKindOfClass: [NSArray class]]){
        entity = [NSMutableArray array];
		for (id childObject in data) {
            id val = [self deserialize:childObject];
			if(val)[entity addObject:val];
		}
    }else if([data class] != [NSNull class]){
        if([data isKindOfClass:[NSString class]] && [self couldBeDate:data]){
            NSDate *date = [AppHelper string:[data stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange([data length] - 5,5)] ToDateWithFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            if(date){
                entity = date;
            }else{
                entity = data;
            }
        }else{
            entity = data;
        }
    }
    return entity;
}


 
+(id) serialize:(id)data forClass:(Class)aClass{
    id root = nil;
    if([data isKindOfClass:[NSDate class]]){
        root = [AppHelper date:data ToStringWithFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    }else if([data isKindOfClass: [NSArray class]]){
        if([data count] > 0){
            root = [NSMutableArray array];
            for(id child in data){
                [root addObject:[self serialize:child forClass:aClass]];
            }
        }
    }else if([data isKindOfClass:[NSObject class]] && ![data isKindOfClass:[NSString class]] && ![data
                                                                                                   isKindOfClass:[NSNumber class]]){
        root = [[NSMutableDictionary alloc] init];
        for(NSString *key in [[[data class] propertyNamesAndTypes] allKeys]){
            NSString *finalKey = key;
            if([key isEqualToString:[NSString stringWithFormat:@"%@Id", [NSStringFromClass(aClass) lowercaseString]]]){
                finalKey = @"temporaryId";
            }
            [ root setValue:[ self serialize:[ data valueForKey:key ] forClass:aClass] forKey:[finalKey underscore] ];
        }
    }else{
        if(data != nil){
            root = data;
        }else{
            root = [[NSNull alloc] init];
        }
    }
    return root;
}

+(void) overwritePropertiesOfObject:(id)object withObject:(id)overwriter{
    NSDictionary *objectPropertyNames = [[object class] propertyNamesAndTypes];
    for(__strong NSString *key in [objectPropertyNames allKeys]){
        key = [[self convertProperty:key andClassName:NSStringFromClass([self class])] camelize];
        //if([overwriter valueForKey:key] != nil){
            [object setValue:[overwriter valueForKey:key] forKey:key];
        //}
    }
}

+ (NSString *) convertProperty:(NSString *)propertyName andClassName:(NSString *)className {
	if([propertyName isEqualToString:@"id"] || [propertyName isEqualToString:@"_id"]) {
		propertyName = [NSString stringWithFormat:@"%@_id",className];
	}
	return propertyName;
}

+(BOOL) couldBeDate:(NSString *)string{
    NSArray *chunks = [string componentsSeparatedByString: @"-"];
    if(chunks.count >= 3){
        return YES;
    }else{
        return NO;
    }
}

@end
