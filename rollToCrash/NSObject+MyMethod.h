//
//  NSObject+MyMethod.h
//  BodyImpersonator
//
//  Created by 七野祐太 on 2015/01/06.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MyMethod)
+ (UIViewController*)topMostController;
+ (UIViewController*)topViewController;
@end
