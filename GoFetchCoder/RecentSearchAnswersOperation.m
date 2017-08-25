//
//  RecentSearchAnswersOperation.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RecentSearchAnswersOperation.h"
#import "Constants.h"
#import "RecentSearchAnswer.h"
#import "NSString+HTML.h"
#import "NSString+GFCAdditions.h"
#import "NSString_stripHTML.h"


@implementation RecentSearchAnswersOperation


- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        if (self.questionId == -1)
            return;
        
        [super main];
        
        NSString *requestString = [NSString stringWithFormat:@"%@%@%ld",kBaseUrl,kRecentSearchAnswersAPI,(long)_questionId];
        
        
        NSLog(@"Request  : \n\n %@",requestString);
        
        NSURL *url                   = [NSURL URLWithString:requestString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        request.HTTPMethod = @"GET";
        
        NSString *authToken     = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
        
        NSLog(@"Token : \n\n %@", kAuthToken);
        
        [request setValue:authToken forHTTPHeaderField:kAuthToken];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // 2
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            BOOL isSuccess = false;
            __block id answers = nil;

            if (!error) {
                error = nil;
                id json  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                
                NSLog(@"json  : \n\n %@",json);

                if (!error) {
                    
                    if ([json isKindOfClass:[NSArray class]]) {
                        
                        answers = [NSMutableArray array];
                        
                        isSuccess = true;
                        [(NSArray *)json enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            
                            RecentSearchAnswer *a  = [[RecentSearchAnswer alloc] init];
                            
                            a.sectionSequenceId    = d[@"sectionSequenceId"];
                            a.sectionSequenceTitle = d[@"sectionSequenceTitle"];
                            a.chapterTitle         = d[@"chapterTitle"];
                            a.body                 = [[[d[@"body"] stringByConvertingHTMLToPlainText] stripHtml] trim];
                            a.score                = [d[@"score"] integerValue];
                            
                            [answers addObject:a];
                            
                            
                        }];
                        
                    }
                    else {
                        isSuccess = false;
                        answers = (NSDictionary *)json;
                    }
                  
                }
            }
            
            if (isSuccess)
                self.onSuccess(answers);
            else self.onFailure(answers);
            
        }];
        
        [dataTask resume];
        
    }
}

@end
