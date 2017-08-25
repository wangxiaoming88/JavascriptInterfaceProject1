//
//  Answer.h
//  GoFetchCoder
//
//  Created by Guest on 1/17/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

@property (nonatomic,copy  ) NSString  *answer;
@property (nonatomic,assign) NSInteger idWatson;
@property (nonatomic,copy  ) NSString  *sectionName;
@property (nonatomic,copy  ) NSString  *snip;
@property (nonatomic,assign) NSInteger confidence;
@property (nonatomic,copy  ) NSString  *hyperlink;
@property (nonatomic,copy  ) NSString  *sectionNumber;
@property (nonatomic,copy  ) NSString  *chapterNo;


@end
