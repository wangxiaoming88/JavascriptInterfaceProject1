//
//  RecentSearchAnswersOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentSearchAnswersOperation : NSOperation




typedef void(^SuccessBlock)(NSArray *bookmarks);
typedef void(^FailureBlock)(NSDictionary *failureDict);

@property(nonatomic,assign)NSInteger questionId;
//@property(nonatomic,assign)NSString *sectionTitle;

@property (nonatomic, copy) SuccessBlock onSuccess;
@property (nonatomic, copy) FailureBlock onFailure;


@end
