//
//  Bookmark.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bookmark : NSObject
@property (nonatomic,copy  ) NSString  *sectionSequenceId;
@property (nonatomic,copy  ) NSString  *sectionSequenceTitle;
@property (nonatomic,copy  ) NSDate  *updatedDate;
@property (nonatomic,copy  ) NSString  *hyperlink;
@property (nonatomic,assign) NSInteger bookmarkId;

@end
