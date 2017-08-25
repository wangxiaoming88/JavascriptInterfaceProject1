//
//  RemoveBookmarkOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RemoveBookmarkCompletionBlock)(NSString *responseString,BOOL isSuccess);

@interface RemoveBookmarkOperation : NSOperation

@property(nonatomic,assign)NSInteger bookmarkId;

@property (nonatomic, copy) RemoveBookmarkCompletionBlock onCompletion;





@end
