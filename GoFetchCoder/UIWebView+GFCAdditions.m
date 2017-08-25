//
//  UIWebView+GFCAdditions.m
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/31/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "UIWebView+GFCAdditions.h"

@implementation UIWebView_GFCAdditions

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    NSString *startSearch = [NSString stringWithFormat:@"window.onload = function (){uiWebview_HighlightAllOccurencesOfString('%@')}",str];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *result = [self stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    return [result integerValue];
}

- (void)removeAllHighlights
{
    [self stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}


- (void)highlight {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    
    NSString *startSearch   = [NSString stringWithFormat:@"getHighlightedString()"];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *startText   = [NSString stringWithFormat:@"start"];
    NSString * start = [self stringByEvaluatingJavaScriptFromString:startText];
    
    NSString *endText   = [NSString stringWithFormat:@"end"];
    NSString * end = [self stringByEvaluatingJavaScriptFromString:endText];
    
    NSString *selectedText   = [NSString stringWithFormat:@"selectedText"];
    NSString * highlightedString = [self stringByEvaluatingJavaScriptFromString:selectedText];
    
    NSString *highlight   = [NSString stringWithFormat:@"highlight()"];
    [self stringByEvaluatingJavaScriptFromString:highlight];
    
}

@end
