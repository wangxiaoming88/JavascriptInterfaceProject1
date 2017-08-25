//
//  GetBookmarks.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "GetBookmarksOperation.h"
#import "Constants.h"
#import "Bookmark.h"
#import "NSString+GFCAdditions.h"

@implementation GetBookmarksOperation


- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
         [super main];
        
        NSLog(@"%s [Line:%d]", __PRETTY_FUNCTION__, __LINE__);

        NSString *requestString = [NSString stringWithFormat:@"%@%@",kBaseUrl,kGetBookmarksAPI];

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
            
            __block NSMutableArray *bookmarks = [NSMutableArray array];
            if (!error) {
                error = nil;
                jsonResponse  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"jsonResponse  : \n\n %@",jsonResponse);
                if (!error) {
                    //parse here ...
                    if ([jsonResponse isKindOfClass:[NSArray class]]) {
                        jsonResponse = (NSArray *)jsonResponse;
                        [jsonResponse enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            Bookmark *b            = [[Bookmark alloc] init];
                            b.bookmarkId           = [d[@"id"] integerValue];
                            b.hyperlink            = d[@"hyperlink"];
                            b.sectionSequenceId    = [d[@"sectionSequenceId"] trim];
                            b.sectionSequenceTitle = [d[@"sectionSequenceTitle"] trim];
                            b.updatedDate          = [NSDate dateWithTimeIntervalSince1970:[d[@"updatedDt"] doubleValue]/1000];
                            
                            [bookmarks addObject:b];
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
                self.onSuccess([NSArray arrayWithArray:bookmarks]);
            else {
                self.onFailure(jsonResponse);
            }
            
        }];
        
        [dataTask resume];
        
    }
}
@end
