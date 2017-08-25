//
//  BrowseCodesDetailVC.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 2/27/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BrowseCodesDetailVC : BaseViewController


@property(nonatomic,copy)NSString *hyperlink;
@property(nonatomic,copy)NSString *screenTitle;

@property Boolean isBookmarked;
@property NSInteger bookmarkId;
@end
