//
//  RecentSearchQuestionsOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentSearchQuestionsOperation : NSOperation

typedef void(^CompletionBlock)(NSArray *responseArray,BOOL isSuccess);

@property(nonatomic,copy)NSString *sequenceId;
@property(nonatomic,copy)NSString *sectionTitle;

@property (nonatomic, copy) CompletionBlock onCompletion;



@end
