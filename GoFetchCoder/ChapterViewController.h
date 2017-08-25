//
//  ChapterViewController.h
//  GoFetchCoder
//
//  Created by Guest on 1/20/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ChapterViewController : BaseViewController

//Can be used if sequence id dont match section number.
//@property(nonatomic,strong)NSArray *answers;
@property(nonatomic,copy)NSString *hyperlink;
@property(nonatomic,copy)NSString *chapterNo;
@property(nonatomic,copy)NSString *sectionSequenceId;
@property(nonatomic,copy)NSString *sectionSequenceTitle;
@property (nonatomic, strong)NSString *searchQuestion;
@property (nonatomic, strong)NSString *sectionAnswer;

@property(nonatomic,assign)BOOL isBookmarked;
@property(nonatomic,assign) NSInteger bookmarkId; // used when coming from bookmark screen


@end
