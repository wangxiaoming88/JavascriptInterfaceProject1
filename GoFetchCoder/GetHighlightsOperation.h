//
//  GetHighlightsOperation.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 4/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetHighlightsOperation : NSOperation
//typedef void(^CompletionBlock)(NSArray *bookmarks,BOOL isSuccess);
typedef void(^SuccessBlock)(NSArray *highlights);
typedef void(^FailureBlock)(NSDictionary *failureDict);

//@property (nonatomic, copy) CompletionBlock onCompletion;
@property (nonatomic, weak) NSString *chapterNo;
@property (nonatomic, copy) SuccessBlock onSuccess;
@property (nonatomic, copy) FailureBlock onFailure;
@end
