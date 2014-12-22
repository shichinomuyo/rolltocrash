//
//  SettingsViewController.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/12/22.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShare;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShareImages;
@property (nonatomic, strong) NSArray *dataSourceOtherApps;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsImages;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsDesc;

@property (weak, nonatomic) IBOutlet UITableView *tableViewSettings;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:0];
    
    self.tableViewSettings.delegate = self;
    self.tableViewSettings.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
