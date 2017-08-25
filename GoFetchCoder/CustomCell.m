//
//  CustomCell.m
//  GoFetchCoder
//
//  Created by Guest on 1/17/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
