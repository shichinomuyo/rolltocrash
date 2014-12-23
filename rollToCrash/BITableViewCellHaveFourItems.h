//
//  BIOtherAppsTableViewCell.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2014/11/11.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BITableViewCellHaveFourItems : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewAppIcon;
@property (weak, nonatomic) IBOutlet UILabel *labelAppName;
@property (weak, nonatomic) IBOutlet UILabel *labelFee;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelPurchased;
+ (CGFloat)rowHeight;

@end
