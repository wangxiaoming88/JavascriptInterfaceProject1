//
//  GetAnswersOperation.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/27/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "GetAnswersOperation.h"
#import "Constants.h"
#import "Answer.h"
#import "NSString+HTML.h"
#import "NSString+GFCAdditions.h"
#import "NSString_stripHTML.h"


@implementation GetAnswersOperation




- (void)main {
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        
        NSString *requestURLString = [NSString stringWithFormat:@"%@%@%@",kBaseUrl,kAskAQuestionAPI,_question];
        
        requestURLString =[requestURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSURL *url  = [NSURL URLWithString:requestURLString];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        request.HTTPMethod = @"GET";
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
        [request setValue:authToken forHTTPHeaderField:kAuthToken];
        
        __block BOOL isSuccess = NO;
        
        // 2
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          //  NSLog(@"Response data  : \n\n %@",data);
            
            __block NSMutableArray *datasource = [[NSMutableArray alloc] init];
            
            if (!error) {
                error = nil;
                NSDictionary *jsonResponse  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                NSLog(@"jsonResponse  : \n\n %@",jsonResponse);
                
                if (error == nil) {
                    
                    if (jsonResponse[@"error"]) {
                        Answer *a = [[Answer alloc] init];
                        a.answer =  jsonResponse[@"message"];
                        a.sectionName = jsonResponse[@"error"];
                        [datasource addObject:a];

                    }
                    else {
                        NSArray *array  = jsonResponse[@"responses"];
                        if (array.count > 0) {
                            isSuccess = true;
                        }
                        [array enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL * _Nonnull stop) {
                            Answer *a = [[Answer alloc] init];
                            
                            
                            a.answer        = [[[d[@"answer"] stringByConvertingHTMLToPlainText]  stripHtml] trim];
                            a.idWatson      = [d[@"idWatson"] integerValue];
                            a.sectionName   = d[@"sectionName"];
                            a.snip          = [[[d[@"snip"] stringByConvertingHTMLToPlainText]  stripHtml] trim];
                            a.confidence    = [d[@"confidence"] integerValue];
                            a.hyperlink     = d[@"hyperlink"];
                            a.sectionNumber = d[@"sectionNumber"];
                            a.chapterNo     = d[@"chapterNo"];
                            
                            [datasource addObject:a];
                        }];

                    }
                }
            }
            
            
            if (self.onCompetion) {
                self.onCompetion(datasource,isSuccess);
            }
            
            
            
        }];
        
        [dataTask resume];

        
        
       
        

    }
}


@end
