//
//  UITextView+GFCAdditions.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/22/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (GFCAdditions)

-(BOOL)sizeFontToFit:(NSString*)aString minSize:(float)aMinFontSize maxSize:(float)aMaxFontSize;

@end
