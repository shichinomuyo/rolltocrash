//
//  SettingsViewController.m
//  rollToCrash
//
//  Created by 七野祐太 on 2014/12/22.
//  Copyright (c) 2014年 shichino yuta. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()
@property (nonatomic, strong) NSArray *sectionList;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShare;
@property (nonatomic, strong) NSArray *dataSourceFeedbackAndShareImages;
@property (nonatomic, strong) NSArray *dataSourceOtherApps;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsImages;
@property (nonatomic, strong) NSArray *dataSourceOtherAppsDesc;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:0];

    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // section名のListを作成
    NSString *feedbackShareThisApp = [[NSString alloc] initWithFormat:NSLocalizedString(@"Feedback/ShareThisApp", nil)];
    NSString *otherApps = [[NSString alloc] initWithFormat:NSLocalizedString(@"OtherApps", nil)];
    self.sectionList = @[feedbackShareThisApp, otherApps];
    // sectionごとにデータソースを作成
    NSString *appStoreReview = [[NSString alloc] initWithFormat:NSLocalizedString(@"App Store review", nil)];
    NSString *shareThisApp = [[NSString alloc] initWithFormat:NSLocalizedString(@"Share This App", nil)];
    self.dataSourceFeedbackAndShare = @[appStoreReview, shareThisApp];//section0
    self.dataSourceFeedbackAndShareImages = [NSArray arrayWithObjects: @"TableCellIconCompose",@"TableCellIconShareThisApp", nil];//section0
    
    NSString *karadaMonomanizerName = [[NSString alloc] initWithFormat:NSLocalizedString(@"InstantMask", nil)];
    NSString *karadaMonomanizerDesc = [[NSString alloc] initWithFormat:NSLocalizedString(@"Make it easy,making a original mask!No more making a paper mask!", nil)]; //
    self.dataSourceOtherApps = @[karadaMonomanizerName];
    self.dataSourceOtherAppsImages = [NSArray arrayWithObjects:@"TableCellIconKaradaMonomanizer", nil];
    self.dataSourceOtherAppsDesc = @[karadaMonomanizerDesc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    // GoogleAnalystics導入にあたって必要
    self.screenName = @"RollToCrash_Settings";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    NSInteger sectionCount;
    sectionCount = [self.sectionList count];
    return sectionCount;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    NSInteger dataCount;
    switch (section) {
        case 0:
            dataCount = [self.dataSourceFeedbackAndShare count];
            break;
        case 1:
            dataCount = [self.dataSourceOtherApps count];
            break;
        default:
            break;
    }
    return dataCount;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *identifiers = @[@"CellFeedbackAndShare", @"CellHaveFourItems"];
    NSString *CellIdentifier = identifiers[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            BIFeedbakAndActionCell *feedbackAndShareCell = (BIFeedbakAndActionCell *)cell;
            
            UIImageView *imageViewFeedbackAction = (UIImageView *)[feedbackAndShareCell viewWithTag:1];
            UILabel *labelFeedbackAction = (UILabel *)[feedbackAndShareCell viewWithTag:2];
            [imageViewFeedbackAction setImage:[UIImage imageNamed:self.dataSourceFeedbackAndShareImages[indexPath.row]]];
            [labelFeedbackAction setText:self.dataSourceFeedbackAndShare[indexPath.row]];
        }
            break;
        case 1:

            
        {
            BITableViewCellHaveFourItems *otherAppsCell = (BITableViewCellHaveFourItems *)cell;
            
            UIImageView *imageViewAppIcon = (UIImageView *)[otherAppsCell viewWithTag:1];
            UILabel *labelAppName = (UILabel *)[otherAppsCell viewWithTag:2];
            UILabel *labelFee = (UILabel *)[otherAppsCell viewWithTag:3];
            UILabel *labelDescription = (UILabel *)[otherAppsCell viewWithTag:4];
            
            [imageViewAppIcon setImage:[UIImage imageNamed:self.dataSourceOtherAppsImages[indexPath.row]]];
            [labelAppName setText:self.dataSourceOtherApps[indexPath.row]];
            NSString *free = [[NSString alloc] initWithFormat:NSLocalizedString(@"Free:", nil)];
            [labelFee setText:free];
            
//            [labelDescription setAdjustsFontSizeToFitWidth:YES];
            [labelDescription setLineBreakMode:NSLineBreakByWordWrapping];
            [labelDescription setMinimumScaleFactor:4];
            [labelDescription setText:self.dataSourceOtherAppsDesc[indexPath.row]];
        }
            
            break;
        default:
            break;
    }
    return cell;
}

// セクション毎のセクション名を設定
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionList objectAtIndex:section];
}

// セクションごとのセルの高さを設定
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat rowHeight;
    switch (indexPath.section) {
        case 0:
            rowHeight = [BIFeedbakAndActionCell rowHeight];
            break;
        case 1:
            rowHeight = [BITableViewCellHaveFourItems rowHeight];
            break;
        default:
            break;
    }
    
    return rowHeight;
}

// tableCell is tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadData];
    // cellがタップされた際の処理
    switch (indexPath.section) {
        case 0: // Feedback / Share this App
            if (indexPath.row == 0) { // App Store Review
                [self actionPostAppStoreReview];
            }else if (indexPath.row == 1) { // PostActivities
                [self actionPostActivity:indexPath];
            }
            break;
        case 1: // Other Apps
            if (indexPath.row == 0) {
                [self actionJumpToRollToCrash];
            }
            break;
        default:
            break;
    }
    
}


- (void)actionPostAppStoreReview{
    NSString *urlString = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=912275000"; // RolltoCrashのレビューページに飛ぶ
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

// actions
- (void)actionPostActivity:(NSIndexPath *)indexPath{
    NSString *localeTextToShare = [[NSString alloc] initWithFormat:NSLocalizedString(@"#RollToCrash", nil)];
    NSString *textToShare = localeTextToShare;
    NSString *urlString = @"http://itunes.apple.com/app/id912275000"; // RollToCrashのappstoreURL
    NSURL *url = [NSURL URLWithString:urlString];
    NSArray *activityItems = [[NSArray alloc] initWithObjects:textToShare,url, nil];
    // 連携できるアプリを取得する
    UIActivity *activity = [[UIActivity alloc]init];
    NSArray *activities = @[activity];
    // アクティビティコントローラーを作る
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:activities];
    // Add to Reading Listをactivityから除外
    NSArray *excludedActivityTypes = @[UIActivityTypeAddToReadingList];
    activityVC.excludedActivityTypes = excludedActivityTypes;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    activityVC.popoverPresentationController.sourceView = cell.contentView;
    activityVC.popoverPresentationController.sourceRect = cell.bounds;
    
    
    // アクティビティコントローラーを表示する
    [self presentViewController:activityVC animated:YES completion:nil];
    
}



- (void)actionJumpToRollToCrash{
    NSString *urlString = @"itms-apps://itunes.apple.com/app/id942520127"; // 体モノマナイザーのページに飛ぶ
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
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
