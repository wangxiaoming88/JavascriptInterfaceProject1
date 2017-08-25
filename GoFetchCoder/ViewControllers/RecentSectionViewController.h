//
//  RecentSectionViewController.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/24/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RecentSectionViewController : BaseViewController
@property(nonatomic,copy)NSString *chapterNo;
@property(nonatomic,copy)NSString *hyperlink;
@property(nonatomic,copy)NSString *sectionSequenceId;
@property(nonatomic,copy)NSString *sectionSequenceTitle;
@property (nonatomic, strong)NSString *searchQuestion;
@property (nonatomic, strong)NSString *sectionAnswer;

@property (nonatomic, strong)NSArray *datasource;

@property(nonatomic,assign)BOOL isBookmarked;
@property(nonatomic,assign) NSInteger bookmarkId; // used when coming from bookmark screen
@end
