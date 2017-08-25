//
//  UIWebView+GFCAdditions.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/31/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView_GFCAdditions : UIWebView
- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;
- (void)highlight;
@end
