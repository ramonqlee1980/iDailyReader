//
//  UpdateToPremiumController.m
//  HappyLife
//
//  Created by ramonqlee on 3/30/13.
//
//

#import "UpdateToPremiumController.h"
#import "AdsConfig.h"
#import "AppDelegate.h"
#import "CoinsManager.h"
#import "Toast+UIView.h"
#import "Flurry.h"
#import "AdsConfiguration.h"

NSString* kReuseIdentifier = @"UpdateToPremiumCell";

@interface UpdateToPremiumController ()
{
    YoumiOfferWall* youmiWall;
    NSInteger youmiPoints;
}
@end

@implementation UpdateToPremiumController
- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
        
	self.title = NSLocalizedString(@"UpdateToPremium", @"UpdateToPremium");
    youmiWall= [YoumiOfferWall shareInstance:kYoumiWallAppId appKey:kYoumiWallAppSecret reward:YES];
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addSections];    
    
    [Flurry logEvent:kReviewCloseAdPlan];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark util methods
-(void)UpdateByConsumingPoints:(id)sender
{
    NSLog(@"Update By Consuming Points");
    
    NSString* title = NSLocalizedString(@"YoumiPoints2CoinsTitle", "");
    NSString* body = [NSString stringWithFormat:NSLocalizedString(@"YoumiPoints2CoinsMsg", ""),youmiPoints,youmiPoints];
    if(youmiPoints > 0)
    {
        [Flurry logEvent:GetCoins];
        //convert to coins
        [[CoinsManager sharedInstance]addCoins:youmiPoints];
        [youmiWall spendPoints:youmiPoints];
        youmiPoints = 0;
    }
    else
    {
        body = NSLocalizedString(@"YoumiWallTitle", "");
    }
    [self.view makeToast:body
                duration:6.0
                position:@"bottom"
                   title:title
                   image:[UIImage imageNamed:@"AppStore.png"]];
    [self.tableView reloadData];
}
-(void)earnYoumiPoints
{
    if(youmiWall)
    {
        [Flurry logEvent:kOpenYoumiWall];
        [youmiWall showOffer:YES];
    }
}
-(void)trialPoints
{
    //TODO::
    NSLog(@"Update By Consuming Points");
    [Flurry logEvent:TrialPoints];
    
    const NSInteger kTrialPoints = kCoinsPerUse*5;
    NSString* title = NSLocalizedString(@"YoumiPoints2CoinsTitle", "");
    NSString* body = [NSString stringWithFormat:NSLocalizedString(@"TrialPoints2CoinsMsg", ""),kTrialPoints,kTrialPoints];
          //convert to coins
    [[CoinsManager sharedInstance]addCoins:kTrialPoints];
    [CoinsManager setTrialed:YES];
    [self.view makeToast:body
                duration:6.0
                position:@"bottom"
                   title:title
                   image:[UIImage imageNamed:@"AppStore.png"]];
    [self.tableView reloadData];
}
#pragma mark youmi delegate
- (void)didReceiveOffers:(NSInteger)points
{
    //[self performSelectorOnMainThread:@selector(youmiSection:) withObject:points waitUntilDone:YES];
    [self youmiSection:points];
}

// 请求应用列表失败
//
// 说明:
//      应用列表请求失败后回调该方法
//
- (void)didFailToReceiveOffers:(NSInteger)points error:(NSError *)error
{
    //    [self performSelectorOnMainThread:@selector(youmiSection:) withObject:points waitUntilDone:NO];
    [self youmiSection:points];
}
#define kEarnCoins 10
#define kEarnYoumi 11
-(void)youmiSection:(NSInteger)points
{
    youmiPoints = points;
    const CGFloat kFontSize = 20;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"EarnYoumi";
            //Update by consuming points
            //button: points :icon
            NSString* text = NSLocalizedString(@"EarnYoumiPoints", @"");
            UIFont* font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.selectionStyle = UITableViewCellStyleDefault;
            CGSize size = [text sizeWithFont:font];
            
            UIButton* button = nil;
            UIView* view = [cell.contentView viewWithTag:kEarnYoumi];
            if (view && [view isKindOfClass:[UIButton class]]) {
                button = (UIButton*)view;
                [button removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell.contentView addSubview:button];
            }
            button.tag = kEarnCoins;
            button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            button.titleLabel.numberOfLines = 0;
            [button.titleLabel setFont:font];
            button.frame = CGRectMake(kDeviceWidth/2-size.width/2, size.height/4, size.width, size.height);
            [button setTitle:text forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(earnYoumiPoints) forControlEvents:UIControlEventTouchUpInside];
        } whenSelected:^(NSIndexPath *indexPath) {
            
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"EarnCoins";
            //Update by consuming points
            //button: points :icon
            NSString* text = [NSString stringWithFormat:NSLocalizedString(@"UpdateByPoints", @"UpdateByPoints"),youmiPoints];
            
            UIFont* font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.selectionStyle = UITableViewCellStyleDefault;
            CGSize size = [text sizeWithFont:font];
            
            UIButton* button = nil;
            UIView* view = [cell.contentView viewWithTag:kEarnCoins];
            if (view && [view isKindOfClass:[UIButton class]]) {
                button = (UIButton*)view;
                [button removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell.contentView addSubview:button];
            }
            button.tag = kEarnCoins;
            button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button.titleLabel setFont:font];
            button.frame = CGRectMake(kDeviceWidth/2-size.width/2, size.height/3, size.width, size.height);
            [button setTitle:text forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(UpdateByConsumingPoints:) forControlEvents:UIControlEventTouchUpInside];
            
		} whenSelected:^(NSIndexPath *indexPath) {
            
		}];
        
	}];
    
    [self.tableView reloadData];
}

#pragma mark addSections
-(void)addPreviledgeSection
{
    self.headerText = [NSString stringWithFormat:NSLocalizedString(@"CoinsPlan", @""),kCoinsPerUse];
    
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {

        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = kReuseIdentifier;
			cell.selectionStyle = UITableViewCellStyleDefault;
            
			cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"LeftCoins", @""),[[CoinsManager sharedInstance] getLeftCoins]];
			cell.imageView.image = [UIImage imageNamed:@"Coins"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
		} whenSelected:^(NSIndexPath *indexPath) {
            
		}]; 
	
    }];
}
-(void)addTrialSection
{
    if ([CoinsManager trialed]) {
        return;
    }
    
    const CGFloat kFontSize = 20;
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.reuseIdentifier = @"TrialSection";
            //Update by consuming points
            //button: points :icon
            NSString* text = NSLocalizedString(@"TrialPoints", @"");
            UIFont* font = [UIFont boldSystemFontOfSize:kFontSize];
            cell.selectionStyle = UITableViewCellStyleDefault;
            CGSize size = [text sizeWithFont:font];
            
            UIButton* button = nil;
            UIView* view = [cell.contentView viewWithTag:kEarnYoumi];
            if (view && [view isKindOfClass:[UIButton class]]) {
                button = (UIButton*)view;
                [button removeTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                button = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell.contentView addSubview:button];
            }
            button.tag = kEarnCoins;
            
            [button.titleLabel setFont:font];
            button.frame = CGRectMake(kDeviceWidth/2-size.width/2, size.height/4, size.width, size.height);
            [button setTitle:text forState:UIControlStateNormal];
            button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
            button.titleLabel.numberOfLines = 0;
            if([CoinsManager trialed])
            {
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];            
            }
            else
            {
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(trialPoints) forControlEvents:UIControlEventTouchUpInside];
            }
            [button setBackgroundColor:[UIColor clearColor]];
            
        } whenSelected:^(NSIndexPath *indexPath) {
            
		}];
                
	}];
    
    [self.tableView reloadData];

}
-(void)addUpdateSection
{
    //get youmi points
    if(youmiWall)
    {
        [youmiWall requestEarnedPoints:self];
    }
}
-(void)addSections
{
    [self addPreviledgeSection];
    [self addTrialSection];
    [self addUpdateSection];
}
@end
