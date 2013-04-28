//
//  MainZakerViewController.m
//  com.idreems.mrh
//
//  Created by ramonqlee on 1/22/13.
//  Copyright (c) 2013 ramonqlee. All rights reserved.
//

#import "MainZakerViewController.h"
#import "CommonHelper.h"
#import "TextImageSyncController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Flurry.h"
#import "ThemeManager.h"
#import "WQAdView.h"
#import "AdsConfig.h"
#import "AdsConfiguration.h"


#define kInitialItemCount 5
#define kFun @"kFun"
#define kTitle @"Title"

@interface MainZakerViewController ()
{
    NSMutableArray* zakerItem;//item properties,see GridItemProperty
}
@property(nonatomic,retain)NSMutableArray* zakerItem;
@end

@implementation MainZakerViewController
@synthesize zakerItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(kFun, "");
        self.tabBarItem.image = [UIImage imageNamed:kIconFun];
        //        self.navigationItem.title = NSLocalizedString(kTitle, "");
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    backButton.tintColor = TintColor;
    self.navigationItem.rightBarButtonItem = backButton;
    [backButton release];
    
        
    // Do any additional setup after loading the view.
    //TODO::load archived objects
    //parameters:classname--url in ascending order
    if (nil==zakerItem) {
        zakerItem = [[NSMutableArray alloc]initWithCapacity:kInitialItemCount];
    }
    
    NSString* fileName =[self getSerializeFileName];
    [zakerItem addObjectsFromArray:[self unserialize:fileName]];
    
    CGRect rc = [[UIScreen mainScreen]applicationFrame];
    rc.origin.y = 0;
    
    ZakerUI* zaker = [[ZakerUI alloc]initWithFrame:rc];
    zaker.delegate = self;
    for (GridItemProperty* p in zakerItem) {
        if(nil==p)
        {
            continue;
        }
        [zaker addItem:[NSString stringWithFormat:@"%@",p.itemDisplayName] withImageName:nil editable:YES];
    }
    
    [self.view addSubview:zaker];
    [zaker release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    self.zakerItem = nil;
    [super dealloc];
}
#pragma zaker delegate
- (void) gridItemDidClicked:(BJGridItem *) gridItem
{
    
    //
    GridItemProperty* p = [zakerItem objectAtIndex:gridItem.index];
    UIViewController* ctrl = nil;
    if (p.xibName) {
        ctrl = (UIViewController*)[[NSClassFromString(p.className) alloc]initWithNibName:p.xibName bundle:nil];
    }
    else
    {
        ctrl = (UIViewController*)[[NSClassFromString(p.className) alloc]init];
    }
    if([ctrl isKindOfClass:[TextImageSyncController class]])
    {
        TextImageSyncController* t = (TextImageSyncController*)ctrl;
        t.resourceName = p.itemDisplayName;
        t.resourceUrl = p.url;
        
        [Flurry logEvent:p.itemDisplayName];
    }
    UINavigationController* navi = [[[UINavigationController alloc]initWithRootViewController:ctrl]autorelease];
    [self presentModalViewController:navi animated:YES];
}
- (void) gridItemDidDeleted:(BJGridItem *) gridItem atIndex:(NSInteger)index
{
    if(nil!=zakerItem&& zakerItem.count>index&&index>=0)
    {
        [zakerItem removeObjectAtIndex:index];
        [self serialize:zakerItem fileName:[self getSerializeFileName]];
    }
}
- (void) gridItemExchanged:(NSInteger)oldIndex withposition:(NSInteger)newIndex
{
    if(nil!=zakerItem&& zakerItem.count>oldIndex &&oldIndex>=0 &&
       newIndex>=0 && zakerItem.count>newIndex)
    {
        NSObject* t = [zakerItem objectAtIndex:oldIndex];
        [zakerItem replaceObjectAtIndex:oldIndex withObject:[zakerItem objectAtIndex:newIndex]];
        [zakerItem replaceObjectAtIndex:newIndex withObject:t];
        [self serialize:zakerItem fileName:[self getSerializeFileName]];
    }
}

#pragma mark util methods
-(NSString*)getSerializeFileName
{
    return [NSString stringWithFormat:@"%@/%@",[CommonHelper getDocumentPath],@"gridItem.plist"];
}
-(NSArray*)getDefaultZakerItems
{
    NSMutableArray*r = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    for (int i = 0; i<1; ++i) {
        GridItemProperty* p = [[GridItemProperty alloc]init];
        
        switch (i) {
            case 0:
            {
                p.itemDisplayName = @"糗事大全";
                p.url = @"nil";
                p.className = @"EmbarrassController";
                p.xibName = p.className;
            }
                break;
            case 1:
            {
                p.itemDisplayName = @"搞笑段子";
                p.url = @"http://www.idreems.com/php/embarrasepisode/implicitessays_top.php?type=joke&count=20&page=%d";
                p.className = @"TextImageSyncController";
                p.xibName = p.className;
            }
                break;
            case 2:
            {
                p.itemDisplayName = @"搞笑动画";
                p.url = @"http://www.idreems.com/php/embarrasepisode/implicitessays_top.php?type=gif&count=20&page=%d";
                p.className = @"TextImageSyncController";
                p.xibName = p.className;
            }
                break;
            case 3:
            {
                p.itemDisplayName = @"搞笑萌图";
                p.url = @"http://www.idreems.com/php/embarrasepisode/implicitessays_top.php?type=meng&count=20&page=%d";
                p.className = @"TextImageSyncController";
                p.xibName = p.className;
            }
                break;
            case 4:
            {
                p.itemDisplayName = @"暴笑";
                p.url = @"http://www.idreems.com/php/embarrasepisode/implicitessays_top.php?type=heavy&count=20&page=%d";
                p.className = @"TextImageSyncController";
                p.xibName = p.className;
            }
                break;
            case 5:
            {
                p.itemDisplayName = @"搞笑漫画";
                p.url = @"http://www.idreems.com/php/embarrasepisode/implicitessays_top.php?type=comic&count=20&page=%d";
                p.className = @"TextImageSyncController";
                p.xibName = p.className;
            }
                break;
            case 6:
            {
                p.itemDisplayName = @"抱走漫画热门";
                p.url = @"http://www.idreems.com/php/embarrasepisode/comic_bz.php?type=hot&page=%d&count=20";
                p.className = @"TextImageSyncController";
                p.xibName = p.className;
            }
                break;
            case 7:
            {
                p.itemDisplayName = @"抱走漫画最新";
                p.url = @"http://www.idreems.com/php/embarrasepisode/comic_bz.php?type=latest&page=%d&count=20";
                p.className = @"TextImageSyncController";
                p.xibName = p.className;
            }
                break;
            default:
                break;
        }
        
        [r addObject:p];
        [p release];
    }
    return r;
}
-(NSArray*)unserialize:(NSString*)fileName
{
    if(nil==fileName)
    {
        return nil;
    }
    NSMutableArray* r = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (nil==r) {
        //default ones
        r = (NSMutableArray*)[self getDefaultZakerItems];
        [NSKeyedArchiver archiveRootObject:r toFile:fileName];
    }
    return r;
}
-(void)serialize:(NSArray*)data fileName:(NSString*)fileName
{
    if (nil==data || nil ==fileName) {
        return;
    }
    [NSKeyedArchiver archiveRootObject:data toFile:fileName];
}

@end
