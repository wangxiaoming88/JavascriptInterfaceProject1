//
//  RecentSearchQuestionsOperation.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RecentSearchQuestionsOperation.h"
#import "Constants.h"
#import "Question.h"


@implementation RecentSearchQuestionsOperation

- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        [super main];
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
        
        NSString *requestURLString = [NSString stringWithFormat:@"%@%@",kBaseUrl,kRecentSearchQuestionsAPI];
        
        NSURL *url  = [NSURL URLWithString:requestURLString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"GET";
        
        [request setValue:authToken forHTTPHeaderField:kAuthToken];
        
        // 2
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         //   NSLog(@"Response data :%lu bytes",data.length);
            
            BOOL isSuccess = false;
            __block NSMutableArray *questions = [NSMutableArray array];
            
            if (!error) {
                error = nil;
                id json  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"jsonResponse  : \n\n %@",json);
                if (!error) {
                    
                    if (json && [json isKindOfClass:[NSArray class]]) {
                        isSuccess = true;
                        
                        [(NSArray *)json enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL * _Nonnull stop) {
                            Question *q = [[Question alloc] init];
                            if ([d[@"question"] containsString:@"__NSMallocBlock__"]) {
                                return ;
                            }
                            q.question    = d[@"question"];
                            q.questionId  = [d[@"id"] integerValue];
                            q.createdDate = [NSDate dateWithTimeIntervalSince1970:[d[@"createdDate"] doubleValue]/1000];
                            
                            [questions addObject:q];
                        }];
                    }
                }
            }
            if (self.onCompletion) {
                self.onCompletion(questions,isSuccess);
            }
        }];
        
        [dataTask resume];
    }
}

@end

