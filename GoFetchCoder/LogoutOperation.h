//
//  LogoutOperation.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogoutOperation : NSOperation



typedef void(^SuccessBlock)();
typedef void(^FailureBlock)(NSDictionary *failureDict);


@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;

@property (nonatomic, copy)SuccessBlock onSuccess;
@property (nonatomic, copy)FailureBlock onFailure;



@end
