//
//  NSUserDefaults+Extension.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extension)

- (void)saveCustomObject:(id<NSCoding>)object
                     key:(NSString *)key;
- (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key;


@end
