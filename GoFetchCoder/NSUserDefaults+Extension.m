//
//  NSUserDefaults+Extension.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "NSUserDefaults+Extension.h"

@implementation NSUserDefaults (Extension)


- (void)saveCustomObject:(id<NSCoding>)object
                     key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [self setObject:encodedObject forKey:key];
    [self synchronize];
    
}

- (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key {
    NSData *encodedObject = [self objectForKey:key];
    id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}



@end
