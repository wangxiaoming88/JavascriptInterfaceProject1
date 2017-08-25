//
//  UIColor+GFCAdditions.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/29/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "UIColor+GFCAdditions.h"

@implementation UIColor (GFCAdditions)

+(UIColor *)colorFromHex:(NSString*)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    if (hexString.length>0)
        [scanner setScanLocation:1]; // bypass '#' character
    
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


+(UIColor *)inputTextFieldColor {
    return [self colorFromHex:@"#a1a8ad"];
}

+(UIColor *)defaultColor{
     return [self colorFromHex:@"#29b866"];
}

+(UIColor *)editLineColor{
    return [self colorFromHex:@"#c0c0c0"];
}

+(UIColor *)actionbarLineColor{
    return [self colorFromHex:@"#2ecc71"];
}

+(UIColor *)editColor{
    return [self colorFromHex:@"#000000"];
}
@end
