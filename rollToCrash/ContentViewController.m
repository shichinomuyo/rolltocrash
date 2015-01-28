//
//  SnareViewController.m
//  rollToCrash
//
//  Created by 七野祐太 on 2015/01/26.
//  Copyright (c) 2015年 shichino yuta. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    NSArray *arraySnareImageNames = [NSArray arrayWithObjects:
//                                     @"snare.png",
//                                     @"hitL1.png",
//                                     @"hitL2.png",
//                                     @"hitR1.png",
//                                     @"hitR2.png",nil];
//    
//    NSString *soundName = @"roll13";
//    NSString *caption = @"Snare";

    self.screenName = _caption;
    [self.kSnareView setImages:_imageNames soundName:_soundName capcion:_caption];

}


-(void)viewWillAppear:(BOOL)animated{
     NSLog(@"viewWillAppear");
    
  
}



-(void)viewDidAppear:(BOOL)animated{
     NSLog(@"viewDidAppear");
 

}

-(void)viewDidLayoutSubviews{
    NSLog(@"viewDidLayoutSubviews");

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.kSnareView stopAudioResetAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
