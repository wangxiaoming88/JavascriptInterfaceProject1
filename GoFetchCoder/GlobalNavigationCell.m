//
//  GlobalNavigationCell.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/5/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "GlobalNavigationCell.h"
#import "UIColor+GFCAdditions.h"

@implementation GlobalNavigationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (selected) {
        self.backgroundColor = [UIColor colorFromHex:@"#219452"];
        self.lblText.textColor = [UIColor whiteColor];
        self.imageView.image = [UIImage imageNamed:self.selectedImageName];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
        self.lblText.textColor = [UIColor colorFromHex:@"#29b866"];
        self.imageView.image = [UIImage imageNamed:self.unSelectedImageName];
    }
}


//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
//{
//    [super setHighlighted:highlighted animated:animated];
//
//    if (highlighted) {
//        self.backgroundColor = self.selectedBackgroundColor;
//        self.lblText.textColor = self.selectedTextColor;
//    }
//    else {
//        self.backgroundColor = self.unSelectedBackgroundColor;
//        self.lblText.textColor = self.unSelectedTextColor;
//        
//    }
//
//}

@end
