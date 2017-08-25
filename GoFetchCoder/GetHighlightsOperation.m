//
//  GetHighlightsOperation.m
//  GoFetchCoder
//
//  Created by Sandro Albert on 4/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "GetHighlightsOperation.h"
#import "Constants.h"
#import "Highlight.h"
#import "NSString+GFCAdditions.h"

@implementation GetHighlightsOperation
- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        [super main];
        
        NSLog(@"%s [Line:%d]", __PRETTY_FUNCTION__, __LINE__);
        
        NSString *requestString = [NSString stringWithFormat:@"%@%@%@",kBaseUrl,kGetHighlightsAPI, _chapterNo];
        
        NSLog(@"Request  : \n\n %@",requestString);
        
        NSURL *url                   = [NSURL URLWithString:requestString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"GET";
        
        NSString *authToken     = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
        
        [request setValue:authToken forHTTPHeaderField:kAuthToken];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        // 2
        
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            BOOL isSuccess = false;
            id jsonResponse = nil;
            
            __block NSMutableArray *highlights = [NSMutableArray array];
            if (!error) {
                error = nil;
                jsonResponse  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"jsonResponse  : \n\n %@",jsonResponse);
                if (!error) {
                    //parse here ...
                    if ([jsonResponse isKindOfClass:[NSArray class]]) {
                        jsonResponse = (NSArray *)jsonResponse;
                        [jsonResponse enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            Highlight *h            = [[Highlight alloc] init];
                            h.startIndex           = d[@"startIndex"];
                            h.endIndex            = d[@"endIndex"];
                          
                            [highlights addObject:h];
                        }];
                        
                        
                        isSuccess = YES;
                    }
                    else {
                        isSuccess = NO;
                    }
                    
                    
                }
                else {
                    isSuccess = NO;
                }
                
            }
            
            
            // Success Failure block
            if (isSuccess)
                self.onSuccess([NSArray arrayWithArray:[self convertNSObjectToNSDictionary:highlights]]);
            else {
                self.onFailure(jsonResponse);
            }
            
        }];
        
        [dataTask resume];
        
    }
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


@end
