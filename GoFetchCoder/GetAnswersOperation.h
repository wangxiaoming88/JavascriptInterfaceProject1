//
//  GetAnswersOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/27/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetAnswersOperation : NSOperation

typedef void(^CompletionBlock)(NSArray *responseArray,BOOL isSuccess);

@property(nonatomic,copy)NSString *question;

@property(nonatomic,copy) CompletionBlock onCompetion;

@end
