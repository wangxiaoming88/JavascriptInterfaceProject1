//
//  AddBookmarkOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/22/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface AddBookmarkOperation : NSOperation

typedef void(^CompletionBlock)(NSDictionary *jsonResponse,BOOL isSuccess);

@property(nonatomic,assign)NSString *sequenceId;
@property(nonatomic,assign)NSString *sectionTitle;

@property (nonatomic, copy) CompletionBlock onCompletion;







@end
