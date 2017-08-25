//
//  Bookmark.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "Bookmark.h"

@implementation Bookmark

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        [copy setSectionSequenceId:[self.sectionSequenceId copyWithZone:zone]];
        [copy setSectionSequenceTitle:[self.sectionSequenceTitle copyWithZone:zone]];
        [copy setUpdatedDate:[self.updatedDate copyWithZone:zone]];
        [copy setHyperlink:[self.hyperlink copyWithZone:zone]];
        [copy setBookmarkId:self.bookmarkId];
        
    }
    
    return copy;
}


@end
