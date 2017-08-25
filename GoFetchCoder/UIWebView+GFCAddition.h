//
//  UIWebView+GFCAddition.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 4/6/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (GFCAdditions)
- (int)setBookmark:(int)start  end:(int)end;
- (void)bookmark:(NSString *)chapterNo;
- (void)highlight:(NSString *)chapterNo;
- (NSArray *)convertNSObjectToNSDictionary: (NSArray *)array;
- (void)setHighlight:(NSArray *)datasource;
- (NSData *) arrayToJSON:(NSArray *) inputArray;
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender;
- (void)addHighlight:(NSString *)chapterNo selStart:(NSString *)selStart selEnd:(NSString *)selEnd;

@end
