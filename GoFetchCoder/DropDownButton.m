//
//  DropDownButton.m
//  GoFetchCoder
//
//  Created by Kuldeep Mishra on 28/01/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "DropDownButton.h"

@implementation DropDownButton

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerItems.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [self getWidth], [pickerView rowSizeForComponent:component].height)];
    label.text = self.pickerItems[row];
    
    return label;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20.0f;
}

-(NSInteger)getWidth {
    return [UIScreen mainScreen].bounds.size.width - 2*40;
}

@end
