//
//  DataManager.m
//  GoFetchCoder
//
//  Created by Guest on 1/18/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "DataManager.h"
#import "Answer.h"
#import "Question.h"
#import "RecentSearchAnswer.h"
#import "NSString+HTML.h"
#import "NSString_stripHTML.h"
#import "Constants.h"
#import "NSString+GFCAdditions.h"

@implementation DataManager


+ (id)sharedManager {
    static DataManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {}
    return self;
}





#pragma mark - Ask A Question -

-(NSDictionary *)getAnswersForQuestion:(NSString *)question {
    
    
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthToken];
    
    NSString * baseURL = @"http://do.gofetchcode.com/api/secure/ask?question=";
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@%@",baseURL,question];
    
    requestURLString =[requestURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url  = [NSURL URLWithString:requestURLString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"GET";
    
    [request setValue:authToken forHTTPHeaderField:kAuthToken];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) {
        NSLog(@"Error parsing JSON.: %@",error.description);
    }
    else {
        NSLog(@"jsonDict: %@", jsonDict);
        
    }
    
    return jsonDict;
    
}



#pragma mark - Parsing Methods -

- (NSArray *)parseAnswersResponse:(NSDictionary *)responseDict {
    
    __block NSMutableArray *datasource = [[NSMutableArray alloc] init];
    
    if (!responseDict) {
        
        Answer *a = [[Answer alloc] init];
        a.answer =  @"Sorry ! The Service is temporary unavailable :(";
        a.sectionName = @"Sorry";
        a.sectionNumber = @"";
        [datasource addObject:a];
        return [[NSArray alloc] initWithArray:datasource];
    }
    
    if (responseDict[@"error"]) {
        Answer *a = [[Answer alloc] init];
        a.answer =  responseDict[@"message"];
        a.sectionName = responseDict[@"error"];
        [datasource addObject:a];
        return [[NSArray alloc] initWithArray:datasource];
    }
    
    
    
    NSArray *array  = responseDict[@"responses"];
    
    
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
    
    
    return [[NSArray alloc] initWithArray:datasource];
}


@end
