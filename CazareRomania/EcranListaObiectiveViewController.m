//
//  EcranListaObiectiveViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 15/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranListaObiectiveViewController.h"
#import "LocationTableViewCell.h"
#import "EcranObiectiveViewController.h"
#include "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface EcranListaObiectiveViewController ()

@end

@implementation EcranListaObiectiveViewController
@synthesize backButton, screenTitle, listTableView, mainScrollView;
@synthesize locationsArray, myJson,greenBorder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [mainScrollView setScrollsToTop:YES];
    [listTableView setScrollsToTop:NO];
    

    
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    controller = [[DataMasterProcessor alloc] init];
    self.myJson = myJson;
    
    locationsArray = [[NSMutableArray alloc] init];
    //ComNSLog(@"self myjson---%@",self.myJson);
   
    //ComNSLog(@"MYJSON %@", myJson);
    
    for(NSDictionary * dict in myJson){
        //ComNSLog(@"dict ---%@",dict);
        [locationsArray addObject:dict];
    }
    
    //ComNSLog(@"location array---%@",locationsArray);
    
    [screenTitle setText:[NSString stringWithFormat:@"%d obiective",[locationsArray count]]];
    
   /* locationsArray = @{@"status":@"OK",@"results":@[@{@"id":@564,@"nume":@"Bisericile de lemn",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/biserica-lemn.jpg",@"cazare":@"1 min cu masina"},@{@"id":@184,@"nume":@"Manastirea Sf. Ana",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/sfanta-ana.jpg",@"cazare":@"0 min cu masina"}]}[@"results"];*/
    
}

-(void)viewDidAppear:(BOOL)animated{
  
    screenTitle.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
    
    backButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    [mainScrollView setBounces:YES];
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
    [listTableView setFrame:CGRectMake(listTableView.frame.origin.x, listTableView.frame.origin.y, listTableView.frame.size.width, 95 * [locationsArray count])];
    [listTableView setBounces:NO];
    [listTableView setScrollEnabled:NO];
    
    
    
    [mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, listTableView.frame.origin.y + listTableView.frame.size.height + 25)];
    
//    if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
//        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, listTableView.frame.origin.y + listTableView.frame.size.height + 120)];
//    }
//    else{
//        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, listTableView.frame.origin.y + listTableView.frame.size.height + 250)];
//    }
    
    //ComNSLog(@"main scroll view content size---%@", NSStringFromCGSize([mainScrollView contentSize]));
    //ComNSLog(@"table view frame---%@",NSStringFromCGRect([listTableView frame]));
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,mainScrollView.contentSize.height)];
    }
    else{
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,mainScrollView.contentSize.height)];
    }
    //ComNSLog(@"mainscrollview content:  %@",NSStringFromCGSize(mainScrollView.contentSize));
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    //[listTableView reloadData];
   [greenBorder setBackgroundColor:UIColorFromRGB(0x94af39)];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [screenTitle setFont:[UIFont fontWithName:@"OpenSans" size:21.5f]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LocationsTableViewCell";
    LocationTableViewCell *cell = (LocationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LocationsTableViewCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (LocationTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    [cell.locationTitle setText:locationsArray[indexPath.row][@"nume"]];
    NSString *urlStr = [NSString stringWithFormat:@"%@",locationsArray[indexPath.row][@"urlFoto"]];
    if(urlStr != nil && [urlStr class]  != [NSNull class] && urlStr != (id)[NSNull null]){
        [controller downloadImageWithURL:[NSURL URLWithString:urlStr] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [cell.previewPhoto setImage:image];
            }
        }];
    }

    
   // [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.distanceLabel setText:[NSString stringWithFormat:@"Cazare la %@",locationsArray[indexPath.row][@"cazare"]]];
    
    [cell.locationTitle setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    
    [cell.locationTitle setTextColor:UIColorFromRGB(0x333333)];
    [cell.distanceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0f]];
    
    [cell.distanceLabel setTextColor:UIColorFromRGB(0x666666)];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    selectedIndexPath = indexPath;
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            NSString *obiectivID = [NSString stringWithFormat:@"%@",locationsArray[indexPath.row][@"id"]];
            [self pregatesteObiectiv:obiectivID];
            break;
        }
        case ReachableViaWiFi:
        {
            NSString *obiectivID = [NSString stringWithFormat:@"%@",locationsArray[indexPath.row][@"id"]];
            [self pregatesteObiectiv:obiectivID];
            break;
        }
        case NotReachable:
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
            
    }


}

//////////////// pregateste ecran obiectiv
-(void) pregatesteObiectiv :(NSString*)obiectivID {
    if(obiectivID) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"Va rugam asteptati";
        NSString *compus= @"";
        compus = [NSString stringWithFormat:@"http://json.infopensiuni.ro/%@%@/", WEBSERVICE_OBIECTIV,obiectivID];
        NSURL *url = [NSURL URLWithString:[compus stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //ComNSLog(@"url obiectiv %@", url);
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request = _request;
        request.requestMethod = @"GET";
        //  [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //  [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *REZOLVA_OBIECTIV = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:nil];
            //ComNSLog(@"Response: %@", responseString);
             //ComNSLog(@"Dictionary: %@", REZOLVA_OBIECTIV);
            if( [self checkDictionary:REZOLVA_OBIECTIV]){
                [self rezolvaObiectiv:REZOLVA_OBIECTIV];
            }
            else{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [listTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            //ComNSLog(@"Error: %@", error.localizedDescription);
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }];
        [request startAsynchronous];
    }
}
-(void) rezolvaObiectiv:(NSDictionary *)REZOLVA_OBIECTIV {
    if(REZOLVA_OBIECTIV) {

//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [listTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
            ecranObiectiv.myJson = REZOLVA_OBIECTIV;
            ecranObiectiv.backString = screenTitle.text;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:ecranObiectiv animated:NO];
        }
        else{
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
                ecranObiectiv.myJson = REZOLVA_OBIECTIV;
                ecranObiectiv.backString = screenTitle.text;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranObiectiv animated:NO];
            }
            else{
                EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
                ecranObiectiv.myJson = REZOLVA_OBIECTIV;
                ecranObiectiv.backString = screenTitle.text;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromRight;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranObiectiv animated:NO];
            }
            
        }

        
    }
}

-(bool)checkDictionary:(NSDictionary *)dict{
    if(dict == nil || [dict class] == [NSNull class] || ![dict isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    
    return  YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [locationsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backAction:(id)sender {
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            [self dismissModalViewControllerAnimated:NO];
            [self prezintaBack];
            break;
        }
        case ReachableViaWiFi:
        {
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            [self dismissModalViewControllerAnimated:NO];
            [self prezintaBack];
            break;
        }
        case NotReachable:
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
            
    }

}

-(void)prezintaBack{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        else{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }
    
}


@end
