//
//  DataManager.h
//  GoFetchCoder
//
//  Created by Guest on 1/18/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject


+ (id)sharedManager;

//Ask A Question:
- (NSDictionary *)getAnswersForQuestion:(NSString *)question;

// Parsing
- (NSArray *)parseAnswersResponse:(NSDictionary *)responseDict;

@end
