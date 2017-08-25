//
//  UIWebView+GFCAddition.m
//  GoFetchCoder
//
//  Created by Sandro Albert on 4/6/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "UIWebView+GFCAddition.h"
#import "Highlight.h"
#import "Base64.h"
#import "AppDelegate.h"
#import "AddHighLightOperation.h"
#import "AddBookmarkOperation.h"
#import "GetHighlightsOperation.h"

@implementation UIWebView (GFCAdditions)

//- (NSArray *)getHighlights:(NSString *)chapterNo datasource:(NSArray *)datasource{
//    AppDelegate *appDelegate = kAppDelegate;
//    
//    GetHighlightsOperation *highlightsOperation = [[GetHighlightsOperation alloc] init];
//    highlightsOperation.chapterNo = chapterNo;
//    
//    highlightsOperation.onSuccess = ^(NSArray *highlights) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (highlights.count) {
//                
//                datasource = highlights;
//                
//            }
//            else {
//                
//            }
//        });
//    };
//    
//    highlightsOperation.onFailure = ^(NSDictionary *failureDict) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
//        
//    };
//    
//    [appDelegate.queue addOperation:highlightsOperation];
//    
//    return self.datasource;
//}

- (void)highlight:(NSString *)chapterNo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    
    NSString *startSearch   = [NSString stringWithFormat:@"getHighlightedString()"];
   [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    NSString *highlight   = [NSString stringWithFormat:@"highlight()"];
    [self stringByEvaluatingJavaScriptFromString:highlight];
    
    
    NSString *selStartText   = [NSString stringWithFormat:@"selStart"];
    NSString *selStart = [self stringByEvaluatingJavaScriptFromString:selStartText];
    
    NSString *selEndText   = [NSString stringWithFormat:@"selEnd"];
    NSString *selEnd = [self stringByEvaluatingJavaScriptFromString:selEndText];
    
    NSString *startText   = [NSString stringWithFormat:@"start"];
    NSString *start = [self stringByEvaluatingJavaScriptFromString:startText];
    
    [self addHighlight:chapterNo selStart:selStart selEnd:selEnd];
    
}

- (void)bookmark:(NSString *)chapterNo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];

    NSString *highlight   = [NSString stringWithFormat:@"bookmark()"];
    [self stringByEvaluatingJavaScriptFromString:highlight];
    
    NSString *selStringText   = [NSString stringWithFormat:@"selString"];
    NSString *selString = [self stringByEvaluatingJavaScriptFromString:selStringText];
    NSLog(@"%@", @"selString = ");
    NSLog(@"%@", selString);
    
    NSString *selStartText   = [NSString stringWithFormat:@"selStart"];
    NSString *selStart = [self stringByEvaluatingJavaScriptFromString:selStartText];
    
    NSString *selEndText   = [NSString stringWithFormat:@"selEnd"];
    NSString *selEnd = [self stringByEvaluatingJavaScriptFromString:selEndText];
    
    [self addBookmark:chapterNo bookmarkString:[NSString stringWithFormat:@"%@", selStart]];
    
}

- (void)addBookmark:(NSString *)chapterNo bookmarkString:(NSString *)bookmarkString {
    
    //    NSLog(@"%@",_webview.scrollView.contentOffset);
    
    //return;
    //bookmark ...
    
    AppDelegate *appDelegate = kAppDelegate;
    
   
        AddBookmarkOperation *addBookmark = [[AddBookmarkOperation alloc] init];
        addBookmark.sequenceId            = chapterNo;
        addBookmark.sectionTitle          = bookmarkString;
        
        addBookmark.onCompletion = ^(NSDictionary *jsonResponse,BOOL isSuccess) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isSuccess) {
                  
                   
//                    [self hideLoadingIndicator];
                    
                    //[self showErrorAlertWithTitle:@"" andDesription:@"Bookmark Added successfully"];
                }
                else {
                 
//                    _bookmarkId = kInvalid;
                    // [self showErrorAlertWithTitle:jsonResponse[@"error"] andDesription:jsonResponse[@"message"]];
//                    [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
                    
                }
                
//                [self updateBookmarkImage];
                
            });
        };
        [appDelegate.queue addOperation:addBookmark];
   
    
}




- (NSArray *)convertNSObjectToNSDictionary: (NSArray *)array{
    
    NSMutableArray *convertArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < array.count ; i++) {
        Highlight *item = array[i];
        NSDictionary *dicItem = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:item.startIndex,item.endIndex,nil]
                                                            forKeys:[NSArray arrayWithObjects:@"startIndex",@"endIndex",nil]];
        
        [convertArray addObject:dicItem];
        
    }
    return [NSArray arrayWithArray:convertArray];
}


- (void)setHighlight:(NSArray *)datasource{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    
    
//    NSArray *dataArray = [self convertNSObjectToNSDictionary:datasource];
    
    // Convert your array to JSON data
    NSData *jsonArray = [self arrayToJSON: datasource];
    // Pass the JSON to an UTF8 string
    NSString *jsonString = [[NSString alloc] initWithData:jsonArray
                                                 encoding:NSUTF8StringEncoding];
    // Base64 encode the string to avoid problems
    
    NSString *encodedString = [jsonString base64EncodedString];
    // Evaluate your JavaScript function with the encoded string as input
    
    NSString *setHighlightText = [NSString stringWithFormat:@"setHighlight('%@')",encodedString];
    [self stringByEvaluatingJavaScriptFromString:setHighlightText];
    
    NSString *jsonStringText   = [NSString stringWithFormat:@"jsonString"];
    NSString *jsonStr = [self stringByEvaluatingJavaScriptFromString:jsonStringText];
    
    NSLog(@"%@", @"jsonString = ");
    NSLog(@"%@", jsonStr);
    
    
    
    NSString *startText   = [NSString stringWithFormat:@"startInt"];
    NSString *start = [self stringByEvaluatingJavaScriptFromString:startText];
    
    NSLog(@"%@", @"start = ");
    NSLog(@"%@", start);
    
    NSString *endText   = [NSString stringWithFormat:@"endInt"];
    NSString *end = [self stringByEvaluatingJavaScriptFromString:endText];
    
    NSLog(@"%@", @"end = ");
    NSLog(@"%@", end);
    
    NSString *arrayLenText   = [NSString stringWithFormat:@"arrayLen"];
    NSString *arrayLen = [self stringByEvaluatingJavaScriptFromString:arrayLenText];
    
    NSLog(@"%@", @"arrayLen = ");
    NSLog(@"%@", arrayLen);
    
}

- (int)setBookmark:(int)start  end:(int)end{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UIWebViewSearch" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    [self stringByEvaluatingJavaScriptFromString:jsCode];
    
    NSString *setBookmarkText = [NSString stringWithFormat:@"showBookmark(%d,%d)",start, end];
    [self stringByEvaluatingJavaScriptFromString:setBookmarkText];
    
    NSString *startText   = [NSString stringWithFormat:@"start1"];
    NSString *start1 = [self stringByEvaluatingJavaScriptFromString:startText];
    
    NSLog(@"%@", @"start1 = ");
    NSLog(@"%@", start1);
    
    NSString *endText   = [NSString stringWithFormat:@"end1"];
    NSString *end1 = [self stringByEvaluatingJavaScriptFromString:endText];
    
    NSLog(@"%@", @"end1 = ");
    NSLog(@"%@", end1);

    
    NSString *scrollTopText   = [NSString stringWithFormat:@"scrollTop"];
    NSString *scrollTop = [self stringByEvaluatingJavaScriptFromString:scrollTopText];
    
    NSLog(@"%@", @"scrollTop = ");
    NSLog(@"%@", scrollTop);
    
    return [scrollTop intValue];
    
}

- (NSData *) arrayToJSON:(NSArray *) inputArray
{
    NSError *error;
    NSData *result = [NSJSONSerialization dataWithJSONObject:inputArray
                                                     options:kNilOptions
                                                       error:&error];
    if (error != nil) return nil;
    return result;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [super canPerformAction:action withSender:sender];
    if (self.superview != nil) {
        if (action == @selector(highlight:)) {
            return YES;
        }
    } else return NO;
    return NO;
}


- (void)addHighlight:(NSString *)chapterNo selStart:(NSString *)selStart selEnd:(NSString *)selEnd{
    AppDelegate *appDelegate = kAppDelegate;
    
    AddHighLightOperation *addHighlight = [[AddHighLightOperation alloc] init];
    addHighlight.chapter            = [chapterNo intValue];
    addHighlight.startIndex         = selStart;
    addHighlight.endIndex           = selEnd;
    
    addHighlight.onCompletion = ^(NSDictionary *jsonResponse,BOOL isSuccess) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                
            }
            else {
                
//                [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
                
            }
            
        });
    };
    [appDelegate.queue addOperation:addHighlight];
    
}
@end
