//
//  UIFont+GFCAdditions.m
//  GoFetchCoder
//
//  Created by Kuldeep Mishra on 10/02/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "UIFont+GFCAdditions.h"

@implementation UIFont (GFCAdditions)
+(nullable  UIFont *)inputTextFieldFont {
    return [UIFont fontWithName:@"Lato-Regular" size:17.0];
}

+(nullable  UIFont *) smallTextFieldFont {
    return [UIFont fontWithName:@"Lato-Regular" size:13.0];
}
@end
