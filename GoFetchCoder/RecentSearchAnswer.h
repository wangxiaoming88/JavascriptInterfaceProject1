//
//  RecentSearchAnswer.h
//  GoFetchCoder
//
//  Created by Guest on 1/20/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentSearchAnswer : NSObject

@property (nonatomic,copy  ) NSString  *sectionSequenceId;
@property (nonatomic,copy  ) NSString  *sectionSequenceTitle;
@property (nonatomic,copy  ) NSString  *chapterTitle;
@property (nonatomic,copy  ) NSString  *body;
@property (nonatomic,assign) NSInteger score;
@property (nonatomic,copy  ) NSString  *version;
@property (nonatomic,copy  ) NSString  *featureVector;

@end
