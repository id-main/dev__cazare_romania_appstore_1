//
//  EcranListaPensiuniViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 15/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranListaPensiuniViewController.h"
#import "PensionTableViewCell.h"
#import "EcranPensiune.h"
#include "ASIHTTPRequest.h"
#import "EcranCerereOfertaViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface EcranListaPensiuniViewController ()

@end

@implementation EcranListaPensiuniViewController

@synthesize bottomRequestButton, requestButton, listTableView, backButton, screenTitle, mainScrollView, bottomRequestView,myList, requestView, requestLabel, backLabel, greenBorder;

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
    if ([self respondsToSelector:@selector(prefersStatusBarHidden)]) {
        [self prefersStatusBarHidden];
    }
    else{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }
    
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [requestView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"buton-solicita-background" ofType:@"png"]]]];
    [requestView.layer setCornerRadius:5.0f];
    [requestView.layer setMasksToBounds:YES];
    
  self.myList = myList;
    //ComNSLog(@"my list---%@",myList);
//  @{@"status":@"OK",@"results":@[@{@"id":@2647,@"nume":@"Korona",@"tip":@"Pensiunea",@"numeText":@"Pensiunea Korona",@"categorie":@3,@"foto":@"http://www.infopensiuni.ro/poze/uc/thumbs/15079.jpg",@"tarif":@{@"suma":@80,@"moneda":@"RON",@"tip":@"noapte",@"icon":@"2pers",@"tc":@1,@"text":@"80 RON/noapte"},@"obiectiv":@{@"nume":@"Statiunea Borsec ",@"durataMin":@17,@"mers":@"pieton",@"text":@"17 min pe jos"}},@{@"id":@6352,@"nume":@"Sport Borsec",@"tip":@"Vila",@"numeText":@"Vila Sport Borsec",@"categorie":@3,@"foto":@"http://www.infopensiuni.ro/poze/uc/thumbs/59454.JPG",@"tarif":@{@"suma":@70,@"moneda":@"RON",@"tip":@"noapte",@"icon":@"2pers",@"tc":@1,@"text":@"70 RON/noapte"},@"obiectiv":@{@"nume":@"Partie ski Verofeny (Raza Soarelui) Borsec",@"durataMin":@4,@"mers":@"pieton",@"text":@"4 min pe jos"}},@{@"id":@5432,@"nume":@"Casa Emy",@"tip":@"Pensiunea",@"numeText":@"Pensiunea Casa Emy",@"categorie":@2,@"foto":@"http://www.infopensiuni.ro/poze/uc/thumbs/70684.jpg",@"tarif":@{@"suma":@50,@"moneda":@"RON",@"tip":@"noapte",@"icon":@"2pers",@"tc":@1,@"text":@"50 RON/noapte"},@"obiectiv":@{@"nume":@"Partie ski Verofeny (Raza Soarelui) Borsec",@"durataMin":@19,@"mers":@"pieton",@"text":@"19 min pe jos"}},@{@"id":@3834,@"nume":@"Ely",@"tip":@"Pensiunea",@"numeText":@"Pensiunea Ely",@"categorie":@3,@"foto":@"http://www.infopensiuni.ro/poze/uc/thumbs/62133.jpg",@"tarif":@{@"suma":@80,@"moneda":@"RON",@"tip":@"noapte",@"icon":@"2pers",@"tc":@1,@"text":@"80 RON/noapte"},@"obiectiv":@{@"nume":@"Statiunea Borsec ",@"durataMin":@2,@"mers":@"pieton",@"text":@"2 min pe jos"}}]}[@"results"];
    
    [screenTitle setText:[NSString stringWithFormat:@"%d pensiuni", [myList count]]];
    screenTitle.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
    
    backButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    requestButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    requestButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    requestButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;

}

-(void)viewDidAppear:(BOOL)animated{
    
    controller = [[DataMasterProcessor alloc] init];
    
    [listTableView setFrame:CGRectMake(listTableView.frame.origin.x, listTableView.frame.origin.y,listTableView.frame.size.width, 93 * [myList count])];
    [listTableView setBounces:NO];
    
    
    
    [mainScrollView setBounces:YES];
//    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, bottomRequestView.frame.size.height + bottomRequestView.frame.origin.y + 100)];
    
//    [self.view addSubview:bottomRequestView];
//    [bottomRequestView setFrame:CGRectMake(bottomRequestView.frame.origin.x, CGRectGetMaxY(listTableView.frame), bottomRequestView.frame.size.width, bottomRequestView.frame.size.height)];
    
    if(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || self.interfaceOrientation == UIInterfaceOrientationPortrait){
        
        [requestView setFrame:CGRectMake(requestView.frame.origin.x, requestView.frame.origin.y, [[UIScreen mainScreen] bounds].size.width - (requestView.frame.origin.x *2), requestView.frame.size.height)];
        [requestLabel setFrame:CGRectMake(requestLabel.frame.origin.x,requestLabel.frame.origin.y, requestView.frame.size.width - requestLabel.frame.origin.x, requestView.frame.size.height)];
        
        //ComNSLog(@"view did layoutSubviews---%f,%f",requestLabel.frame.size.width,requestView.frame.size.width);
        
        [bottomRequestView setFrame:CGRectMake(bottomRequestView.frame.origin.x, CGRectGetMaxY(listTableView.frame)+25, [[UIScreen mainScreen] bounds].size.width, bottomRequestView.frame.size.height)];
        [requestLabel setTextAlignment:NSTextAlignmentLeft];
        
//        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, CGRectGetMaxY(bottomRequestView.frame) + 90)];
        
    }
    else{
        [requestView setFrame:CGRectMake(requestView.frame.origin.x, requestView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height - (requestView.frame.origin.x *2), requestView.frame.size.height)];
        [requestLabel setFrame:CGRectMake(requestLabel.frame.origin.x,requestLabel.frame.origin.y, requestView.frame.size.width - requestLabel.frame.origin.x, requestView.frame.size.height)];
        
        //ComNSLog(@"view did layoutSubviews---%f,%f",requestLabel.frame.size.width,requestView.frame.size.width);
        [requestLabel setTextAlignment:NSTextAlignmentCenter];
        [bottomRequestView setFrame:CGRectMake(bottomRequestView.frame.origin.x, CGRectGetMaxY(listTableView.frame)+25, [[UIScreen mainScreen] bounds].size.height, bottomRequestView.frame.size.height)];
        
//        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, CGRectGetMaxY(bottomRequestView.frame) + 250)];
    }
    
    
    [mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(bottomRequestView.frame)+25)];
    //ComNSLog(@"list table view    %@",NSStringFromCGRect(listTableView.frame));
    
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
    
    UITapGestureRecognizer * recogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(requestBookingOffer:)];
    [requestView addGestureRecognizer:recogn];

    
}

-(void)viewWillLayoutSubviews{
    //ComNSLog(@"view will layout subviews");
//    if(self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown || UIInterfaceOrientationPortrait){
//        [requestView setFrame:CGRectMake(requestView.frame.origin.x, requestView.frame.origin.y, requestView.frame.size.width - (requestView.frame.origin.x * 2), requestView.frame.size.height)];
//        [requestLabel setFrame:CGRectMake(requestLabel.frame.origin.x,requestLabel.frame.origin.y, requestView.frame.size.width - requestLabel.frame.origin.x, requestView.frame.size.height)];
//    }
//    else{
//        
//    }
}

-(void)viewWillAppear:(BOOL)animated{
    //[listTableView reloadData];
    [greenBorder setBackgroundColor:UIColorFromRGB(0x94af39)];
    [requestButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [screenTitle setFont:[UIFont fontWithName:@"OpenSans" size:21.5f]];
}

-(void)viewDidLayoutSubviews{
    

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight){

        [requestView setFrame:CGRectMake(requestView.frame.origin.x, requestView.frame.origin.y, [[UIScreen mainScreen] bounds].size.width - (requestView.frame.origin.x *2), requestView.frame.size.height)];
        [requestLabel setFrame:CGRectMake(requestLabel.frame.origin.x,requestLabel.frame.origin.y, requestView.frame.size.width - requestLabel.frame.origin.x, requestView.frame.size.height)];
        
        //ComNSLog(@"view did layoutSubviews---%f,%f",requestLabel.frame.size.width,requestView.frame.size.width);
        
        [bottomRequestView setFrame:CGRectMake(bottomRequestView.frame.origin.x, CGRectGetMaxY(listTableView.frame)+25, [[UIScreen mainScreen] bounds].size.width, bottomRequestView.frame.size.height)];
        [requestLabel setTextAlignment:NSTextAlignmentLeft];
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,mainScrollView.contentSize.height)];

    }
    else{
        [requestView setFrame:CGRectMake(requestView.frame.origin.x, requestView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height - (requestView.frame.origin.x *2), requestView.frame.size.height)];
        [requestLabel setFrame:CGRectMake(requestLabel.frame.origin.x,requestLabel.frame.origin.y, requestView.frame.size.width - requestLabel.frame.origin.x, requestView.frame.size.height)];
        
        //ComNSLog(@"view did layoutSubviews---%f,%f",requestLabel.frame.size.width,requestView.frame.size.width);
        [requestLabel setTextAlignment:NSTextAlignmentCenter];
        [bottomRequestView setFrame:CGRectMake(bottomRequestView.frame.origin.x, CGRectGetMaxY(listTableView.frame)+25, [[UIScreen mainScreen] bounds].size.height, bottomRequestView.frame.size.height)];
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,mainScrollView.contentSize.height)];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}


// metode tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *CellIdentifier = @"PensionTableViewCell";
    
    PensionTableViewCell *cell = (PensionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setTag:[myList[indexPath.row][@"categorie"] intValue]];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PensionTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (PensionTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    [cell.title setText:myList[indexPath.row][@"numeText"]];
    [cell.priceLabel setText:myList[indexPath.row][@"tarif"][@"text"]];
    //ComNSLog(@"adresa foto---%@", myList[indexPath.row][@"foto"]);
    
    [cell.title setTextColor:UIColorFromRGB(0x333333)];
    [cell.priceLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [cell.title setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.5f]];
    [cell.priceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:13.5f]];

    
    if(myList[indexPath.row][@"foto"] != nil && [myList[indexPath.row][@"photo"] class]  != [NSNull class] && myList[indexPath.row][@"foto"] != (id)[NSNull null]){
        //ComNSLog(@"intra si aici");
        [self downloadImageWithURL:[NSURL URLWithString:myList[indexPath.row][@"foto"]] completionBlock:^(BOOL  succeeded, UIImage *image) {
            if (succeeded) {
                [cell.thumbImage setImage:image];
            }
            else{
                //ComNSLog(@"eroare");
            }
        }];
    }

    
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%@ de %@", myList[indexPath.row][@"obiectiv"][@"text"], myList[indexPath.row][@"obiectiv"][@"nume"]]];
    [cell.distanceLabel setHidden:NO];
    
    [cell.distanceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0f]];
    
    [cell.distanceLabel setTextColor:UIColorFromRGB(0x666666)];
    
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //// adauga stele
    
    int numberOfStars= [myList[indexPath.row][@"categorie"] intValue] , xPosition =0, yPosition = 0;
    
    if(numberOfStars > 0){
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 18, 15)];
        [starImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star-rating" ofType:@"png"]]];
        [cell.starsView addSubview:starImageView];
        
        xPosition = xPosition + 21;
        
        for(int i=1; i < numberOfStars; i++){
            UIImageView *starImageView= [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 18, 15)];
            xPosition = xPosition + 21;
            
            [starImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star-rating" ofType:@"png"]]];
            [cell.starsView addSubview:starImageView];
            
        }
    }

    
    
    return cell;
    
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    EcranPensiuneViewController * ecrPensiuneVC = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
//    [self presentModalViewController:ecrPensiuneVC animated:YES];
    
    selectedIndexPath = indexPath;
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            [self pregatestePensiune:myList[indexPath.row][@"id"]];
            break;
        }
        case ReachableViaWiFi:
        {
            [self pregatestePensiune:myList[indexPath.row][@"id"]];
            break;
        }
        case NotReachable:
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
            
    }

    
}

-(IBAction)backAction:(UIButton *)sender{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            //ComNSLog(@"via wwan");
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            UIView *containerView = self.view.window;
//            [containerView.layer addAnimation:transition forKey:nil];
//            [self dismissModalViewControllerAnimated:NO];
            [self prezintaBack];
            break;
        }
        case ReachableViaWiFi:
        {
            //ComNSLog(@"via wifi");
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromLeft;
//            UIView *containerView = self.view.window;
//            [containerView.layer addAnimation:transition forKey:nil];
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


//////////////// pregateste ecran pensiune
-(void) pregatestePensiune :(NSString*)pensiuneID {
    if(pensiuneID) {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"Va rugam asteptati";
        NSString *compus= @"";
        compus = [NSString stringWithFormat:@"http://json.infopensiuni.ro/%@%@/", WEBSERVICE_PENSIUNE,pensiuneID];
        NSURL *url = [NSURL URLWithString:[compus stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //ComNSLog(@"url pensiune %@", url);
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        __weak ASIHTTPRequest *request = _request;
        request.requestMethod = @"GET";
        //  [request addRequestHeader:@"Content-Type" value:@"application/json"];
        //  [request appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
        [request setDelegate:self];
        [request setCompletionBlock:^{
            NSString *responseString = [request responseString];
            NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *REZOLVA_PENSIUNE = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:nil];
            //ComNSLog(@"Response: %@", responseString);
            //ComNSLog(@"Dictionary: %@", REZOLVA_PENSIUNE);
            
            if([self checkDictionary:REZOLVA_PENSIUNE]){
                [self rezolvaPensiune:REZOLVA_PENSIUNE];
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

-(bool)checkDictionary:(NSDictionary *)dict{
    if(dict == nil || [dict class] == [NSNull class] || ![dict isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    
    return  YES;
}
-(void) rezolvaPensiune:(NSDictionary *)REZOLVA_PENSIUNE {
    if(REZOLVA_PENSIUNE) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [listTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
            ecranPensiune.myJson = REZOLVA_PENSIUNE;
            ecranPensiune.backString = screenTitle.text;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self.navigationController pushViewController:ecranPensiune animated:NO];
        }
        else{
            if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
                EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
                ecranPensiune.myJson = REZOLVA_PENSIUNE;
                ecranPensiune.backString = screenTitle.text;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromBottom;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranPensiune animated:NO];
            }
            else{
                EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
                ecranPensiune.myJson = REZOLVA_PENSIUNE;
                ecranPensiune.backString = screenTitle.text;
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromTop;
                [self.view.window.layer addAnimation:transition forKey:nil];
                [self.navigationController pushViewController:ecranPensiune animated:NO];
            }
            
        }

        
    }
}


-(void)requestBookingOffer:(UIGestureRecognizer *)recogn{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
//            EcranCerereOfertaViewController * ecranCerere = [[EcranCerereOfertaViewController alloc] initWithNibName:@"EcranCerereOfertaViewController" bundle:nil];
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            [self presentModalViewController:ecranCerere animated:NO];
            [self prezintaEcranCerereOferta];
            break;
        }
        case ReachableViaWiFi:
        {
//            EcranCerereOfertaViewController * ecranCerere = [[EcranCerereOfertaViewController alloc] initWithNibName:@"EcranCerereOfertaViewController" bundle:nil];
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            [self presentModalViewController:ecranCerere animated:NO];
            [self prezintaEcranCerereOferta];
            break;
        }
        case NotReachable:
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"infopensiuni.ro" message:@"Telefonul tau nu este conectat la internet.Aplicatia nu poate continua fara internet" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
            break;
        }
            
    }

}


-(void)prezintaEcranCerereOferta{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        EcranCerereOfertaViewController * ecranCerere = [[EcranCerereOfertaViewController alloc] initWithNibName:@"EcranCerereOfertaViewController" bundle:nil];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        ecranCerere.myJson = self.myList;
        [self.navigationController pushViewController:ecranCerere animated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            EcranCerereOfertaViewController * ecranCerere = [[EcranCerereOfertaViewController alloc] initWithNibName:@"EcranCerereOfertaViewController" bundle:nil];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            ecranCerere.myJson = self.myList;
            [self.navigationController pushViewController:ecranCerere animated:NO];
        }
        else{
            EcranCerereOfertaViewController * ecranCerere = [[EcranCerereOfertaViewController alloc] initWithNibName:@"EcranCerereOfertaViewController" bundle:nil];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            ecranCerere.myJson = self.myList;
            [self.navigationController pushViewController:ecranCerere animated:NO];
        }
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}

@end
