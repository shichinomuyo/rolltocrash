//
//  SnareViewController.h
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/26.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kPageView.h"
#import "GAITrackedViewController.h"

@interface ContentViewController : GAITrackedViewController{

}
@property NSArray *imageNames;
@property NSString *soundName;
@property NSString *caption;
@property NSUInteger pageIndex;

@property (strong, nonatomic) IBOutlet kPageView *kSnareView;

@end
