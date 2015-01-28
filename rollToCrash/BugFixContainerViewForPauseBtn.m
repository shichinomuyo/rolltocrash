//
//  BugFixContainerViewForPauseBtn.m
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/28.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import "BugFixContainerViewForPauseBtn.h"

@implementation BugFixContainerViewForPauseBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    static CGPoint fixCenter = {0};
    [super layoutSubviews];
    if (CGPointEqualToPoint(fixCenter, CGPointZero)) {
        fixCenter = [self.knobUIButtonPauseBtn center];
    } else {
        NSLog(@"fixCenter");
        self.knobUIButtonPauseBtn.center = fixCenter;
    }
}
@end
