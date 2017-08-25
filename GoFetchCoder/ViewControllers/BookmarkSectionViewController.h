//
//  BookmarkSectionViewController.h
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BookmarkSectionViewController : BaseViewController
@property(nonatomic,copy)NSString *hyperlink;
@property(nonatomic,copy)NSString *sectionSequenceId;
@property(nonatomic,copy)NSString *sectionSequenceTitle;
@property Boolean isBookmarked;
@property NSInteger bookmarkId;

@end
