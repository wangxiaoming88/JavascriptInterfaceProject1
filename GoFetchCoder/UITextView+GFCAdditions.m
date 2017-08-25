//
//  UITextView+GFCAdditions.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/22/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "UITextView+GFCAdditions.h"

#define kMaxFieldHeight 9999

@implementation UITextView (GFCAdditions)

-(BOOL)sizeFontToFit:(NSString*)aString minSize:(float)aMinFontSize maxSize:(float)aMaxFontSize
{
    float fudgeFactor = 16.0;
    float fontSize = aMaxFontSize;
    
    self.font = [self.font fontWithSize:fontSize];
    
    CGSize tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
//    CGSize stringSize = [aString sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect rect = [aString boundingRectWithSize:tallerSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                       attributes:@{NSFontAttributeName:self.font} context:nil];
    
    CGSize stringSize = rect.size;
    while (stringSize.height >= self.frame.size.height)
    {
        if (fontSize <= aMinFontSize) // it just won't fit
            return NO;
        
        fontSize -= 1.0;
        self.font = [self.font fontWithSize:fontSize];
        tallerSize = CGSizeMake(self.frame.size.width-fudgeFactor,kMaxFieldHeight);
//        stringSize = [aString sizeWithFont:self.font constrainedToSize:tallerSize lineBreakMode:NSLineBreakByWordWrapping];

        stringSize = [aString boundingRectWithSize:tallerSize options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:self.font} context:nil].size;

        
        
    }
    
    return YES; 
}
@end
