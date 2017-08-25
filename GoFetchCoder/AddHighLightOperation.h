//
//  AddHighLightOperation.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 4/1/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddHighLightOperation : NSOperation

typedef void(^CompletionBlock)(NSDictionary *jsonResponse,BOOL isSuccess);

@property(nonatomic,assign) int chapter;
@property(nonatomic,assign)NSString *startIndex;
@property(nonatomic,assign)NSString *endIndex;
@property (nonatomic, copy) CompletionBlock onCompletion;

@end
