//
//  EcranObiectiveViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 09/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranObiectiveViewController.h"
#import "PensionTableViewCell.h"
#import "EcranPensiune.h"
#include "ASIHTTPRequest.h"
#import <QuartzCore/QuartzCore.h>
#import "EcranLocalizareViewController.h"
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#import "SHKItem.h"
//#import "SHK.h"
//#import "SHKActionSheet.h"

@interface EcranObiectiveViewController ()

@end


@implementation EcranObiectiveViewController
@synthesize mainScrollView, headerView, titleLabel, titleView, shareButton, backView, bubleView, addressTextView, addressView, descriptionView, descriptionWebView, nearbyPlacesLabel, nearbyPlacesTable, nearbyPlacesView, backTitle, backString, myImageViewer, backFromMapView, bookingLabel, backToMap, greenBorder;
@synthesize  myJson;

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
    //ComNSLog(@"%s",__func__);
    [super viewDidLoad];
    
    // ne asiguram ca touch pe status bar va functiona
    
    [mainScrollView setScrollsToTop:YES];
    [nearbyPlacesTable setScrollsToTop:NO];
    [descriptionWebView.scrollView setScrollsToTop:NO];
    
    [nearbyPlacesTable setScrollEnabled:NO];
    [nearbyPlacesTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    self.myJson = [myJson objectForKey:@"results"];
    //ComNSLog(@"MYJSON %@", myJson);

//    myJson = @{@"status":@"OK",@"results":@{@"id":@2184,@"nume":@"Manastirea Bixad ggjjppqq",@"urlShare":@"http://www.infopensiuni.ro/cazare-bixad/obiective-turistice-bixad/manastirea-bixad_2184",@"fotos":@[@"http://www.infopensiuni.ro/poze/obiective/view/2184_1.jpg"],@"gps":@[@47.9363747,@23.3952866],@"adresa":@"Bixad, Satu Mare ggjjppqq",@"localitate":@{@"id":@217,@"idJudet":@37,@"nume":@"Bixad"},@"judet":@{@"id":@37,@"nume":@"Satu Mare"},@"descriere":@"Manastirea Bixad se afla in localitatea cu acelasi nume, judetul Satu Mare existand viata monahala inca din vremea Maramuresului voievodal, la 1614.<br /><br />Avand hramul Sfintii Apostoli Petru si Pavel, biserica a fost ridicata incepand cu anul 1769, fiind sfintita in anul 1771. Monumentul pastreaza planul arhitectural bizantin in cruce greaca.<br /><br />Ca multe alte biserici, a fost desfiintata in timpul comunismului fiind transformata in parohie in anul 1948. Urmeaza o perioada de restaurari complete, atat la interior cat si la exterior. Biserica este pictata din nou si dotata cu mobilier nou.<br /><br />La Manastirea Bixad turistii vin in numar foarte mare, pastrand traditia cu prilejul sarbatorilor Adormirea Maicii Domnului (15 august), Nasterea Maicii Domnului (8 septembrie), Taierea Capului Sfantului Ioan Botezatorul (29 august) si Ziua Sfintei Crucii (14 septembrie).<br /><br /><br /><a href=\"http://www.crestinortodox.ro/biserici-manastiri/manastirea-bixad-67983.html\" target=\"_blank\"u00a0rel=\"nofollow\">Sursa</a>",@"cazareApropiere":@[@{@"id":@4834,@"nume":@"Adi",@"tip":@"Pensiunea",@"numeText":@"Pensiunea Adi",@"urlFoto":@"http://www.infopensiuni.ro/poze/uc/thumbs/68676.jpg",@"categorie":@3,@"pret":@{@"suma":@70,@"moneda":@"RON",@"tip":@"noapte",@"text":@"70 RON/noapte"}},@{@"id":@3773,@"nume":@"Victoria",@"tip":@"Pensiunea",@"numeText":@"Pensiunea Victoria",@"urlFoto":@"http://www.infopensiuni.ro/poze/uc/thumbs/63169.jpg",@"categorie":@3,@"pret":@{@"suma":@158,@"moneda":@"RON",@"tip":@"noapte",@"text":@"158 RON/noapte"}},@{@"id":@2296,@"nume":@"Dealul Florilor",@"tip":@"Pensiunea",@"numeText":@"Pensiunea Dealul Florilor",@"urlFoto":@"http://www.infopensiuni.ro/poze/uc/thumbs/2296_deal-1.jpg",@"categorie":@3,@"pret":@{@"suma":@100,@"moneda":@"RON",@"tip":@"noapte",@"text":@"100 RON/noapte"}}]}}[@"results"];
    
    nearbyPlacesArray = myJson[@"cazareApropiere"];
    
    //ComNSLog(@"back string---%@",backString);
    
    if([backString isEqualToString:@"Harta"]){
        [backView setHidden:YES];
    }
    else{
        [backToMap setHidden:YES];
        //[backFromMapView setHidden:YES];
        backTitle.text = [NSString stringWithFormat:@" %@",backString];
    }
    
    
    //[mainScrollView bringSubviewToFront:myImageViewer];

    [myImageViewer setDelegate:self];
    NSMutableArray * imagesURL;
    imagesURL = [[NSMutableArray alloc] init];
    
    for(int i=0; i< [myJson[@"fotos"] count]; i++){
        NSURL * mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",myJson[@"fotos"][i]]];
        if(mURL != nil && [mURL class] != [NSNull class]){
            [imagesURL addObject:mURL];
        }
        //ComNSLog(@"mURL---%@",mURL);
        
    }
    
    [myImageViewer setImagesUrls:imagesURL];
    [myImageViewer setInitialPage:0];
    
    [self sizePageControlIndicatorsToFit];
    
//    addressTextView.contentInset = UIEdgeInsetsZero;
//    addressTextView.showsHorizontalScrollIndicator = NO;
    
    [addressTextView setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    [bookingLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    
    [titleLabel setTextColor:[UIColor whiteColor]];
    [bookingLabel setTextColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f]];
    
    [shareButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backTitle setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backTitle setTextColor:UIColorFromRGB(0x666666)];
    
    [backToMap setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [backToMap.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
      backToMap.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView setBackgroundColor:UIColorFromRGB(0xafcf45)];
  
   
    
    
   
}

-(int)numberOfImages
{
    return 0;[myImageViewer.imagesUrls count];
}


-(UIImageView *)imageViewForPage:(int)page
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dark_blue.jpg"]];
    //[imgView setContentMode:UIViewContentModeScaleAspectFill];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("iamge downloader", NULL);
    
    dispatch_async(downloadQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[myImageViewer.imagesUrls objectAtIndex:page]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.image = [UIImage imageWithData:imgData];
        });
    });
    return imgView;
}

-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    [mainScrollView setBounces:YES];
    
    controller = [[DataMasterProcessor alloc] init];
    
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    [mainScrollView setScrollEnabled:YES];
    
    [titleLabel setText:myJson[@"nume"]];
    
    //intializeaza slider
//    if([myJson[@"fotos"] count] > 1){
//      [self initSliderWithInt:[myJson[@"fotos"] count]];
//    }
    

    
    // adauga adresa
    [mainScrollView addSubview:addressView];
    

    
    
    //ComNSLog(@"bubleview frame---%@", NSStringFromCGRect(bubleView.frame));
    //ComNSLog(@"imageviewer frame---%@", NSStringFromCGRect(myImageViewer.frame));
    

    
    NSString *infoString=myJson[@"adresa"];
    
    
    infoString = [infoString stringByAppendingFormat:@" (harta)"];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans-Light" size:17.5f] forKey:NSFontAttributeName];
   
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:infoString];
    [string addAttributes:attrsDictionary range:NSMakeRange(0, infoString.length)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0,infoString.length)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x06a6ea) range:NSMakeRange(infoString.length -6,5 )];
    
    [addressTextView setAttributedText:string];
    
    [addressTextView setEditable:NO];
    [addressTextView setScrollEnabled:NO];
    
    UITapGestureRecognizer * adrRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMap:)];
    [addressTextView addGestureRecognizer:adrRecognizer];

    
    
    CGFloat descriptionContentHeight = [self sizeOfText:[NSString stringWithFormat:@"%@\n",addressTextView.text] widthOfTextView:addressTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]].height + 4;
    
    addressTextView.contentInset = UIEdgeInsetsMake(-10,8,0,0);
//    [addressTextView setUserInteractionEnabled:NO];
    [addressTextView setFrame:CGRectMake(addressTextView.frame.origin.x,addressTextView.frame.origin.y ,addressTextView.frame.size.width, descriptionContentHeight)];
    [addressView setFrame:CGRectMake(addressView.frame.origin.x, CGRectGetMaxY(myImageViewer.frame),self.view.bounds.size.width , addressTextView.frame.origin.y + addressTextView.frame.size.height)];
    
    //[addressTextView setScrollEnabled:NO];
    
    //adauga descriere
    [mainScrollView addSubview:descriptionView];
    
//    CGRect descriptionViewNewFrame = descriptionView.frame;
//    descriptionViewNewFrame.origin.y = CGRectGetMaxY(addressView.frame);
//    [descriptionView setFrame:descriptionViewNewFrame];
//    
//    //ComNSLog(@"address frame---%@",NSStringFromCGRect(addressView.frame));
//    //ComNSLog(@"description frame---%@",NSStringFromCGRect(descriptionView.frame));
    

    //ComNSLog(@"address frame:   %@", NSStringFromCGRect(addressView.frame));
    
    NSString *body = myJson[@"descriere"];
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>body{background:#FFFFFF; text:#666666;font-family:helvetica;font-size:15px;font-weight:lighter}</style></head>%@</body></html>",body];
    
    [descriptionWebView setScalesPageToFit:NO];
    
    

 
    
    [descriptionWebView loadHTMLString:htmlString baseURL:nil];
    [descriptionWebView setUserInteractionEnabled:NO];
    

    
}

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    
    int height = [[UIScreen mainScreen] bounds].size.width - headerView.frame.size.height-20;
   
    [greenBorder setBackgroundColor:UIColorFromRGB(0x94af39)];
    
    viewerPortraitFrame = CGRectMake(0, myImageViewer.frame.origin.y, [[UIScreen mainScreen] bounds].size.width, myImageViewer.frame.size.height);
    
    viewerLandscapeFrame =  CGRectMake(0, myImageViewer.frame.origin.y, [[UIScreen mainScreen] bounds].size.height,height);
    //ComNSLog(@"viewerLandscapeFrame:    %@", NSStringFromCGRect(viewerLandscapeFrame));
    mainScrollViewPortraitFrame = mainScrollView.frame;
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
//        [mainScrollView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
//        [myImageViewer setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
        //ComNSLog(@"headerView frame:    %@", NSStringFromCGRect(headerView.frame));
        [myImageViewer setFrame:viewerLandscapeFrame];
        
        //ComNSLog(@"imageviewer frame:   %@", NSStringFromCGRect(myImageViewer.frame));
        [mainScrollView setContentOffset:CGPointZero animated:NO];
//        [mainScrollView setScrollEnabled:NO];
      
    }
    else{
        [myImageViewer setFrame:viewerPortraitFrame];
        [mainScrollView setScrollEnabled:YES];
    }
    
   [myImageViewer.greenBorder setFrame: CGRectMake(0, CGRectGetMaxY(myImageViewer.frame)-1, myImageViewer.frame.size.width, 1)];
    //ComNSLog(@"green border frame:  %@", NSStringFromCGRect(myImageViewer.greenBorder.frame));

}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    }


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if(fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        
        //addressTextView.contentInset = UIEdgeInsetsMake(-2,8,0,0);
        //ComNSLog(@"webview frame---%@",NSStringFromCGRect(descriptionWebView.frame));
        //ComNSLog(@"view frame----%@",NSStringFromCGRect(descriptionView.frame));
        
        int height = [[UIScreen mainScreen] bounds].size.width - headerView.frame.size.height-20;
        [myImageViewer setFrame:viewerLandscapeFrame];
        [mainScrollView setContentOffset:CGPointZero animated:NO];
        
        [addressView setFrame:CGRectMake(0, CGRectGetMaxY(myImageViewer.frame), self.view.bounds.size.width, addressView.frame.size.height)];
        //ComNSLog(@"address frame:   %@", NSStringFromCGRect(addressView.frame));
        
        [descriptionView setFrame:CGRectMake(descriptionView.frame.origin.x, CGRectGetMaxY(addressView.frame), self.view.bounds.size.width, descriptionView.frame.size.height)];
        
        //ComNSLog(@"myImageViewer frame---%@", NSStringFromCGRect(myImageViewer.frame));
        
        //[descriptionWebView stringByEvaluatingJavaScriptFromString:@"rotate(0)"];
        
//        NSString *javascript = [NSString stringWithFormat:@"var style = document.createElement(\"style\"); document.head.appendChild(style); style.innerHTML = \"html{-webkit-text-size-adjust: 100%%;}\";var viewPortTag=document.createElement('meta');viewPortTag.id=\"viewport\";viewPortTag.name = \"viewport\";viewPortTag.content = \"width=%f; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\";document.getElementsByTagName('head')[0].appendChild(viewPortTag);",descriptionWebView.frame.size.width];
//        //ComNSLog(@"javascript----%@",javascript);
//        [descriptionWebView stringByEvaluatingJavaScriptFromString:javascript];
        
        float webViewHeight = 0.0;
        
        
        
                if( [descriptionWebView respondsToSelector:@selector(scrollView)] ) {
                    UIScrollView *sv =  [descriptionWebView performSelector:@selector(scrollView)];
                   [sv setDecelerationRate:UIScrollViewDecelerationRateNormal ];
                                    webViewHeight = sv.contentSize.height;
               }
              else
                {
       
                   for( UIScrollView *view in [descriptionWebView subviews] ) {
                       if( [view isKindOfClass:[UIScrollView class]] ) {
                          [view setDecelerationRate:UIScrollViewDecelerationRateNormal];//0.998000
                        
                          webViewHeight = view.contentSize.height;
                       }
                   }
               }
        
        //        [descriptionView setFrame:CGRectMake(descriptionView.frame.origin.x, descriptionView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, descriptionView.frame.size.height)];
        //        [descriptionWebView setFrame:CGRectMake(descriptionWebView.frame.origin.x, descriptionWebView.frame.origin.y, descriptionView.frame.size.width - (descriptionWebView.frame.origin.x * 2), descriptionWebView.frame.size.height)];
        


//        webViewHeight =[[descriptionWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
        
        CGRect frame = descriptionWebView.frame;
        frame.size.height = 1;
        descriptionWebView.frame = frame;
        CGSize fittingSize = [descriptionWebView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        descriptionWebView.frame = frame;
        webViewHeight = fittingSize.height;
        
        [descriptionWebView setFrame:CGRectMake(descriptionWebView.frame.origin.x, descriptionWebView.frame.origin.y, descriptionWebView.frame.size.width, webViewHeight)];
        
        
        CGRect descriptionViewNewFrame = descriptionView.frame;
        descriptionViewNewFrame.size.height = CGRectGetMaxY(descriptionWebView.frame);
        [descriptionView setFrame:descriptionViewNewFrame];
        
        
        CGRect nearbyNewRect = nearbyPlacesView.frame;
        nearbyNewRect.origin.y = descriptionView.frame.origin.y + descriptionView.frame.size.height;
        [nearbyPlacesView setFrame:nearbyNewRect];
        
        [nearbyPlacesView setFrame:CGRectMake(nearbyPlacesView.frame.origin.x, nearbyPlacesView.frame.origin.y, nearbyPlacesView.frame.size.width, nearbyPlacesTable.frame.size.height + nearbyPlacesTable.frame.origin.y)];
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,CGRectGetMaxY(nearbyPlacesView.frame))];
        //ComNSLog(@"main scroll view content size rot from portrait:   %@",NSStringFromCGSize(mainScrollView.contentSize));
        
        //        [mainScrollView setScrollEnabled:NO];
        //        [mainScrollView bringSubviewToFront:myImageViewer];
        
        //ComNSLog(@"description view frame---%@", NSStringFromCGRect(descriptionView.frame));
        //ComNSLog(@"nearby places view---%@", NSStringFromCGRect(nearbyPlacesView.frame));
        
        [myImageViewer.greenBorder setFrame: CGRectMake(0, CGRectGetMaxY(myImageViewer.frame)-1, myImageViewer.frame.size.width, 1)];
        //ComNSLog(@"green border frame:  %@", NSStringFromCGRect(myImageViewer.greenBorder.frame));
    }
    else{
        //addressTextView.contentInset = UIEdgeInsetsMake(-2,8,0,0);
        //ComNSLog(@"webview frame---%@",NSStringFromCGRect(descriptionWebView.frame));
        //ComNSLog(@"view frame----%@",NSStringFromCGRect(descriptionView.frame));
        
        [mainScrollView setScrollEnabled:YES];
        //        [mainScrollView setFrame:mainScrollViewPortraitFrame];
        [myImageViewer setFrame:viewerPortraitFrame];
        [addressView setFrame:CGRectMake(0, CGRectGetMaxY(myImageViewer.frame), self.view.bounds.size.width, addressView.frame.size.height)];
        
        //ComNSLog(@"address frame:   %@", NSStringFromCGRect(addressView.frame));
        [descriptionView setFrame:CGRectMake(descriptionView.frame.origin.x, CGRectGetMaxY(addressView.frame), self.view.bounds.size.width, descriptionView.frame.size.height)];
        //
        //        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, nearbyPlacesView.frame.size.height + nearbyPlacesView.frame.origin.y + 150 )];
        
        
        //        CGRect scrollViewFrame = mainScrollView.frame;
        //        scrollViewFrame.size.height = self.view.frame.size.height;
        //        [mainScrollView setFrame:scrollViewFrame];
        
        //        [mainScrollView sendSubviewToBack:myImageViewer];
        //[descriptionWebView stringByEvaluatingJavaScriptFromString:@"rotate(0)"];
        
        float webViewHeight = 0.0;
        
        
//        NSString *javascript = [NSString stringWithFormat:@"var style = document.createElement(\"style\"); document.head.appendChild(style); style.innerHTML = \"html{-webkit-text-size-adjust: 100%%;}\";var viewPortTag=document.createElement('meta');viewPortTag.id=\"viewport\";viewPortTag.name = \"viewport\";viewPortTag.content = \"width=%f; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\";document.getElementsByTagName('head')[0].appendChild(viewPortTag);",descriptionWebView.frame.size.width];
//        //ComNSLog(@"javascript----%@",javascript);
//        [descriptionWebView stringByEvaluatingJavaScriptFromString:javascript];
        
//        webViewHeight =[[descriptionWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
        
        if( [descriptionWebView respondsToSelector:@selector(scrollView)] ) {
                    UIScrollView *sv =  [descriptionWebView performSelector:@selector(scrollView)];
                    [sv setDecelerationRate:UIScrollViewDecelerationRateNormal ];
                    webViewHeight = sv.contentSize.height;
                }
                else
                {
        
                    for( UIScrollView *view in [descriptionWebView subviews] ) {
                        if( [view isKindOfClass:[UIScrollView class]] ) {
                            [view setDecelerationRate:UIScrollViewDecelerationRateNormal];//0.998000
                            webViewHeight = view.contentSize.height;
                        }
                    }
            }

        
        //ComNSLog(@"webview height---%f",webViewHeight);
        
        CGRect descriptionViewNewFrame = descriptionView.frame;
        descriptionViewNewFrame.size.height = descriptionWebView.frame.origin.y + webViewHeight;
        [descriptionView setFrame:descriptionViewNewFrame];
        
        [descriptionWebView setFrame:CGRectMake(descriptionWebView.frame.origin.x, descriptionWebView.frame.origin.y, descriptionWebView.frame.size.width, webViewHeight)];
        
        CGRect nearbyNewRect = nearbyPlacesView.frame;
        nearbyNewRect.origin.y = descriptionView.frame.origin.y + descriptionView.frame.size.height;
        [nearbyPlacesView setFrame:nearbyNewRect];
        
        [nearbyPlacesView setFrame:CGRectMake(nearbyPlacesView.frame.origin.x, nearbyPlacesView.frame.origin.y, self.view.bounds.size.width, nearbyPlacesTable.frame.size.height + nearbyPlacesTable.frame.origin.y)];
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,CGRectGetMaxY(nearbyPlacesView.frame))];
        //ComNSLog(@"main scroll view content size rotate from landscape:   %@",NSStringFromCGSize(mainScrollView.contentSize));
        [myImageViewer.greenBorder setFrame: CGRectMake(0, CGRectGetMaxY(myImageViewer.frame)-1, myImageViewer.frame.size.width, 1)];
        //ComNSLog(@"green border frame:  %@", NSStringFromCGRect(myImageViewer.greenBorder.frame));
    }

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)pushMap:(UITapGestureRecognizer *)recognizer{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
//            EcranLocalizareViewController * ecrLocVC = [[EcranLocalizareViewController alloc] initWithNibName:@"EcranLocalizareViewController" bundle:nil];
//            ecrLocVC.myJson = myJson;
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            
//            [self presentModalViewController:ecrLocVC animated:NO];
            [self prezintaEcranLocalizare];
            break;
        }
        case ReachableViaWiFi:
        {
//            EcranLocalizareViewController * ecrLocVC = [[EcranLocalizareViewController alloc] initWithNibName:@"EcranLocalizareViewController" bundle:nil];
//            ecrLocVC.myJson = myJson;
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            
//            [self presentModalViewController:ecrLocVC animated:NO];
            [self prezintaEcranLocalizare];
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




-(void)prezintaEcranLocalizare{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        EcranLocalizareViewController * ecrLocVC = [[EcranLocalizareViewController alloc] initWithNibName:@"EcranLocalizareViewController" bundle:nil];
        ecrLocVC.myJson = myJson;
         ecrLocVC.dinceEcranvine =@"obiectiv";
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self.navigationController pushViewController:ecrLocVC animated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            EcranLocalizareViewController * ecrLocVC = [[EcranLocalizareViewController alloc] initWithNibName:@"EcranLocalizareViewController" bundle:nil];
            ecrLocVC.myJson = myJson;
             ecrLocVC.dinceEcranvine =@"obiectiv";
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:ecrLocVC animated:NO];
        }
        else{
            EcranLocalizareViewController * ecrLocVC = [[EcranLocalizareViewController alloc] initWithNibName:@"EcranLocalizareViewController" bundle:nil];
            ecrLocVC.myJson = myJson;
             ecrLocVC.dinceEcranvine =@"obiectiv";
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:ecrLocVC animated:NO];
        }
        
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //ComNSLog(@"s-a incarcat");
    if(webView == descriptionWebView){

//        float webViewHeight = 0.0;
//
//        CGRect frame = descriptionWebView.frame;
//        frame.size.height = 1;
//        descriptionWebView.frame = frame;
//        CGSize fittingSize = [descriptionWebView sizeThatFits:CGSizeZero];
//        frame.size = fittingSize;
//        descriptionWebView.frame = frame;
//        
//        webViewHeight = fittingSize.height;
//       
//        CGRect descriptionViewNewFrame = descriptionView.frame;
//        descriptionViewNewFrame.size.height = descriptionWebView.frame.origin.y + webViewHeight;
//        descriptionViewNewFrame.size.width = self.view.bounds.size.width;
//        [descriptionView setFrame:descriptionViewNewFrame];
//        
////       [descriptionWebView setFrame:CGRectMake(descriptionWebView.frame.origin.x, descriptionWebView.frame.origin.y, descriptionWebView.frame.size.width, webViewHeight)];
//
//        
//        
//        [mainScrollView addSubview:nearbyPlacesView];
//        

//        
//        CGRect nearbyNewRect = nearbyPlacesView.frame;
//        nearbyNewRect.origin.y = descriptionView.frame.origin.y + descriptionView.frame.size.height;
//        [nearbyPlacesView setFrame:nearbyNewRect];
//        

//
//
//        NSString *javascript = [NSString stringWithFormat:@"var style = document.createElement(\"style\"); document.head.appendChild(style); style.innerHTML = \"html{-webkit-text-size-adjust: none;}\";var viewPortTag=document.createElement('meta');viewPortTag.id=\"viewport\";viewPortTag.name = \"viewport\";viewPortTag.content = \"width=%f; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\";document.getElementsByTagName('head')[0].appendChild(viewPortTag);",descriptionWebView.frame.size.width];
//        //ComNSLog(@"javascript----%@",javascript);
//        [descriptionWebView stringByEvaluatingJavaScriptFromString:javascript];
//        
//
//        
//        
//        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,CGRectGetMaxY(nearbyPlacesView.frame))];
//        
//        //ComNSLog(@"webView height----%f", webViewHeight);
//        
//        //ComNSLog(@"nearby place---%@",NSStringFromCGRect(nearbyPlacesView.frame));
//        //ComNSLog(@"addres view---%@", NSStringFromCGRect(addressView.frame));
//        //ComNSLog(@"description view---%@", NSStringFromCGRect(descriptionView.frame));
//        //ComNSLog(@"image---%@", NSStringFromCGRect(myImageViewer.frame));
        
        
        NSString *javascript = [NSString stringWithFormat:@"var style = document.createElement(\"style\"); document.head.appendChild(style); style.innerHTML = \"html{-webkit-text-size-adjust:100%%;}\";var viewPortTag=document.createElement('meta');viewPortTag.id=\"viewport\";viewPortTag.name = \"viewport\";viewPortTag.content = \"width=%f; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\";document.getElementsByTagName('head')[0].appendChild(viewPortTag);",descriptionWebView.frame.size.width];
                   //ComNSLog(@"javascript----%@",javascript);
        [descriptionWebView stringByEvaluatingJavaScriptFromString:javascript];
        
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
            
            
            //ComNSLog(@"webview frame---%@",NSStringFromCGRect(descriptionWebView.frame));
            //ComNSLog(@"view frame----%@",NSStringFromCGRect(descriptionView.frame));
            
            [myImageViewer setFrame:CGRectMake(0, headerView.frame.size.height, [[UIScreen mainScreen] bounds].size.height, myImageViewer.frame.size.height)];
            
            [addressView setFrame:CGRectMake(addressView.frame.origin.x, CGRectGetMaxY(myImageViewer.frame), self.view.bounds.size.width, addressView.frame.size.height)];
            [mainScrollView setContentOffset:CGPointZero animated:NO];
            
            
            [descriptionView setFrame:CGRectMake(descriptionView.frame.origin.x, CGRectGetMaxY(addressView.frame), self.view.bounds.size.width, descriptionView.frame.size.height)];
            
            //[descriptionWebView stringByEvaluatingJavaScriptFromString:@"rotate(0)"];
            
//            NSString *javascript = [NSString stringWithFormat:@"var style = document.createElement(\"style\"); document.head.appendChild(style); style.innerHTML = \"html{-webkit-text-size-adjust:100%%;}\";var viewPortTag=document.createElement('meta');viewPortTag.id=\"viewport\";viewPortTag.name = \"viewport\";viewPortTag.content = \"width=%f; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\";document.getElementsByTagName('head')[0].appendChild(viewPortTag);",descriptionWebView.frame.size.width];
//            //ComNSLog(@"javascript----%@",javascript);
//            [descriptionWebView stringByEvaluatingJavaScriptFromString:javascript];
            
            
            
            float webViewHeight = 0.0;
            
          
            
            CGRect frame = descriptionWebView.frame;
            frame.size.height = 1;
            descriptionWebView.frame = frame;
            CGSize fittingSize = [descriptionWebView sizeThatFits:CGSizeZero];
            frame.size = fittingSize;
            descriptionWebView.frame = frame;
            
            //ComNSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
            webViewHeight = fittingSize.height;
            
            //ComNSLog(@"description web view frame:   %@", NSStringFromCGRect(descriptionWebView.frame));
            
            [descriptionWebView setFrame:CGRectMake(descriptionWebView.frame.origin.x, descriptionWebView.frame.origin.y, descriptionWebView.frame.size.width, webViewHeight)];
            
            //ComNSLog(@"description web view frame:   %@", NSStringFromCGRect(descriptionWebView.frame));
            
            CGRect descriptionViewNewFrame = descriptionView.frame;
            descriptionViewNewFrame.size.height = CGRectGetMaxY(descriptionWebView.frame);
            descriptionViewNewFrame.size.width = self.view.bounds.size.width;
            descriptionViewNewFrame.origin.y = CGRectGetMaxY(addressView.frame);
            [descriptionView setFrame:descriptionViewNewFrame];

            
            [mainScrollView addSubview:nearbyPlacesView];
            
            [nearbyPlacesTable setFrame:CGRectMake(nearbyPlacesTable.frame.origin.x, nearbyPlacesTable.frame.origin.y, nearbyPlacesTable.frame.size.width, [nearbyPlacesArray count] * 93)];
            
            CGRect nearbyNewRect = nearbyPlacesView.frame;
            nearbyNewRect.origin.y = descriptionView.frame.origin.y + descriptionView.frame.size.height;
            [nearbyPlacesView setFrame:nearbyNewRect];
            
            [nearbyPlacesView setFrame:CGRectMake(nearbyPlacesView.frame.origin.x, nearbyPlacesView.frame.origin.y, self.view.bounds.size.width, nearbyPlacesTable.frame.size.height + nearbyPlacesTable.frame.origin.y)];
            
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,CGRectGetMaxY(nearbyPlacesView.frame))];
            //ComNSLog(@"main scroll view content size did finish landsc:   %@",NSStringFromCGSize(mainScrollView.contentSize));
            
            //        [mainScrollView setScrollEnabled:NO];
            //        [mainScrollView bringSubviewToFront:myImageViewer];
            
            //ComNSLog(@"description view frame---%@", NSStringFromCGRect(descriptionView.frame));
            //ComNSLog(@"nearby places view---%@", NSStringFromCGRect(nearbyPlacesView.frame));
            
            
        }
        else{
            
            //ComNSLog(@"webview frame---%@",NSStringFromCGRect(descriptionWebView.frame));
            //ComNSLog(@"view frame----%@",NSStringFromCGRect(descriptionView.frame));
            
            [mainScrollView setScrollEnabled:YES];
            //        [mainScrollView setFrame:mainScrollViewPortraitFrame];
            [myImageViewer setFrame:viewerPortraitFrame];
            [addressView setFrame:CGRectMake(addressView.frame.origin.x, CGRectGetMaxY(myImageViewer.frame), self.view.bounds.size.width, addressView.frame.size.height)];
            [mainScrollView setContentOffset:CGPointZero animated:NO];
            
            
            [descriptionView setFrame:CGRectMake(descriptionView.frame.origin.x, CGRectGetMaxY(addressView.frame), self.view.bounds.size.width, descriptionView.frame.size.height)];
            
            //
            //        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, nearbyPlacesView.frame.size.height + nearbyPlacesView.frame.origin.y + 150 )];
            
            
            //        CGRect scrollViewFrame = mainScrollView.frame;
            //        scrollViewFrame.size.height = self.view.frame.size.height;
            //        [mainScrollView setFrame:scrollViewFrame];
            
            //        [mainScrollView sendSubviewToBack:myImageViewer];
           // [descriptionWebView stringByEvaluatingJavaScriptFromString:@"rotate(1)"];
            
            float webViewHeight = 0.0;
            
            
//            NSString *javascript = [NSString stringWithFormat:@"var style = document.createElement(\"style\"); document.head.appendChild(style); style.innerHTML = \"html{-webkit-text-size-adjust: 100%%;}\";var viewPortTag=document.createElement('meta');viewPortTag.id=\"viewport\";viewPortTag.name = \"viewport\";viewPortTag.content = \"width=300; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\";document.getElementsByTagName('head')[0].appendChild(viewPortTag);"];
//            //ComNSLog(@"javascript----%@",javascript);
//            [descriptionWebView stringByEvaluatingJavaScriptFromString:javascript];
            
            //        webViewHeight =[[descriptionWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
            
            //ComNSLog(@"web view frame---%@",NSStringFromCGRect(descriptionWebView.frame));
            //ComNSLog(@"view frame---%@", NSStringFromCGRect(descriptionView.frame));
            

            CGRect frame = descriptionWebView.frame;
            frame.size.height = 1;
            descriptionWebView.frame = frame;
            CGSize fittingSize = [descriptionWebView sizeThatFits:CGSizeZero];
            frame.size = fittingSize;
            descriptionWebView.frame = frame;
            
            
            //ComNSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
            webViewHeight = fittingSize.height;
             //ComNSLog(@"description web view frame:   %@", NSStringFromCGRect(descriptionWebView.frame));
            [descriptionWebView setFrame:CGRectMake(descriptionWebView.frame.origin.x, descriptionWebView.frame.origin.y, descriptionWebView.frame.size.width, webViewHeight)];
             //ComNSLog(@"description web view frame:   %@", NSStringFromCGRect(descriptionWebView.frame));
            CGRect descriptionViewNewFrame = descriptionView.frame;
            descriptionViewNewFrame.size.height = descriptionWebView.frame.origin.y + webViewHeight;
            [descriptionView setFrame:descriptionViewNewFrame];
            

            
            [mainScrollView addSubview:nearbyPlacesView];
            [nearbyPlacesTable setFrame:CGRectMake(nearbyPlacesTable.frame.origin.x, nearbyPlacesTable.frame.origin.y, nearbyPlacesTable.frame.size.width, [nearbyPlacesArray count] * 93)];
            
            CGRect nearbyNewRect = nearbyPlacesView.frame;
            nearbyNewRect.origin.y = descriptionView.frame.origin.y + descriptionView.frame.size.height;
            [nearbyPlacesView setFrame:nearbyNewRect];
            
            [nearbyPlacesView setFrame:CGRectMake(nearbyPlacesView.frame.origin.x, nearbyPlacesView.frame.origin.y, self.view.bounds.size.width, nearbyPlacesTable.frame.size.height + nearbyPlacesTable.frame.origin.y)];
           
            
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width,CGRectGetMaxY(nearbyPlacesView.frame))];
             //ComNSLog(@"main scroll view content size did finish portrait:   %@",NSStringFromCGSize(mainScrollView.contentSize));
            
        }


    }
    else{
//        if(webView == addressWebView){
////            NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
////            [webView stringByEvaluatingJavaScriptFromString:padding];
//            [webView.scrollView setScrollEnabled:NO];
//            UITapGestureRecognizer * webRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMap:)];
//            [webRecognizer setDelegate:self];
//            [webView addGestureRecognizer:webRecognizer];
//        }
    }
}






// metode tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
        static NSString *CellIdentifier = @"PensionTableViewCell";
    
        PensionTableViewCell *cell = (PensionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        [cell setTag:[nearbyPlacesArray[indexPath.row][@"categorie"] intValue]];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PensionTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (PensionTableViewCell *) currentObject;
                    break;
                }
            }
        }
    
    [cell.title setText:nearbyPlacesArray[indexPath.row][@"numeText"]];
    [cell.priceLabel setText:nearbyPlacesArray[indexPath.row][@"pret"][@"text"]];
    
    [cell.title setTextColor:UIColorFromRGB(0x333333)];
    [cell.priceLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [cell.title setFont:[UIFont fontWithName:@"OpenSans-Light" size:18.5f]];
    [cell.priceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:13.5f]];
    
    [cell.distanceLabel setText:[NSString stringWithFormat:@"%@",nearbyPlacesArray[indexPath.row][@"distanta"]]];
    [cell.distanceLabel setHidden:NO];
    
    [cell.distanceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0f]];
    
    [cell.distanceLabel setTextColor:UIColorFromRGB(0x666666)];
    
    
     [controller downloadImageWithURL:[NSURL URLWithString:nearbyPlacesArray[indexPath.row][@"urlFoto"]] completionBlock:^(BOOL  succeeded, UIImage *image) {
         if (succeeded) {
            [cell.thumbImage setImage:image];
         }
      }];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //// adauga stele
    
    int numberOfStars= [nearbyPlacesArray[indexPath.row][@"categorie"] intValue] , xPosition =0, yPosition = 0;
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [nearbyPlacesArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            [self pregatestePensiune:[NSString stringWithFormat:@"%@",nearbyPlacesArray[indexPath.row][@"id"]]];
            break;
        }
        case ReachableViaWiFi:
        {
            [self pregatestePensiune:[NSString stringWithFormat:@"%@",nearbyPlacesArray[indexPath.row][@"id"]]];
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
-(bool)checkDictionary:(NSDictionary *)dict{
    if(dict == nil || [dict class] == [NSNull class] || ![dict isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    
    return  YES;
}

-(void) pregatestePensiune :(NSString*)pensiuneID {
    if(pensiuneID) {

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
            if([self checkDictionary:REZOLVA_PENSIUNE]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"Va rugam asteptati";
                [self rezolvaPensiune:REZOLVA_PENSIUNE];
            }
            else{
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Comunicarea cu serverul a esuat.\nIncearca peste cateva momente" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }

        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            //ComNSLog(@"Error: %@", error.localizedDescription);
        }];
        [request startAsynchronous];
    }
}
-(void) rezolvaPensiune:(NSDictionary *)REZOLVA_PENSIUNE {
    if(REZOLVA_PENSIUNE) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
            EcranPensiuneViewController *ecranPensiune = [[EcranPensiuneViewController alloc] initWithNibName:@"EcranPensiune" bundle:nil];
            ecranPensiune.myJson = REZOLVA_PENSIUNE;
            ecranPensiune.backString = titleLabel.text;
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
                ecranPensiune.backString = titleLabel.text;
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
                ecranPensiune.backString = titleLabel.text;
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



//init slider
-(void)initSliderWithInt:(int)numberOfPhotos{
    
    int xPosition, yPosition;
    
    xPosition = (bubleView.frame.size.width - (14 * numberOfPhotos + 5 * (numberOfPhotos -1))) / 2;
    yPosition = (bubleView.frame.size.height - 13) / 2;
    
    if(numberOfPhotos > 0){
        UIImageView *sliderThumb = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 14, 13)];
        [sliderThumb setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider-thumb-active" ofType:@"png"]]];
        [bubleView addSubview:sliderThumb];
        
        xPosition = xPosition + 20;
        
        for(int i=1; i < numberOfPhotos; i++){
            UIImageView *sliderThumb = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 14, 13)];
            xPosition = xPosition + 20;
            
            [sliderThumb setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider-tumb" ofType:@"png"]]];
            [bubleView addSubview:sliderThumb];
        }
    }
}




// util

//-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
//{
//    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    return size;
//}

// back

-(IBAction)backAction:(UIButton *)backButton{
    
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

-(IBAction)shareAction:(UIButton*)shareButton{
        
//    NSURL *url = [NSURL URLWithString:[self.myJson objectForKey:@"urlShare"]];
    
//    NSString *urltitle = [NSString stringWithFormat:@"%@",[self.myJson objectForKey:@"nume"]];
//    SHKItem *item = [SHKItem URL:url title:urltitle contentType:SHKURLContentTypeWebpage];
//    [item setTitle:[NSString stringWithFormat:@"Iti recomand %@", [self.myJson objectForKey:@"nume"]]];
//    [item setText:[NSString stringWithFormat:@"Salutare,<br><br>Cred ca te-ar interesa %@ din %@ <br><br> Cu sinceritate,",[self.myJson objectForKey:@"nume"],self.myJson[@"localitate"][@"nume"]]];
//    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
//        
//    [SHK setRootViewController:self];
    
//    [actionSheet showInView:self.view];
    
    //ComNSLog(@"share action");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string;
    NSString * name = [defaults objectForKey:@"Nume.Cazare.ro"];
    if(name.length >0){
        string =[NSString stringWithFormat:@"Salutare,\n\nCred ca te-ar interesa %@ din %@\n\nApasa pe linkul de mai jos:\n%@\n\nCu sinceritate,\n%@",[self.myJson objectForKey:@"nume"],self.myJson[@"localitate"][@"nume"],[self.myJson objectForKey:@"urlShare"],name];
    }
    else{
        string =[NSString stringWithFormat:@"Salutare,\n\nCred ca te-ar interesa %@ din %@\n\nApasa pe linkul de mai jos:\n%@\n\nCu sinceritate,\n",[self.myJson objectForKey:@"nume"],self.myJson[@"localitate"][@"nume"],[self.myJson objectForKey:@"urlShare"]];
    }
    

//    NSURL *URL = url;
    
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string]
                                      applicationActivities:nil];
    [activityViewController setValue:[NSString stringWithFormat:@"Iti recomand %@", [self.myJson objectForKey:@"nume"]] forKey:@"subject"];
    
    [self presentModalViewController:activityViewController animated:YES];

    
}

#define PAGE_CONTROL_DEFAULT_PAGE_DIAMETER  12.0
#define PAGE_CONTROL_DEFAULT_PAGE_MARGIN    10.0
#define PAGE_CONTROL_MINIMUM_PAGE_DIAMETER  3.0
#define PAGE_CONTROL_MINIMUM_PAGE_MARGIN    5.0

- (void)sizePageControlIndicatorsToFit {
	// reset defaults
	[myImageViewer.pageControl setIndicatorDiameter:PAGE_CONTROL_DEFAULT_PAGE_DIAMETER];
	[myImageViewer.pageControl setIndicatorMargin:PAGE_CONTROL_DEFAULT_PAGE_MARGIN];
    [myImageViewer.pageControl setBackgroundColor:UIColorFromRGB(0xebf3d0)];
    
	NSInteger indicatorMargin = myImageViewer.pageControl.indicatorMargin;
	NSInteger indicatorDiameter = myImageViewer.pageControl.indicatorDiameter;
    
	CGFloat minIndicatorDiameter = PAGE_CONTROL_MINIMUM_PAGE_DIAMETER;
	CGFloat minIndicatorMargin = PAGE_CONTROL_MINIMUM_PAGE_MARGIN;
    
	NSInteger pages = [myImageViewer.imagesUrls count];//myImageViewer.pageControl.numberOfPages;
	CGFloat actualWidth = [myImageViewer.pageControl sizeForNumberOfPages:pages].width;
    
    //ComNSLog(@"actual width---%f,%f",actualWidth,CGRectGetWidth(myImageViewer.pageControl.bounds));
    //ComNSLog(@"number of photos---%d",[myImageViewer.imagesUrls count]);
	BOOL toggle = YES;
    
	while (actualWidth > CGRectGetWidth(myImageViewer.pageControl.bounds) && (indicatorMargin > minIndicatorMargin || indicatorDiameter > minIndicatorDiameter)) {
		if (toggle) {
			if (indicatorMargin > minIndicatorMargin) {
				myImageViewer.pageControl.indicatorMargin = --indicatorMargin;
			}
		} else {
			if (indicatorDiameter > minIndicatorDiameter) {
				myImageViewer.pageControl.indicatorDiameter = --indicatorDiameter;
			}
		}
		toggle = !toggle;
		actualWidth = [myImageViewer.pageControl sizeForNumberOfPages:pages].width;
	}
    
	if (actualWidth > CGRectGetWidth(myImageViewer.pageControl.bounds)) {
		//ComNSLog(@"Too many pages! Already at minimum margin (%d) and diameter (%d).", indicatorMargin, indicatorDiameter);
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
