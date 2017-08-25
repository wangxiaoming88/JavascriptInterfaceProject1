//
//  NSString+GFCAdditions.m
//  GoFetchCoder
//
//  Created by Kuldeep Mishra on 19/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "NSString+GFCAdditions.h"

@implementation NSString (GFCAdditions)

- (BOOL)isValidEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:self];

}

-(NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
