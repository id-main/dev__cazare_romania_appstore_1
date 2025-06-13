//
//  NoInternetViewController.m
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import "NoInternetViewController.h"
#import "Reachability.h"
#import "StartViewController.h"
@interface NoInternetViewController (){
    
}

@end

@implementation NoInternetViewController
@synthesize ButonIncearca,TextNuAreInternet;
@synthesize LoadingDataIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //ComNSLog(@"%s",__func__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    //ComNSLog(@"%s",__func__);
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(prefersStatusBarHidden)]) {
        [self prefersStatusBarHidden];
    }
    else{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    self.navigationController.navigationBar.hidden = YES;
    self.LoadingDataIndicator.hidden =YES;
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    //ComNSLog(@"%s",__func__);
    [super viewDidAppear:animated];
    //    if(once==YES){
    //        once=NO;
    //        [self playMovie];
    //    }
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:243.0f/255.0f blue:208.0f/255.0f alpha:1];
    self.TextNuAreInternet.textColor = [UIColor colorWithRed:72.0f/255.0f green:74.0f/255.0f blue:67.0f/255.0f alpha:1];
    [self incearcaNET];
    //    UIFont *Myfont = [UIFont fontWithName:@"GillSans-Italic" size:17]; //PTS56F.ttf PT Sans 72 74 67
    
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait && toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
    }
    else{
        
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}
-(void)incearcaNET {
    // Add Observer reachabilityNow
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            self.ButonIncearca.hidden =YES;
            self.TextNuAreInternet.hidden=YES;
            //            [self performSelector:@selector(areNET) withObject:nil afterDelay:5];
            [self performSelector:@selector(areNET) withObject:nil afterDelay:0];
            break;
        }
        case ReachableViaWiFi:
        {
            self.ButonIncearca.hidden =YES;
            self.TextNuAreInternet.hidden=YES;
            //            [self performSelector:@selector(areNET) withObject:nil afterDelay:5];
            [self performSelector:@selector(areNET) withObject:nil afterDelay:0];
            break;
        }
        case NotReachable:
        {
            self.ButonIncearca.hidden =NO;
            self.TextNuAreInternet.hidden=NO;
            break;
        }
            
    }
    
}
-(IBAction)reincearcaNET {
    [self incearcaNET];
}
-(IBAction)areNET {
    StartViewController *ECRAN1Screen = [[StartViewController alloc] initWithNibName:@"StartViewController" bundle:nil];
    [self.navigationController pushViewController:ECRAN1Screen animated:YES];
}

- (void)didReceiveMemoryWarning
{
    //ComNSLog(@"%s",__func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)APASAok:(id)sender {
    //ComNSLog(@"%@%s", @"ok", __func__);
    [self.navigationController popToRootViewControllerAnimated:YES];
    // [self.navigationController popViewControllerAnimated:NO];
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}


@end
