//
//  DropDownButton.h
//  GoFetchCoder
//
//  Created by Kuldeep Mishra on 28/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DropDownButton : UIButton<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong)NSArray *pickerItems;

@end
