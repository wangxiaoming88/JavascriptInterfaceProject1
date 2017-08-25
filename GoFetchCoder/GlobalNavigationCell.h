//
//  GlobalNavigationCell.h
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/5/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlobalNavigationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *lblImageView;

@property (weak, nonatomic) IBOutlet UILabel *lblText;

@property(nonatomic,strong)NSString *selectedImageName;
@property(nonatomic,strong)NSString *unSelectedImageName;





@end
