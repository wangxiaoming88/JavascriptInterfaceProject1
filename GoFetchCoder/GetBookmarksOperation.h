//
//  GetBookmarksOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetBookmarksOperation : NSOperation

//typedef void(^CompletionBlock)(NSArray *bookmarks,BOOL isSuccess);
typedef void(^SuccessBlock)(NSArray *answers);
typedef void(^FailureBlock)(NSDictionary *failureDict);

//@property (nonatomic, copy) CompletionBlock onCompletion;

@property (nonatomic, copy) SuccessBlock onSuccess;
@property (nonatomic, copy) FailureBlock onFailure;


@end
