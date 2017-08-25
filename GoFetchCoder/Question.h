//
//  Question.h
//  GoFetchCoder
//
//  Created by Guest on 1/20/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic,copy  ) NSString  *question;
@property (nonatomic,assign) NSInteger questionId;
@property (nonatomic,copy  ) NSDate  *createdDate;


@end
