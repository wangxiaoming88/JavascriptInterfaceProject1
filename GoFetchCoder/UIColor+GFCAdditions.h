//
//  UIColor+GFCAdditions.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/29/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GFCAdditions)

+(UIColor *)colorFromHex:(NSString*)hexString;
+(UIColor *)inputTextFieldColor;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(UIColor *)defaultColor;
+(UIColor *)editLineColor;
+(UIColor *)actionbarLineColor;
+(UIColor *)editColor;
@end
