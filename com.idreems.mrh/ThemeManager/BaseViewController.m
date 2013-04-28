//
//  BaseViewController.m
//  SkinnedUI
//
//  Created by QFish on 12/2/12.
//  Copyright (c) 2012 http://QFish.Net All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeManager.h"
#import "AdsConfiguration.h"
#import "AdsConfig.h"
#import "AdsViewManager.h"
#import "UpdateToPremiumController.h"

static BOOL sAdShown = NO;
@interface BaseViewController ()

@property (assign, nonatomic) BOOL didAppear;
@end

@implementation BaseViewController
@synthesize didAppear;

- (void)menuButtonClick:(id)sender
{
    NSLog(@"menuButtonClick");
}
//@synthesize youkuMenuView;
- (void)dealloc
{
    // unregister as observer for theme status
    [self unregisterAsObserver];
    //[youkuMenuView release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.didAppear = NO;
        
        // register as observer for theme status
        [self regitserAsObserver];
    }
    return self;
}
-(void)handlerUpdateAdsOnMainThread
{
    if (sAdShown) {
        return;
    }
    
    [self showCloseAdItem];
    AdsViewManager* adViewManager = [AdsViewManager sharedInstance];
    
#if 0
    NSArray* list = (NSArray*)[adViewManager.configDict objectForKey:kOfferWall];
    if (list && [list count]) {
        NSDictionary* item = [list objectAtIndex:0];
        [adViewManager initOfferwall:item];
        [self performSelector:@selector(showOfferwall) withObject:nil afterDelay:kOfferwallDelay];
        sAdShown = YES;
    }
#else
    RMIndexedArray* list = (RMIndexedArray*)[adViewManager.configDict objectForKey:kRecommendWall];
    if (list && [list count]) {
        for (NSInteger i = 0; i< [list count];++i) {
            NSDictionary* item = [list objectAtIndex:i];
            
            [adViewManager initRecommendWall:item];
            [adViewManager showRecommendWall:item];
            sAdShown = YES;
            
        }
    }
#endif
}
-(void)closeAd
{
    UIViewController* c = [[[UpdateToPremiumController alloc]init]autorelease];
    [self.navigationController pushViewController:c animated:YES];
}
-(void)showCloseAdItem
{
    AdsConfiguration* adConfig = [AdsConfiguration sharedInstance];
    NSString* youmiAppId = [adConfig youmiAppId];
    if (youmiAppId && youmiAppId.length>0) {        
        UIButton* closeAdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeAdButton setFrame:CGRectMake(0,0,24,24)];
        [closeAdButton setImage:[UIImage imageNamed:@"new.png"] forState:UIControlStateNormal];
        //[closeAdButton setTitle:NSLocalizedString(@"AdsWallSwitch", "") forState:UIControlStateNormal];
        [closeAdButton addTarget:self action:@selector(closeAd) forControlEvents:UIControlEventTouchUpInside];
        [[self navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithCustomView:closeAdButton]autorelease]];
    }
}
-(void)handlerUpdateAds
{
    [self performSelectorOnMainThread:@selector(handlerUpdateAdsOnMainThread) withObject:self waitUntilDone:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self initViews];
    [self configureViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handlerUpdateAds) name:kAdsConfigUpdated object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Theme Methods

- (void)initViews
{
    // may do nothing, implement by the subclass
    //autohide menu
    /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     UIImage *image = [UIImage imageNamed:@"hidemenu.png"];
     button.frame = CGRectMake(0.0,self.view.frame.size.height - 18, kDeviceWidth,17);
     [button setBackgroundImage:image forState:UIControlStateNormal];
     [button addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchDown];
     button.tag = 111;
     [self.view addSubview:button];
     
     youkuMenuView = [[AutoHideMenuView alloc]initWithFrame:[AutoHideMenuView getFrame]];
     [self.view addSubview:youkuMenuView];
     youkuMenuView.delegate = self;
     [youkuMenuView release];*/
}

- (void)configureViews
{
    // set the background of navigationbar
    [self.navigationController.navigationBar setBackgroundImage:ThemeImage(@"header_bg")   forBarMetrics:UIBarMetricsDefault];
}

- (void)regitserAsObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(configureViews)
                   name:ThemeDidChangeNotification
                 object:nil];
}

- (void)unregisterAsObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

/*
 #pragma mark youkuMenu
 - (void)menuButtonClick:(id)sender
 {
 NSLog(@"sender tag:%d",((UIView*)sender).tag);
 }
 
 - (void)showMenu:(id)sender
 {
 UIButton *button = (UIButton *)sender;
 button.hidden = YES;
 [youkuMenuView  showOrHideMenu];
 }
 
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
 
 if (youkuMenuView && ![youkuMenuView  menuHidden]&&!scrollView.decelerating)
 {
 [youkuMenuView  showOrHideMenu];
 [self performSelector:@selector(showMenuButton) withObject:nil afterDelay:1];
 }
 }
 - (void)showMenuButton
 {
 UIView *button = [self.view viewWithTag:111];
 button.hidden = NO;
 }*/
@end
