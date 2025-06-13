//
//  NoInternetViewController.m
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "Reachability.h"
#import "EcranPensiune.h"
#import "FeeTableViewCell.h"
#import "FacilitiesTableViewCell.h"
#import "LocationTableViewCell.h"
#import  "QuartzCore/QuartzCore.h"
#import "DropDownTableViewCell.h"
#import "EcranObiectiveViewController.h"
#import "EcranComentariiViewController.h"
#import "EcranRezervareViewController.h"
#import "EcranListaPensiuniViewController.h"
#import "EcranListaObiectiveViewController.h"
#include "ASIHTTPRequest.h"
#import "EcranLocalizareViewController.h"
#import "MBProgressHUD.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define bubbleHeight  13
#define bubleWidth 14

@interface EcranPensiuneViewController ()
@end

@implementation EcranPensiuneViewController

@synthesize shareButton, headerView, titleView, pensionTitleLabel, bubleView, feesView, feesTableView, changeDateButton, todayFees, mainScrollView,bookingView, bookingButton, facilitiesLabel, facilitiesTableView, facilitiesView, descriptionWebView, descriptionView, seeComments, locationsView, locationsLabel, locationsTableView, adressTextView, dropDownTableView, dropDownView, hideView, dropDownScrollView, backView, backLabel, backButton, emailButton, callButton,backString,photoViewer, backFromMapView, seeComentsParentView, seeComentsLabel,freeRooms,mapButton, greenBorder, todayOfferSep, toVisitSep, facilitiesSep;
@synthesize myJson;


//////////// json model http://json.infopensiuni.ro/pensiuni/id/2546/
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Prepare activities
    //

    

    
    shareButton.layer.cornerRadius = 5.0;
    shareButton.layer.masksToBounds = YES;
    
    self.myJson = [myJson objectForKey:@"results"];
    //ComNSLog(@"my json---%@", myJson);
    //ComNSLog(@"MYJSON %@", myJson);



    room_icons = @{@"2pers":@"camera_dubla_m.png",@"2persm":@"camera_matrimoniala_m.png",@"1pers":@"camera_single_m.png",@"3pers":@"camera_tripla_m.png",@"1persg":@"garsoniera_m.png",@"4pers":@"apartament_m.png",@"all":@"toata_unitatea_m.png"};
   /* myJson = @{@"status":@"OK",@"results":@{@"id":@2546,@"nume":@"Pompi",@"tip":@"Pensiunea",@"categorie":@3,@"fotos":@[@"http://www.infopensiuni.ro/poze/uc/39005.jpg",@"http://www.infopensiuni.ro/poze/uc/39004.jpg",@"http://www.infopensiuni.ro/poze/uc/39003.jpg",@"http://www.infopensiuni.ro/poze/uc/39002.jpg",@"http://www.infopensiuni.ro/poze/uc/39001.jpg",@"http://www.infopensiuni.ro/poze/uc/33679.jpg",@"http://www.infopensiuni.ro/poze/uc/30254.jpg",@"http://www.infopensiuni.ro/poze/uc/30253.jpg",@"http://www.infopensiuni.ro/poze/uc/30252.jpg",@"http://www.infopensiuni.ro/poze/uc/29040.jpg",@"http://www.infopensiuni.ro/poze/uc/30250.jpg",@"http://www.infopensiuni.ro/poze/uc/30251.jpg"],@"gps":@[@45.637717,@25.615479],@"adresa":@"Brasov, str. Pictor Grigorescu nr. 2A, (cartier Racadau), jud. Brasov",@"localitate":@{@"id":@78,@"idJudet":@7,@"nume":@"Brasov"},@"judet":@{@"id":@7,@"nume":@"Brasov"},@"urlShare":@"http://www.infopensiuni.ro/cazare-brasov/pensiuni-brasov/pensiunea-pompi",@"persContact":@"Pompi",@"telefon":@"0722.326.390",@"email":[NSNull null],@"facilitati":@[@{@"type":@"activitati",@"titlu":@"Activitati",@"icon":@"http://www.infopensiuni.ro/img/facilitati/activitati.png",@"text":@"Trasee / Excursii"},@{@"type":@"internet",@"titlu":@"Internet",@"icon":@"http://www.infopensiuni.ro/img/facilitati/internet.png",@"text":@"Internet"},@{@"type":@"servicii",@"titlu":@"Servicii",@"icon":@"http://www.infopensiuni.ro/img/facilitati/servicii.png",@"text":@"Sala de Conferinte, Organizare evenimente"},@{@"type":@"exterior",@"titlu":@"Exterior",@"icon":@"http://www.infopensiuni.ro/img/facilitati/exterior.png",@"text":@"Gratar"}],@"descriere":@"Situata la poalele Muntelui Tampa, la o distanta de 5 min de centrul orasului, Pensiunea Pompi va ofera climatul de vis specific unei vacante la munte si totodata un cadru prielnic pentru intalnirile dvs. de afaceri.<br /><br />Pensiunea este clasificata de Ministerul turismului la trei stele.<br /><br />Va garantam reusita unei vacante de vis!<br /><br />Este situata in cartierul Racadau, langa Complexul Comercial Magnolia Mall si Biserica Constantin si Elena.  <br /><br />Pensiunea Pompi dispune de:<br />- 5 camere -12 locuri, cu Tv-cablu, minibar, baie proprie, internet (wireless)<br />- Sala de mese (70 locuri)<br />- sala de conferinta<br />- parcare proprie<br /> -grill<br /> -incalzire centralizata<br /> -living<br /> -bar de zi <br /> -asiguram transport pentru vizitarea obiectivelor turistice din judetul Brasov si nu numai (Castelul Bran, Cetatea Rasnov,  Castelul Peles, Cetatea Rupea) etc.<br /> - organizam mese festive <br /><br />Tarife: Single: -89 Ron <br />        Double: -99 Ron <br />        Tripla: -139 Ron  <br />In pretul afisat nu este inclus micul dejun. Optional mic dejun 15 lei/pers.",@"htmlPersonalizat":[NSNull null],@"tarife":@[],@"comentarii":@[],@"obiective":@[@{@"id":@6671,@"nume":@"Treptele lui Gabony spre Varful Tampa, Brasov",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/gabony.jpg",@"distanta":@"3 min cu masina"},@{@"id":@4082,@"nume":@"Rezervatia Naturala Tampa din Brasov",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/4082_1.jpg",@"distanta":@"3 min cu masina"},@{@"id":@6670,@"nume":@"Promenada de sub Tampa, Brasov",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/ppp.jpg",@"distanta":@"4 min cu masina"}]}}[@"results"];*/
    
    
//    myJson = @{@"status":@"OK",@"results":@{@"id":@6137,@"nume":@"Casa Germana",@"tip":@"Pensiunea",@"categorie":@3,@"fotos":@[@"http://www.infopensiuni.ro/poze/uc/68884.JPG",@"http://www.infopensiuni.ro/poze/uc/68883.JPG",@"http://www.infopensiuni.ro/poze/uc/68882.jpg",@"http://www.infopensiuni.ro/poze/uc/68881.jpg",@"http://www.infopensiuni.ro/poze/uc/68880.jpg",@"http://www.infopensiuni.ro/poze/uc/68879.jpg",@"http://www.infopensiuni.ro/poze/uc/68878.jpg",@"http://www.infopensiuni.ro/poze/uc/68877.jpg",@"http://www.infopensiuni.ro/poze/uc/68876.JPG",@"http://www.infopensiuni.ro/poze/uc/68875.JPG"],@"gps":@[@45.365655,@23.254852],@"adresa":@"Str Straja FN",@"localitate":@{@"id":@610,@"idJudet":@33,@"nume":@"Straja"},@"judet":@{@"id":@33,@"nume":@"Hunedoara"},@"urlShare":@"http://www.infopensiuni.ro/cazare-straja/pensiuni-straja/pensiunea-casa-germana",@"persContact":@"Vladislav Liliana",@"telefon":@"0768.735.229",@"email":[NSNull null],@"facilitati":@[],@"descriere":@"Casa Germana este situata la aproximativ 50m de intoarcerea telescaunului si teleschiul 3, pe drumul catre schitul Straja.<br />Va asteptam sa petreceti o vacanta la munte intr-o ambianta de neuitat.<br /><br />Pensiunea dispune de 20 locuri de cazare:<br /><br />-2 camere de 4 loc. Cu baie proprie<br />-2 camere de 2 loc cu baie proprie<br />-1 camera de 2 loc. Cu baie proprie si pat pt. Copii<br />-3 camere matrimoniale cu acces la o singura baie.<br /><br />Toate camerele sunt dotate cu Tv, Internet Wireless.<br /><br />Pensiunea dispune de un restaurant cu o capacitate de 25 locuri unde puteti servi mancaruri dintr-un meniu diversificat la preturi exceptionale.<br /><br />De asemenea se pot organiza mese festive in limita locurilor disponibile.<br /><br />Beneficiati gratuit de urmatoarele servicii :<br /><br />- ghid montan pentru trasee turistice pedestre<br />- tiroliana<br />- alpinism<br />- orientare turistica<br /><br />Va asteptam cu drag.",@"htmlPersonalizat":[NSNull null],@"tarife":@[@{@"idCamera":@21836,@"nume":@"Camera dubla",@"suma":@80,@"moneda":@"RON",@"dataDeLa":@"2014-05-14",@"dataPanaLa":@"2014-05-15",@"nrNopti":@1,@"tip":@"noapte",@"icon":@"2pers"},@{@"idCamera":@19115,@"nume":@"Camera dubla matrimoniala",@"suma":@50,@"moneda":@"RON",@"dataDeLa":@"2014-05-14",@"dataPanaLa":@"2014-05-15",@"nrNopti":@1,@"tip":@"noapte",@"icon":@"2pers"},@{@"idCamera":@19116,@"nume":@"Apartament",@"suma":@120,@"moneda":@"RON",@"dataDeLa":@"2014-05-14",@"dataPanaLa":@"2014-05-15",@"nrNopti":@1,@"tip":@"noapte",@"icon":@"4pers"}],@"comentarii":@[],@"obiective":@[@{@"id":@4487,@"nume":@"Cascada Miralas",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/",@"distanta":@"4 min cu masina"},@{@"id":@6663,@"nume":@"Partie ski Mutu (Slalom Urias) Straja",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/partiamutu.jpg",@"distanta":@"9 min cu masina"},@{@"id":@6667,@"nume":@"Partie ski Sf. Gheorghe Straja",@"urlFoto":@"http://www.infopensiuni.ro/poze/obiective/thumbs/harta_partiistraja.jpg",@"distanta":@"9 min cu masina"}]}}[@"results"];
    
    //ComNSLog(@"back string");
    [backLabel setText:[NSString stringWithFormat:@" %@",backString]];
    if([backString isEqualToString:@"Harta"]){
        [backView setHidden:YES];
    }
    else{
        [mapButton setHidden:YES];
        //[backFromMapView setHidden:YES];
    }
    
//    facilitiesArray = [[NSMutableArray alloc] initWithArray:@[@{@"titlu":@"Activitati", @"image":@"activitati-icon", @"descriere":@"", @"type":@"activitati"},@{@"titlu":@"Mancaruri si bauturi", @"image":@"food-icon", @"descriere":@"", @"type":@"food"},@{@"titlu":@"Internet", @"image":@"internet", @"descriere":@"", @"type":@"internet"},@{@"titlu":@"Parcare", @"image":@"parking-icon", @"descriere":@"", @"type":@"parcare"},@{@"titlu":@"Servicii", @"image":@"servicii-icon", @"descriere":@"", @"type":@"servicii"},@{@"titlu":@"General", @"image":@"general-icon", @"descriere":@"", @"type":@"general"}]];    //myJson[@"facilitati"];*/
    
    [mainScrollView setBounces:YES];
    //facilitiesArray =[[NSMutableArray alloc] initWithArray:myJson[@"facilitati"]];
    
    thisPensionFacilitiesArray = myJson[@"facilitati"];
    
    
    //ComNSLog(@"facilities array:   %@",thisPensionFacilitiesArray);
//    NSMutableArray * types = [[NSMutableArray alloc] init];
//    
//    for(int i=0; i< [thisPensionFacilitiesArray count]; i++){
//        [types addObject:thisPensionFacilitiesArray[i][@"titlu"]];
//    }
//    
//    
//    for(int i= 0 ; i< [facilitiesArray count]; i++){
//        if([types containsObject:facilitiesArray[i][@"titlu"]]){
//            NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:facilitiesArray[i]];
//            [dict setValue:thisPensionFacilitiesArray[[types indexOfObject:facilitiesArray[i][@"titlu"]]][@"text"] forKey:@"descriere"];
//            
//            facilitiesArray[i] = dict;
//        }
//    }
    
    //ComNSLog(@"facilities array---%@",facilitiesArray);
    
    //ComNSLog(@"%s",__func__);
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    
    
    
    //ComNSLog(@"expanded height---%@",expandedCellHeight);
  
    [photoViewer setDelegate:self];
    NSMutableArray * imagesURL;
    imagesURL = [[NSMutableArray alloc] init];
    
    for(int i=0; i< [myJson[@"fotos"] count]; i++){
        NSURL * mURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",myJson[@"fotos"][i]]];
        //ComNSLog(@"mURL---%@",mURL);
        if(mURL != nil && [mURL class] != [NSNull class]){
            [imagesURL addObject:mURL];
        }
    }
    
    [photoViewer setImagesUrls:imagesURL];
    [photoViewer setInitialPage:0];
    
    [self sizePageControlIndicatorsToFit];
}

-(int)numberOfImages
{
    return [photoViewer.imagesUrls count];
}


-(UIImageView *)imageViewForPage:(int)page
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dark_blue.jpg"]];
//    [imgView setContentMode:UIViewContentModeScaleAspectFill];
//    imgView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);
//    
    dispatch_queue_t downloadQueue = dispatch_queue_create("iamge downloader", NULL);
    
    dispatch_async(downloadQueue, ^{
        NSData *imgData = [NSData dataWithContentsOfURL:[photoViewer.imagesUrls objectAtIndex:page]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imgView.image = [UIImage imageWithData:imgData];
        });
    });
    return imgView;
}

-(void)viewWillAppear:(BOOL)animated{
    
    //ComNSLog(@"view will appear");
    

    [mainScrollView setScrollsToTop:YES];
    [dropDownScrollView setScrollsToTop:NO];
    [dropDownTableView setScrollsToTop:NO];
    [feesTableView setScrollsToTop:NO];
    [facilitiesTableView setScrollsToTop:NO];
    [locationsTableView setScrollsToTop:NO];
    
    
    
    [feesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [facilitiesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [locationsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [dropDownTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    
    
//    [todayOfferSep setFrame:CGRectMake(todayOfferSep.frame.origin.x, todayOfferSep.frame.origin.y + 0.5, todayOfferSep.frame.size.width, 0.5)];
//    [toVisitSep setFrame:CGRectMake(toVisitSep.frame.origin.x, toVisitSep.frame.origin.y + 0.5, toVisitSep.frame.size.width, 0.5)];
//    [facilitiesSep setFrame:CGRectMake(facilitiesSep.frame.origin.x, facilitiesSep.frame.origin.y+0.5, facilitiesSep.frame.size.width, 0.5)];
    
//    [todayOfferSep setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
//    [toVisitSep setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
//    [facilitiesSep setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
//    [cell.sepFacilities setFrame:CGRectMake(0, cell.contentView.frame.size.height -0.5, cell.contentView.frame.size.width, 0.5)];
    self.navigationController.navigationBar.hidden = YES;
    //adauga stele

    descriptionHeightForRow = [[NSMutableArray alloc] init];
    expandedCellHeight = [[NSMutableArray alloc] init];
    
  
    [greenBorder setBackgroundColor:UIColorFromRGB(0x94af39)];
    
    
    viewerPortraitFrame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 230);
    viewerLandscapeFrame = CGRectMake(0, photoViewer.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width -headerView.frame.size.height-20);
    
    //ComNSLog(@"viewer portrait:   %@", NSStringFromCGRect(viewerPortraitFrame));
    //ComNSLog(@"viewer landscape:   %@", NSStringFromCGRect(viewerLandscapeFrame));
    
    mainScrollViewPortraitFrame = mainScrollView.frame;
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
//        [mainScrollView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
        [photoViewer setFrame:viewerLandscapeFrame];
        [mainScrollView setContentOffset:CGPointZero animated:NO];
//        [mainScrollView setScrollEnabled:NO];
       // [mainScrollView bringSubviewToFront:photoViewer];
    }
    else{
        [photoViewer setFrame:viewerPortraitFrame];
        [mainScrollView setScrollEnabled:YES];
    }
    
   [photoViewer.greenBorder setFrame: CGRectMake(0, CGRectGetMaxY(photoViewer.frame)-1, photoViewer.frame.size.width, 1)];
    
    [self addStarsWithInt:[myJson[@"categorie"] intValue]];
    
    [mainScrollView addSubview:feesView];
    feesArray = myJson[@"tarife"];
    
    [seeComentsParentView setBackgroundColor:UIColorFromRGB(0xebf3d0)];
    
    [seeComentsLabel setTextColor:UIColorFromRGB(0xafcf45)];
    [seeComentsLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    
    [feesView setFrame:CGRectMake(0, CGRectGetMaxY(photoViewer.frame), self.view.bounds.size.width, 150)];
    
    [feesTableView setFrame:CGRectMake(0, feesTableView.frame.origin.y, feesView.frame.size.width, 49*[feesArray count])];
    
    
    UIView * feesSepView = [[UIView alloc] initWithFrame:CGRectMake(feesTableView.frame.origin.x,feesTableView.frame.origin.y -0.5, feesTableView.frame.size.width,0.5)];
    [feesSepView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    [feesView addSubview:feesSepView];
    [feesView bringSubviewToFront:feesSepView];
    
    feesSepView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    //    [feesTableView.layer setBorderWidth:1];
    //    [feesTableView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    [feesTableView setScrollEnabled:NO];
    [feesTableView setNeedsLayout];
    [feesTableView setNeedsDisplay];
    
    int mHeight = feesTableView.frame.size.height + feesTableView.frame.origin.y;
    CGRect tempFrame = feesView.frame;
    tempFrame.size.height = mHeight;
    
    [feesView setFrame:tempFrame];
    
    [pensionTitleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    
    [shareButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [bookingButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
     shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [backLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [mapButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [mapButton setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
 
    [freeRooms setTextColor:UIColorFromRGB(0x666666)];
    [freeRooms setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    
    [facilitiesLabel setTextColor:UIColorFromRGB(0x333333)];
    
    [todayFees setTextColor:UIColorFromRGB(0x333333)];
    
    [todayFees setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    [locationsLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    [facilitiesLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    
    [changeDateButton setTitleColor:UIColorFromRGB(0x06a6ea) forState:UIControlStateNormal ];
    [changeDateButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:13.0f]];
     //ComNSLog(@"expanded paths ---%@", expandedPaths);
           //bannerColor = [UIColor colorWithRed:230 green:240 blue:200 alpha:1];
    

    
    

}

- (CGSize)text:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
//    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
//    {
//        CGRect frame = [text boundingRectWithSize:size
//                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
//                                       attributes:@{NSFontAttributeName:font}
//                                          context:nil];
//        return frame.size;
//    }
//    else
//    {
        return [text sizeWithFont:font constrainedToSize:size];
   // }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
//        [mainScrollView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
//        [photoViewer setFrame:CGRectMake(0,photoViewer.frame.origin.y, [[UIScreen mainScreen] bounds].size.height,photoViewer.frame.size.height)];
        [photoViewer setFrame:viewerLandscapeFrame];
        [mainScrollView setContentOffset:CGPointZero animated:NO];
        
        //ComNSLog(@"phot viewer---%@",NSStringFromCGRect(photoViewer.frame));
        //ComNSLog(@"tarife---%@", NSStringFromCGRect(feesView.frame));
//        [mainScrollView setScrollEnabled:NO];
        
        //[mainScrollView bringSubviewToFront:photoViewer];
     [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, CGRectGetMaxY(locationsView.frame))];
        
        [self changeYs];
        int xPos, yPos;
        xPos = 20;//(self.view.bounds.size.width - 250) /2;
        yPos = ([[UIScreen mainScreen] bounds].size.width - dropDownView.frame.size.height) /2;
        
        [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
        
        [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableView.frame.size.height + dropDownTableView.frame.origin.y)];
        
        //ComNSLog(@"drop down frame  ---- %@", NSStringFromCGRect(dropDownView.frame));
        
    }
    else{
        [mainScrollView setScrollEnabled:YES];
//        [mainScrollView setFrame:mainScrollViewPortraitFrame];
        [photoViewer setFrame:viewerPortraitFrame];
        
//        [mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(locationsView.frame))];
        
        
//        CGRect scrollViewFrame = mainScrollView.frame;
//        scrollViewFrame.size.height = self.view.frame.size.height;
//        [mainScrollView setFrame:scrollViewFrame];
        
        //ComNSLog(@"phot viewer---%@",NSStringFromCGRect(photoViewer.frame));
        //ComNSLog(@"tarife---%@", NSStringFromCGRect(feesView.frame));
        
        
        
        int xPos, yPos;
        xPos = 20;//(self.view.bounds.size.width - 250) /2;
        yPos = ([[UIScreen mainScreen] bounds].size.height - dropDownView.frame.size.height) /2;
        
        [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
        
        [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableView.frame.size.height + dropDownTableView.frame.origin.y)];
        
        [self changeYs];
        //ComNSLog(@"drop down frame  ---- %@", NSStringFromCGRect(dropDownView.frame));
        
    }
}

-(void)changeYs{
    [feesView setFrame:CGRectMake(feesView.frame.origin.x, CGRectGetMaxY(photoViewer.frame),feesView.frame.size.width , feesView.frame.size.height)];
    [bookingView setFrame:CGRectMake(bookingView.frame.origin.x, CGRectGetMaxY(feesView.frame),bookingView.frame.size.width , bookingView.frame.size.height)];
    [facilitiesView setFrame:CGRectMake(facilitiesView.frame.origin.x, CGRectGetMaxY(bookingView.frame),facilitiesView.frame.size.width , facilitiesView.frame.size.height)];
    
    [seeComments setFrame:CGRectMake(seeComments.frame.origin.x, CGRectGetMaxY(facilitiesView.frame),seeComments.frame.size.width , seeComments.frame.size.height)];
    [locationsView setFrame:CGRectMake(locationsView .frame.origin.x, CGRectGetMaxY(seeComments.frame),locationsView .frame.size.width , locationsView .frame.size.height)];
    [photoViewer.greenBorder setFrame: CGRectMake(0, CGRectGetMaxY(photoViewer.frame)-1, photoViewer.frame.size.width, 1)];
    //ComNSLog(@"phot viewer---%@", NSStringFromCGRect(photoViewer.greenBorder.frame));
    [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY(locationsView.frame))];
}

-(void)viewDidAppear:(BOOL)animated{
    
    //ComNSLog(@"%s",__func__);
    [super viewDidAppear:animated];
    //    if(once==YES){
    //        once=NO;
    //        [self playMovie];
    //    }
    
    
    //ComNSLog(@"view did appear");
    
    //ComNSLog(@"expanded paths ---%@", expandedPaths);
    
    
    FacilitiesTableViewCell * cell;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FacilitiesTableViewCell" owner:nil options:nil];
    for (id currentObject in topLevelObjects){
        if ([currentObject isKindOfClass:[UITableViewCell class]]){
            cell =  (FacilitiesTableViewCell *) currentObject;
            break;
        }
    }
    
    for (int i=0; i<[thisPensionFacilitiesArray count]; i++) {
        CGFloat descriptionContentHeight = [self sizeOfText:[NSString stringWithFormat:@"%@\n",thisPensionFacilitiesArray[i][@"text"]] widthOfTextView:cell.descriptionTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
        //ComNSLog(@"width of text view: %f",cell.descriptionTextView.frame.size.width);
        CGSize temp = [self text:thisPensionFacilitiesArray[i][@"text"] sizeWithFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f] constrainedToSize:CGSizeMake(cell.descriptionTextView.frame.size.width, FLT_MAX)];
        descriptionContentHeight = temp.height;
        //ComNSLog(@"descr cont:   %f",descriptionContentHeight);
        [expandedCellHeight setObject:[NSNumber numberWithFloat:descriptionContentHeight -cell.descriptionTextView.frame.size.height + cell.frame.size.height ] atIndexedSubscript:i];
        
        
        [descriptionHeightForRow setObject:[NSNumber numberWithFloat:descriptionContentHeight + cell.descriptionTextView.frame.origin.y+ cell.descriptionTextView.frame.origin.y - CGRectGetMaxY(cell.label.frame)]  atIndexedSubscript:i];
    }
    
    
    //ComNSLog(@"description height:    %@",descriptionHeightForRow);
    
    // Create REActivityViewController controller and assign data source
    //
   

    //[EcranPensiune setAutomaticallyAdjustsScrollViewInsets:YES];

    controller = [[DataMasterProcessor alloc] init];
    
    expandedPaths = [[NSMutableArray alloc] init];
    
    
    
    
    self.navigationController.navigationBar.hidden = YES;
    
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
    //[photoScrollView setDelegate:self];
    
    [pensionTitleLabel setText:myJson[@"nume"]];
    
    //intializeaza slider
    //[self initSliderWithInt:[myJson[@"fotos"] count]];
    
    
    
    //adauga poze in scroll view
//    [photoScrollView setShowsVerticalScrollIndicator:NO];
//    [photoScrollView setShowsHorizontalScrollIndicator:NO];
//    
//    [self loadScrollViewWithArray:myJson[@"fotos"]];
    
    //adauga tabel tarife
    
    
    //feesArray = @[@{@"type":@"Single",@"fee":@"89 Lei"},@{@"type":@"Double",@"fee":@"99 Lei"},@{@"type":@"Triple",@"fee":@"139 Lei"}];
    

    
    
    
   // [changeDateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    
    
    // partea de rezervare
    
    [mainScrollView addSubview:bookingView];
    [mainScrollView bringSubviewToFront:bookingView];
    
    CGRect bookFrame = bookingView.frame;
    bookFrame.origin.y = feesView.frame.origin.y + feesView.frame.size.height;
    bookFrame.size.width = self.view.bounds.size.width;
    [bookingView setFrame:bookFrame];
    [bookingButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    block = YES;
    
    NSString *infoString=myJson[@"adresa"];
    
    
    infoString = [infoString stringByAppendingFormat:@" (harta)"];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans-Light" size:17.5f] forKey:NSFontAttributeName];
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:infoString];
    [string addAttributes:attrsDictionary range:NSMakeRange(0, infoString.length)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666)
                   range:NSMakeRange(0,infoString.length)];
    [string addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x06a6ea) range:NSMakeRange(infoString.length -6,5 )];
    
    
    [adressTextView setAttributedText:string];
    
    [adressTextView setEditable:NO];
    
    UITapGestureRecognizer * adrRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMap:)];
    [adressTextView addGestureRecognizer:adrRecognizer];
    
    [adressTextView setScrollEnabled:NO];
    
    CGFloat descriptionContentHeight = [self sizeOfText:[NSString stringWithFormat:@"%@\n",infoString] widthOfTextView:adressTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]].height;
    
    //ComNSLog(@"description content height:   %f",descriptionContentHeight);
    //ComNSLog(@"address text view:   %f",adressTextView.frame.size.height);
    
    CGRect adrRect = adressTextView.frame;
    adrRect.size.height = descriptionContentHeight + 10;
    
    [adressTextView setFrame:adrRect];
    
    [callButton setFrame:CGRectMake(callButton.frame.origin.x, CGRectGetMaxY(adressTextView.frame) + 20, callButton.frame.size.width, callButton.frame.size.height)];
    
    [emailButton setFrame:CGRectMake(emailButton.frame.origin.x, CGRectGetMaxY(adressTextView.frame) + 20, emailButton.frame.size.width, emailButton.frame.size.height)];
    
    [bookingView setFrame:CGRectMake(bookingView.frame.origin.x, bookingView.frame.origin.y, bookingView.frame.size.width, CGRectGetMaxY(emailButton.frame) + 20)];
    
    
    
    
    //ComNSLog(@"email, phone %@,%@", myJson[@"email"], myJson[@"telefon"]);
    NSString * email = myJson[@"email"];
    NSString * phone = myJson[@"telefon"];
    bool emailNull = (email == nil || [email class] == [NSNull class]);
    bool phoneNull = (phone == nil || [phone class] == [NSNull class]);
    
    if( emailNull && phoneNull){
        [emailButton setHidden:YES];
        [callButton setHidden:YES];
        
        [bookingView setFrame:CGRectMake(bookingView.frame.origin.x, bookingView.frame.origin.y, bookingView.frame.size.width, emailButton.frame.origin.y)];
        
    }
    else{
        int mXPos = (self.view.bounds.size.width - callButton.frame.size.width) /2;
        if(emailNull){
            [callButton setFrame:CGRectMake(mXPos, callButton.frame.origin.y, callButton.frame.size.width, callButton.frame.size.height)];
            [emailButton setHidden:YES];
        }
        else{
            if(phoneNull){
                [emailButton setFrame:CGRectMake(mXPos, emailButton.frame.origin.y, emailButton.frame.size.width, emailButton.frame.size.height)];
                [callButton setHidden:YES];
            }
        }
    }
    
    
    //!!! de tinut cont si de content size
    
    //[adressTextView setText:myJson[@"adresa"]];
    // !!!! de testat pt ios 4
//    NSString * temp =[NSString stringWithFormat:@"%@ (<span style='color:blue'>harta</span>)",myJson[@"adresa"]];
//    [adressWebView loadHTMLString:temp baseURL:nil];
//    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:[temp stringByAppendingFormat:@" (harta)"]];
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,temp.length)];
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(temp.length + 1, 7)];
//
//    [adressTextView setAttributedText:string ];
    
    // facilitati
    
   
    
    
    
    [mainScrollView addSubview:facilitiesView];
    CGRect facilitiesFrame = facilitiesView.frame;
    facilitiesFrame.origin.y = bookingView.frame.origin.y + bookingView.frame.size.height;
    facilitiesFrame.size.width = self.view.bounds.size.width;
    [facilitiesView setFrame:facilitiesFrame];

    
    
    [facilitiesTableView setFrame:CGRectMake(0, facilitiesTableView.frame.origin.y, facilitiesView.frame.size.width, 49*[thisPensionFacilitiesArray count])];
    
    [facilitiesTableView setScrollEnabled:NO];
    [facilitiesTableView setNeedsLayout];
    [facilitiesTableView setNeedsDisplay];
    
    int mHeightFacilities = facilitiesTableView.frame.size.height + facilitiesTableView.frame.origin.y;
    CGRect tempFrameFacilities = facilitiesView.frame;
    tempFrameFacilities.size.height = mHeightFacilities;
    [facilitiesView setFrame:tempFrameFacilities];
    
    UIView * facilitySeparator = [[UIView alloc] initWithFrame:CGRectMake(facilitiesTableView.frame.origin.x,facilitiesTableView.frame.origin.y + 0.5, facilitiesTableView.frame.size.width, 0.5)];
    [facilitySeparator setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    
    facilitySeparator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [facilitiesView addSubview:facilitySeparator];
    [facilitiesView bringSubviewToFront:facilitiesView];
    
    //ComNSLog(@"facilities frame:   %@", NSStringFromCGRect(facilitiesView.frame));
    //ComNSLog(@"facilities table view:   %@", NSStringFromCGRect(facilitiesTableView.frame));
    
    [mainScrollView bringSubviewToFront:facilitiesView];

    
    
    // adaugare dropDown
    dropDownOptions= @[@"0 camere",@"1 camera",@"2 camere",@"3 camere",@"4 camere",@"5 camere",@"6 camere",@"7 camere",@"8 camere",@"9 camere",@"10 camere"];
    

    
    [self.view addSubview:dropDownView];
    
    [dropDownTableView setFrame:CGRectMake(dropDownTableView.frame.origin.x,dropDownTableView.frame.origin.y , dropDownTableView.frame.size.width, 49 * [dropDownOptions count] + dropDownTableView.frame.origin.y)];

    
    int xPos, yPos;
    xPos = 20;//(self.view.bounds.size.width - 250) /2;
    yPos = (self.view.bounds.size.height - dropDownView.frame.size.height) /2;
    
    [dropDownView setFrame:CGRectMake(xPos, yPos, self.view.bounds.size.width -40, dropDownView.frame.size.height)];
    
    [dropDownScrollView setContentSize:CGSizeMake(dropDownView.frame.size.width, dropDownTableView.frame.size.height + dropDownTableView.frame.origin.y)];
    
    [hideView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    
    
    [hideView setHidden:YES];
    [dropDownView setHidden:YES];
    
    [mainScrollView bringSubviewToFront:hideView];
    
    //ComNSLog(@"dropDownView frame---%@",NSStringFromCGRect(dropDownView.frame));
    //ComNSLog(@"dropDownTableView frame---%@",NSStringFromCGRect(dropDownTableView.frame));
    
    
    // adauga vizualizare comentarii
    
    CGRect seeComentsFrame = seeComments.frame;
    seeComentsFrame.origin.y = facilitiesView.frame.origin.y + facilitiesView.frame.size.height;
    seeComentsFrame.size.width = self.view.bounds.size.width;
    
    [seeComments setBackgroundColor:[UIColor colorWithRed:235 green:243 blue:208 alpha:1]];
    [seeComments setFrame:seeComentsFrame];
    
    //ComNSLog(@"facilities frame:   %@", NSStringFromCGRect(facilitiesView.frame));
    //ComNSLog(@"see coments frame:  %@", NSStringFromCGRect(seeComments.frame));
    //ComNSLog(@"facilities table view:   %@", NSStringFromCGRect(facilitiesTableView.frame));
    
    NSArray * commentsArray = myJson[@"comentarii"];
    //ComNSLog(@"commentarii----%@", commentsArray);
    if([commentsArray count] == 0){
        [seeComentsLabel setText:[NSString stringWithFormat:@"Comentarii"]];
    }
    else{
        [seeComentsLabel setText:[NSString stringWithFormat:@"Vezi comentarii (%d)",[commentsArray count]]];
    }
    
    
    
    UITapGestureRecognizer * commentRecogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeComments:)];
    [seeComments addGestureRecognizer:commentRecogn];
    
    
    
    [mainScrollView addSubview:seeComments];
    // adauga locations
    
    locationsArray = myJson[@"obiective"];
    [mainScrollView addSubview:locationsView];
    
    CGRect locationViewFrame = locationsView.frame;
    locationViewFrame.size.width = self.view.bounds.size.width;
    locationViewFrame.origin.y = seeComments.frame.origin.y + seeComments.frame.size.height;
    [locationsView setFrame:locationViewFrame];
    
    [locationsTableView setFrame:CGRectMake(0, locationsTableView.frame.origin.y, locationsView.frame.size.width, 95*[locationsArray count])];
    
    [locationsTableView setScrollEnabled:NO];
    [locationsTableView setNeedsLayout];
    [locationsTableView setNeedsDisplay];
    
    int mHeightLoc = CGRectGetMaxY(locationsTableView.frame);
    CGRect tempFrameLoc = locationsView.frame;
    tempFrameLoc.size.height = mHeightLoc;
    [locationsView setFrame:tempFrameLoc];
    
//    UIView * locationSeparator = [[UIView alloc] initWithFrame:CGRectMake(locationsTableView.frame.origin.x,locationsTableView.frame.origin.y + 0.5, locationsTableView.frame.size.width, 0.5)];
//    [locationSeparator setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
//    
//     locationSeparator.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
//    [locationsView addSubview:locationSeparator];
//    [locationsView bringSubviewToFront:locationsView];
    
    
    //ComNSLog(@"location height---%@",NSStringFromCGRect(locationsView.frame));
    
    [mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(locationsView.frame))];
    
    //ComNSLog(@"mainscrollview contentsize---%@", NSStringFromCGSize(mainScrollView.contentSize));
    //ComNSLog(@"location table rect---%@",NSStringFromCGRect(locationsTableView.frame));
    
    
//    CGRect scrollViewFrame = mainScrollView.frame;
//    scrollViewFrame.size.height = self.view.frame.size.height;
//    [mainScrollView setFrame:scrollViewFrame];

    //[mainScrollView bringSubviewToFront:photoViewer];
    
//    self.view.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:243.0f/255.0f blue:208.0f/255.0f alpha:1];
  
//    UIFont *Myfont = [UIFont fontWithName:@"GillSans-Italic" size:17]; //PTS56F.ttf PT Sans 72 74 67
    
    UITapGestureRecognizer * recogn = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDropDown:)];
    recogn.numberOfTapsRequired = 1;
    [hideView addGestureRecognizer:recogn];
    
    [facilitiesTableView reloadData];
    
    

    
    dispatch_async(dispatch_get_main_queue(), ^{
        //ComNSLog(@"eii macarena");
    });
    
    //ComNSLog(@"today offer frame:    %@", NSStringFromCGRect(todayOfferSep.frame));
    //ComNSLog(@"to visit sep:    %@", NSStringFromCGRect(toVisitSep.frame));
    //ComNSLog(@"facilities sep frame:    %@", NSStringFromCGRect(facilitiesSep.frame));
    
}

-(void)hideDropDown:(UITapGestureRecognizer *)recogn{
    [dropDownView setHidden:YES];
    [hideView setHidden:YES];
}



// dupa ce s-a incarcat adresa
//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    if(webView == adressWebView){
//        NSString *padding = @"document.body.style.margin='0';document.body.style.padding = '0'";
//        [webView stringByEvaluatingJavaScriptFromString:padding];
//        [webView.scrollView setScrollEnabled:NO];
//        UITapGestureRecognizer * webRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushMap:)];
//        [webRecognizer setDelegate:self];
//        [webView addGestureRecognizer:webRecognizer];
//    }
//
//}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)pushMap:(UITapGestureRecognizer *)recognizer{
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mesaj" message:@"Aici se va face push la ecranul cu harta" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
    
    
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
        ecrLocVC.dinceEcranvine =@"pensiune";
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
             ecrLocVC.dinceEcranvine =@"pensiune";
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
             ecrLocVC.dinceEcranvine =@"pensiune";
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


//page data source

-(int)numberOfPages{
    return [myJson[@"fotos"] count];
}

- (UIImage *)imageAtIndex:(int)index {
	return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",myJson[@"fotos"][index]]]]];
}


//-(void)scrollTheViewsWithValue:(int)val{
//    
//    float webViewHeight = 0.0;
//    
//    if( [adressWebView respondsToSelector:@selector(scrollView)] ) {
//        UIScrollView *sv =  [adressWebView performSelector:@selector(scrollView)];
//        [sv setDecelerationRate:UIScrollViewDecelerationRateNormal ];
//        webViewHeight = sv.contentSize.height;
//    }
//    else
//    {
//        
//        for( UIScrollView *view in [adressWebView subviews] ) {
//            if( [view isKindOfClass:[UIScrollView class]] ) {
//                [view setDecelerationRate:UIScrollViewDecelerationRateNormal];//0.998000
//                webViewHeight = view.contentSize.height;
//            }
//        }
//    }
//
//    
//    //ComNSLog(@"adress height---%f", webViewHeight);
//}


// programare tableview-uri

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(tableView == feesTableView){
        static NSString *CellIdentifier = @"FeeTableViewCell";
        FeeTableViewCell *cell = (FeeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FeeTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (FeeTableViewCell *) currentObject;
                    break;
                }
            }
        }
        
        [cell.iconView setImage:[UIImage imageNamed:room_icons[feesArray[indexPath.row][@"icon"]]]];
        
        [cell.roomPriceLabel setText:[NSString stringWithFormat:@"%@ %@",feesArray[indexPath.row][@"suma"], feesArray[indexPath.row][@"moneda"]]];
        [cell.roomPriceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
        
        [cell.roomPriceLabel setTextColor:UIColorFromRGB(0x666666)];

        
        [cell.numberOfRoomsLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
        [cell.numberOfRoomsLabel setTextColor:UIColorFromRGB(0x666666)];
        [cell.numberOfRoomsView setTag:indexPath.row];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else{
        
        if(tableView == facilitiesTableView){
            //ComNSLog(@"cell for row facilities");
            static NSString *CellIdentifier = @"FacilitiesTableViewCell";
            FacilitiesTableViewCell *cell = (FacilitiesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FacilitiesTableViewCell" owner:nil options:nil];
                for (id currentObject in topLevelObjects){
                    if ([currentObject isKindOfClass:[UITableViewCell class]]){
                        cell =  (FacilitiesTableViewCell *) currentObject;
                        break;
                    }
                }
            }
            
            [cell.label setText:thisPensionFacilitiesArray[indexPath.row][@"titlu"]];
            [cell.label setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
            
            [cell.label setTextColor:UIColorFromRGB(0x666666)];
            
//            NSString * str = [[NSString alloc ] initWithFormat:@"ic_of_%@",thisPensionFacilitiesArray[indexPath.row][@"type"]] ;
            
//            [cell.icon setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:facilitiesArray[indexPath.row][@"image"] ofType:@"png"]]];
            
//            [cell.icon setImage:[UIImage imageNamed:str]];
//            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
NSString *urlStr = [NSString stringWithFormat:@"%@",thisPensionFacilitiesArray[indexPath.row][@"icon"]];
            NSDictionary *tempJ =thisPensionFacilitiesArray[indexPath.row];
              //ComNSLog(@"tempJ  %@", tempJ);
           //ComNSLog(@"tempJ  icon %@", [tempJ objectForKey:@"icon"]);
            
//            {
//                icon = "http://www.infopensiuni.ro/img/facilitati/activitati.png";
//                text = "Jocuri de societate";
//                titlu = Activitati;
//                type = activitati;
//            }
            //ComNSLog(@"poza facilitati %@", urlStr);
         
//           [controller downloadImageWithURL:[NSURL URLWithString:urlStr] completionBlock:^(BOOL succeeded, UIImage *image) {
//               if (succeeded) {
//                   [cell.icon setImage:image];
//                }
//           }];
//             [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
//            [cell.icon setImage:[UIImage  imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:facilitiesArray[indexPath.row][@"image"] ofType:@"png"]]];
            
            NSString * str = [[NSString alloc ] initWithFormat:@"ic_of_%@",thisPensionFacilitiesArray[indexPath.row][@"type"]] ;
            
            //            [cell.icon setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:facilitiesArray[indexPath.row][@"image"] ofType:@"png"]]];
            
            [cell.icon setImage:[UIImage imageNamed:str]];
            [cell.icon setContentMode:UIViewContentModeScaleAspectFit];
            
            
            [cell.descriptionTextView setText:thisPensionFacilitiesArray[indexPath.row][@"text"] ];
            [cell.descriptionTextView setTextColor:UIColorFromRGB(0x999999)];
            [cell.descriptionTextView setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
            
            
            
//
//           CGFloat descriptionContentHeight = [self sizeOfText:[NSString stringWithFormat:@"%@\n",cell.descriptionTextView.text] widthOfTextView:cell.descriptionTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]].height;
//
//            
//            [descriptionHeightForRow setObject:[NSNumber numberWithFloat:descriptionContentHeight + cell.descriptionTextView.frame.origin.y]  atIndexedSubscript:indexPath.row];
//            CGFloat descriptionContentHeight;
//            //ComNSLog(@"description height---%d,%d",[descriptionHeightForRow count], indexPath.row);
//            if([descriptionHeightForRow count] == indexPath.row){
//               descriptionContentHeight = [self sizeOfText:[NSString stringWithFormat:@"%@\n",cell.descriptionTextView.text] widthOfTextView:cell.descriptionTextView.frame.size.width withFont:[UIFont systemFontOfSize:14]].height;
//                
//                
//                [descriptionHeightForRow setObject:[NSNumber numberWithFloat:descriptionContentHeight + cell.descriptionTextView.frame.origin.y]  atIndexedSubscript:indexPath.row];
//
//            }
//            else{
//               descriptionContentHeight = [descriptionHeightForRow[indexPath.row] floatValue];
//            }
//
            
            CGFloat descriptionContentHeight = [descriptionHeightForRow[indexPath.row] floatValue];
            
            cell.descriptionTextView.contentInset = UIEdgeInsetsMake(-8,0,0,0);
            [cell.descriptionTextView setUserInteractionEnabled:NO];
            [cell.descriptionTextView setFrame:CGRectMake(cell.descriptionTextView.frame.origin.x,cell.descriptionTextView.frame.origin.y , cell.descriptionTextView.frame.size.width, descriptionContentHeight)];
        

            
            UIView * sepFacilities;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if ([expandedPaths containsObject:indexPath]) {
                //ComNSLog(@"e in expanded");
                [cell.descriptionTextView setHidden:NO];
                [cell.next setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sageata-sus" ofType:@"png"]]];
////                [cell.sepFacilities setFrame:CGRectMake(0, descriptionContentHeight-0.5, cell.contentView.frame.size.width, 0.5)];
//                //ComNSLog(@"cell sep fac %@",NSStringFromCGRect(cell.sepFacilities.frame));
//                //ComNSLog(@"cell frame   %@", NSStringFromCGRect(cell.frame));
                for(UIView * mView in cell.contentView.subviews){
                    if(mView.tag == 666){
                        [mView removeFromSuperview];
                    }
                }
                sepFacilities = [[UIView alloc] initWithFrame:CGRectMake(0, descriptionContentHeight-0.5, cell.contentView.frame.size.width, 0.5f)];
                [sepFacilities setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
                [sepFacilities setTag:666];
                
                sepFacilities.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                [cell.contentView addSubview:sepFacilities];
                //ComNSLog(@"cell subviews:   %@", cell.contentView.subviews);
            } else {
                //ComNSLog(@"nu e in expanded");
                [cell.descriptionTextView setHidden:YES];
                [cell.next setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sageata-jos" ofType:@"png"]]];
                for(UIView * mView in cell.contentView.subviews){
                    if(mView.tag == 666){
                        [mView removeFromSuperview];
                    }
                }
                sepFacilities = [[UIView alloc] initWithFrame:CGRectMake(0, 49 - 0.5f, cell.contentView.frame.size.width, 0.5f)];
                [sepFacilities setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
                [sepFacilities setTag:666];
                sepFacilities.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                
                [cell.contentView addSubview:sepFacilities];

//                [cell.sepFacilities setFrame:CGRectMake(0, 49 -0.5, cell.contentView.frame.size.width, 0.5)];
//                //ComNSLog(@"cell sep fac %@",NSStringFromCGRect(cell.sepFacilities.frame));
//                //ComNSLog(@"cell frame   %@", NSStringFromCGRect(cell.frame));
                //ComNSLog(@"cell subviews:   %@", cell.subviews);
            }
            
            //ComNSLog(@"label fr:  %@", NSStringFromCGRect(cell.label.frame));
            //ComNSLog(@"descr fr:   %@", NSStringFromCGRect(cell.descriptionTextView.frame));
            //ComNSLog(@"cell fr:   %@", NSStringFromCGRect(cell.frame));
        
            return cell;
        }
        else{
            if(tableView == locationsTableView){
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
                [cell.locationTitle setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
                
                [cell.locationTitle setTextColor:UIColorFromRGB(0x333333)];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@",locationsArray[indexPath.row][@"urlFoto"]];
                
                [controller downloadImageWithURL:[NSURL URLWithString:urlStr] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        [cell.previewPhoto setImage:image];
                    }
                }];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                [cell.distanceLabel setText:locationsArray[indexPath.row][@"distanta"]];
                [cell.distanceLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0f]];
                
                [cell.distanceLabel setTextColor:UIColorFromRGB(0x666666)];
                
                
                return cell;
            }
            else{
                
                static NSString *CellIdentifier = @"DropDownTableViewCell";
                DropDownTableViewCell *cell = (DropDownTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DropDownTableViewCell" owner:nil options:nil];
                    for (id currentObject in topLevelObjects){
                        if ([currentObject isKindOfClass:[UITableViewCell class]]){
                            cell =  (DropDownTableViewCell *) currentObject;
                            break;
                        }
                    }
                }
                
                [cell.noOfRooms setText:dropDownOptions[indexPath.row]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                UIView * separatorView;
                for(UIView * mView in cell.contentView.subviews){
                    if(mView.tag == 666){
                        [mView removeFromSuperview];
                    }
                }
                
                separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,49 - 0.5 ,dropDownTableView.frame.size.width, 0.5)];
                [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
                [separatorView setTag:666];
                 separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
                [cell.contentView addSubview:separatorView];
                
                
                return cell;
            }

        }

    }

}



-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == dropDownTableView){
        DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
        
        for(int i = 0; i< [tableView numberOfRowsInSection:0]; i++){
            if(i != indexPath.row){
                DropDownTableViewCell * cell = (DropDownTableViewCell *) [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
                [cell.checkImage setHidden:YES];
            }
        }
        
        [cell.checkImage setHidden:NO];
        [cell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
        numberOfRooms = indexPath.row;
    
        [self dropDownSelectFunction:feeIndex];
    }
    
    else{
        if(tableView == feesTableView){
            
            [hideView setHidden:NO];
            [dropDownView setHidden:NO];
            FeeTableViewCell * cell = (FeeTableViewCell *)[feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
            NSString * temp = cell.numberOfRoomsLabel.text;
            NSArray * tempArray = [temp componentsSeparatedByString:@" "];
            int number = [tempArray[0] intValue];
            
            DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [dropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:number inSection:0]];
            
            for(int i = 0; i< [dropDownTableView numberOfRowsInSection:0]; i++){
                if(i != number){
                    DropDownTableViewCell * dropCell = (DropDownTableViewCell *) [dropDownTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"check-btn" ofType:@"png"]]];
                    [dropCell.checkImage setHidden:YES];
                }
            }
            [dropCell.checkImage setHidden:NO];
            
            [dropCell.checkImage setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"checked-btn" ofType:@"png"]]];
            
            
            feeIndex = indexPath.row;
        }
        else{
            if(tableView == facilitiesTableView){
                if([thisPensionFacilitiesArray[indexPath.row][@"text"] length] > 0){
                    FacilitiesTableViewCell * cell = (FacilitiesTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                    if([expandedPaths containsObject:indexPath]){
                        [cell.descriptionTextView setHidden:YES];
                        [cell.next setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sageata-sus" ofType:@"png"]]];
                        //ComNSLog(@"scade");
                        CGRect frame = facilitiesView.frame;
                        frame.size.height = frame.size.height - [descriptionHeightForRow[indexPath.row] floatValue] + 49;
                        [facilitiesView setFrame:frame];
                        
                       
                        
                        [facilitiesTableView setFrame:CGRectMake(facilitiesTableView.frame.origin.x, facilitiesTableView.frame.origin.y, facilitiesTableView.frame.size.width, facilitiesTableView.frame.size.height - [descriptionHeightForRow[indexPath.row] floatValue]+ 49)];
                        
                        //ComNSLog(@"cell description frame---%@", NSStringFromCGRect(cell.descriptionTextView.frame));
                        
                        [self moveBottomPagefromIndex:indexPath.row];
                        
                        [expandedPaths removeObject:indexPath];
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [facilitiesSep setFrame:CGRectMake(0, facilitiesTableView.frame.origin.y -0.5, facilitiesSep.frame.size.width, 0.5)];
                        

                        
                    }
                    else{
                        //ComNSLog(@"aduna");
                        [cell.descriptionTextView setHidden:NO];
                        [cell.next setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sageata-jos" ofType:@"png"]]];
                        
                        CGRect frame = facilitiesView.frame;
                        //ComNSLog(@"descriptionHeightForRow---%@", descriptionHeightForRow);
                        frame.size.height = frame.size.height + [descriptionHeightForRow[indexPath.row] floatValue] - 49;
                        [facilitiesView setFrame:frame];
                        
                        [facilitiesTableView setFrame:CGRectMake(facilitiesTableView.frame.origin.x, facilitiesTableView.frame.origin.y, facilitiesTableView.frame.size.width, facilitiesTableView.frame.size.height + [descriptionHeightForRow[indexPath.row] floatValue] - 49)];
                        
                                            //ComNSLog(@"cell description frame---%@", NSStringFromCGRect(cell.descriptionTextView.frame));
                        [self moveBottomPagefromIndex:indexPath.row];
                        
                        [expandedPaths addObject:indexPath];
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        [facilitiesSep setFrame:CGRectMake(0 , facilitiesTableView.frame.origin.y -0.5, facilitiesSep.frame.size.width, 0.5)];
                        

                        
                    }

                }
                
            }
            else{
                if(tableView == locationsTableView){
                    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
                    [internetReach startNotifier];
                    
                    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
                    //ComNSLog(@"netstatus %u", netStatus);
                    switch (netStatus)
                    {
                        case ReachableViaWWAN:
                        {
                            [self pregatesteObiectiv:[NSString stringWithFormat:@"%@",locationsArray[indexPath.row][@"id"]]];
                            break;
                        }
                        case ReachableViaWiFi:
                        {
                            [self pregatesteObiectiv:[NSString stringWithFormat:@"%@",locationsArray[indexPath.row][@"id"]]];
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

//////////////// pregateste ecran obiectiv
-(void) pregatesteObiectiv :(NSString*)obiectivID {
    if(obiectivID) {

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
            //ComNSLog(@"Response obor: %@", responseString);
            
            if([self checkDictionary:REZOLVA_OBIECTIV]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"Va rugam asteptati";
                 [self rezolvaObiectiv:REZOLVA_OBIECTIV];
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
-(void) rezolvaObiectiv:(NSDictionary *)REZOLVA_OBIECTIV {
    if(REZOLVA_OBIECTIV) {
        
//        EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
//        ecranObiectiv.myJson = REZOLVA_OBIECTIV;
//        ecranObiectiv.backString = pensionTitleLabel.text;
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.5;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//        
//        [self presentModalViewController:ecranObiectiv animated:NO];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self prezintaEcranObiectiv:REZOLVA_OBIECTIV];
    }
}


-(void)prezintaEcranObiectiv:(NSDictionary *)REZOLVA_OBIECTIV{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
        ecranObiectiv.myJson = REZOLVA_OBIECTIV;
        ecranObiectiv.backString = pensionTitleLabel.text;
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
            ecranObiectiv.backString = pensionTitleLabel.text;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:ecranObiectiv animated:NO];
        }
        else{
            EcranObiectiveViewController *ecranObiectiv = [[EcranObiectiveViewController alloc] initWithNibName:@"EcranObiectiveViewController" bundle:nil];
            ecranObiectiv.myJson = REZOLVA_OBIECTIV;
            ecranObiectiv.backString = pensionTitleLabel.text;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:ecranObiectiv animated:NO];
        }
        
    }

}

-(void)prezintaEcranRezervare:(NSMutableArray *)roomsSelectionArray{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        EcranRezervareViewController *rzvrVC = [[EcranRezervareViewController alloc] initWithNibName:@"EcranRezervareViewController" bundle:nil];
        rzvrVC.roomsSelectionArray = roomsSelectionArray;
        rzvrVC.myJson = myJson;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self.navigationController pushViewController:rzvrVC animated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            EcranRezervareViewController *rzvrVC = [[EcranRezervareViewController alloc] initWithNibName:@"EcranRezervareViewController" bundle:nil];
            rzvrVC.roomsSelectionArray = roomsSelectionArray;
            rzvrVC.myJson = myJson;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:rzvrVC animated:NO];
        }
        else{
            EcranRezervareViewController *rzvrVC = [[EcranRezervareViewController alloc] initWithNibName:@"EcranRezervareViewController" bundle:nil];
            rzvrVC.roomsSelectionArray = roomsSelectionArray;
            rzvrVC.myJson = myJson;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self.navigationController pushViewController:rzvrVC animated:NO];
        }
        
    }
}

-(void)moveBottomPagefromIndex:(int)index{

       //misca comentarii
    
    
        CGRect seeComentsNewFrame = seeComments.frame;
        seeComentsNewFrame.origin.y = facilitiesView.frame.origin.y + facilitiesView.frame.size.height;
        [seeComments setFrame:seeComentsNewFrame];
    
    
        //misca obiective
        CGRect locationViewNewFrame = locationsView.frame;
        locationViewNewFrame.origin.y = seeComments.frame.origin.y + seeComments.frame.size.height;
        
        [locationsView setFrame:locationViewNewFrame];
        
        
        // mareste/micsoreaza content scroll view
        
        CGSize mainScrollViewContentSize = mainScrollView.contentSize;
         mainScrollViewContentSize.height = CGRectGetMaxY(locationsView.frame);//locationsView.frame.origin.y + locationsView.frame.size.height + 20;
        [mainScrollView setContentSize:mainScrollViewContentSize];
    
}

-(void)dropDownSelectFunction:(int)index{
    [hideView setHidden:YES];
    [dropDownView setHidden:YES];
    FeeTableViewCell * cell = (FeeTableViewCell *)[feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:feeIndex inSection:0]];
    [cell.numberOfRoomsLabel setText:[NSString stringWithFormat:@"%d camere",numberOfRooms]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == feesTableView){
        //ComNSLog(@"fees array---%d",[feesArray count]);
        return  [feesArray count];
    }
    else{
        if(tableView == facilitiesTableView){
            return [thisPensionFacilitiesArray count];
        }
        else{
            if(tableView == locationsTableView){
               return [locationsArray count];
            }
            else{
                return  [dropDownOptions count];
            }
        }
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //ComNSLog(@"height for row");
    if(tableView == locationsTableView){
        return 95;
    }
    else{
        
        if(tableView == feesTableView ){
            return 49;
        }
        else{
            if(tableView == facilitiesTableView){
                if ([expandedPaths containsObject:indexPath]) {
                    return [descriptionHeightForRow[indexPath.row] floatValue];
                } else {
                    return 49;
                }
            }
            else{
                return 49;
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


//add stars
-(void)addStarsWithInt:(int)numberOfStars{
   
    int xPosition, yPosition;
    
//    xPosition = (pensionTitleLabel.frame.origin.x + pensionTitleLabel.frame.size.width) + 10;
    
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        xPosition = [[UIScreen mainScreen] bounds].size.width;
    }
    else{
        xPosition = [[UIScreen mainScreen] bounds].size.height;
    }
    
    
    yPosition = titleView.frame.origin.y + (titleView.frame.size.height - 18) / 2;
    
    
    //ComNSLog(@"starX:%d , starY:%d ",xPosition, yPosition);
    
    if(numberOfStars > 0){
        xPosition = xPosition - 24;
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 21, 18)];
        [starImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star-rating" ofType:@"png"]]];
        starImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        [starImageView setNeedsLayout];
        [starImageView setNeedsDisplay];
        [mainScrollView addSubview:starImageView];
        
        
        for(int i=1; i < numberOfStars; i++){
            xPosition = xPosition - 24;
            
            UIImageView *starImageView= [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, 21, 18)];
            starImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleBottomMargin;
            [starImageView setNeedsLayout];
            [starImageView setNeedsDisplay];
            
            [starImageView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"star-rating" ofType:@"png"]]];
            [mainScrollView addSubview:starImageView];
            [starImageView setNeedsLayout];
            [starImageView setNeedsDisplay];
            
        }
        
    }

    
}






-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int pos = scrollView.contentOffset.x / 320;
    [self changeSliderThumb:pos];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pos = (scrollView.contentOffset.x  + 160) / 320;
    [self changeSliderThumb:pos];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    int pos = (scrollView.contentOffset.x + 160) / 320;
    [self changeSliderThumb:pos];
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


-(void)changeSliderThumb:(int)position{
    
    for(int i=0; i < [[bubleView subviews] count]; i++ ){
        [((UIImageView *)[bubleView subviews][i]) setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider-tumb" ofType:@"png"]]];
    }
    
   [((UIImageView *)[bubleView subviews][position]) setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"slider-thumb-active" ofType:@"png"]]];
}


//call function

-(IBAction)call:(UIButton *)callButton{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",myJson[@"telefon"]]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Device-ul tau nu permite folosirea acestui serviciu" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
    
}

-(IBAction)sendMail:(UIButton *)mailButton{
    
    //!!!trebuie decomentat testul pentru email diferit de null
    
//    if(myJson[@"email"] == nil || [myJson[@"email"] class] == [NSNull class]){
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Aceasta pensiune nu permite folosirea acestui serviciu." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//    else{
        if([MFMailComposeViewController canSendMail]){
             mailVC = [[MFMailComposeViewController alloc] init];
            [mailVC setToRecipients:@[[NSString stringWithFormat:@"%@",myJson[@"email"]]]];
            [mailVC setSubject:@"Sunt interesat de cazare"];
            
            NSDictionary *temp = myJson[@"tarife"][0];
            NSString * dataDeLa, * dataPanaLa;
            dataDeLa = temp[@"dataDeLa"];
            dataPanaLa = temp[@"dataPanaLa"];
            NSArray *deLaArray = [dataDeLa componentsSeparatedByString:@"-"];
            NSArray *panaLaArray = [dataPanaLa componentsSeparatedByString:@"-"];
            NSArray *months =@[@"Ianuarie",@"Februarie",@"Martie",@"Aprilie",@"Mai",@"Iunie",@"Iulie",@"August",@"Septembrie",@"Octombrie",@"Noiembrie",@"Decembrie"];
            [mailVC setMessageBody:[NSString stringWithFormat:@"Buna ziua,\n\nSunt in cautare de cazare in %@ si ma intereseaza %@ %@. Aveti camere libere intre %@ %@ %@ si %@ %@ %@? \n\n Astept un raspuns de la dumneavoastra, va multumesc! \n\n Mesaj trimis prin aplicatia mobila Cazare Romania",myJson[@"localitate"][@"nume"],myJson[@"tip"],myJson[@"nume"],deLaArray[2],months[[deLaArray[1] intValue]],deLaArray[0],panaLaArray[2], months[[panaLaArray[1] intValue] ],panaLaArray[0]] isHTML:NO];
            [mailVC setMailComposeDelegate:self];
            Reachability *internetReach = [Reachability reachabilityForInternetConnection];
            [internetReach startNotifier];
            
            NetworkStatus netStatus = [internetReach currentReachabilityStatus];
            //ComNSLog(@"netstatus %u", netStatus);
            switch (netStatus)
            {
                case ReachableViaWWAN:
                {
                    [self presentViewController:mailVC animated:YES completion:nil];
                    break;
                }
                case ReachableViaWiFi:
                {
                    [self presentViewController:mailVC animated:YES completion:nil];
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
        else{
            UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Atentie" message:@"Device-ul tau nu permite folosirea acestui serviciu" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [notPermitted show];
        }

//    }

    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}





-(void)seeComments:(UITapGestureRecognizer *)recognizer{
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
//            EcranComentariiViewController *ecVC = [[EcranComentariiViewController alloc] initWithNibName:@"EcranComentariiViewController" bundle:nil];
//            ecVC.myJson = myJson;
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            ecVC.myJson = myJson;
//            [self presentModalViewController:ecVC animated:NO];
            [self prezintaEcranComentarii];
            break;
        }
        case ReachableViaWiFi:
        {
//            EcranComentariiViewController *ecVC = [[EcranComentariiViewController alloc] initWithNibName:@"EcranComentariiViewController" bundle:nil];
//            ecVC.myJson = myJson;
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            ecVC.myJson = myJson;
//            [self presentModalViewController:ecVC animated:NO];
            [self prezintaEcranComentarii];
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


-(void)prezintaEcranComentarii{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        EcranComentariiViewController *ecVC = [[EcranComentariiViewController alloc] initWithNibName:@"EcranComentariiViewController" bundle:nil];
        ecVC.myJson = myJson;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        ecVC.myJson = myJson;
        [self.navigationController pushViewController:ecVC animated:NO];
    }
    else{
        if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
            EcranComentariiViewController *ecVC = [[EcranComentariiViewController alloc] initWithNibName:@"EcranComentariiViewController" bundle:nil];
            ecVC.myJson = myJson;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            ecVC.myJson = myJson;
            [self.navigationController pushViewController:ecVC animated:NO];
        }
        else{
            EcranComentariiViewController *ecVC = [[EcranComentariiViewController alloc] initWithNibName:@"EcranComentariiViewController" bundle:nil];
            ecVC.myJson = myJson;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [self.view.window.layer addAnimation:transition forKey:nil];
            ecVC.myJson = myJson;
            [self.navigationController pushViewController:ecVC animated:NO];
        }
        
    }

}

-(IBAction)shareACTION:(id)sender{
//
    
    //ComNSLog(@"face share");
    //NSURL *url = [NSURL URLWithString:[self.myJson objectForKey:@"urlShare"]];
//    
//    NSString *urltitle = [NSString stringWithFormat:@"%@",[self.myJson objectForKey:@"nume"]];
//    SHKItem *item = [SHKItem URL:url title:urltitle contentType:SHKURLContentTypeWebpage];
////    [item setURLDescription:];
//
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * name = [defaults objectForKey:@"Nume.Cazare.ro"];
    //ComNSLog(@"name---%@",name);
    NSString * string4;
    if(name.length >0){
        string4 = [NSString stringWithFormat:@"Apasa pe linkul de mai jos:\n%@\n\nCu sinceritate,\n%@",[self.myJson objectForKey:@"urlShare"],name];
    }
    else{
        string4 = [NSString stringWithFormat:@"Apasa pe linkul de mai jos:\n%@\n\nCu sinceritate,\n",[self.myJson objectForKey:@"urlShare"]];
    }
    NSString * string1 = [NSString stringWithFormat:@"Salutare,\n\n"];
    NSString * string2 = @"Cred ca te-ar interesa ";
    NSString * string3 = @" din ";
    
    NSString * tip = [NSString stringWithFormat:@"%@ ",self.myJson[@"tip"]];
    NSString * nume = [NSString stringWithFormat:@"%@",self.myJson[@"nume"]];
    NSString * loca = [NSString  stringWithFormat:@"%@\n\n", self.myJson[@"localitate"][@"nume"]];
//    [item setTitle:[NSString stringWithFormat:@"Iti recomand %@ %@",[self.myJson objectForKey:@"tip"], [self.myJson objectForKey:@"nume"]]];
//    [item setText:[NSString stringWithFormat:@"%@%@%@%@%@%@%@",string1,string2,tip,nume,string3,loca,string4]];
//    //ComNSLog(@"item---%@",[NSString stringWithFormat:@"%@%@%@%@%@%@%@",string1,string2,tip,nume,string3,loca,string4]);
//    //ComNSLog(@"item---%@",item.text);
//    
//   
//    
////    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)item.text,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8 ));
//    
////    NSString *newString = [item.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    //ComNSLog(@"encoded string----%@",newString);
////    [item setText:newString];
//    
//    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
//
//   
//    [SHK setRootViewController:self];
//
//    [actionSheet showInView:self.view];
    
    NSString *string =[NSString stringWithFormat:@"%@%@%@%@%@%@%@",string1,string2,tip,nume,string3,loca,string4];
   // NSURL *URL = url;
    
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string]
                                      applicationActivities:nil];
    [activityViewController setValue:[NSString stringWithFormat:@"Iti recomand %@ %@",[self.myJson objectForKey:@"tip"], [self.myJson objectForKey:@"nume"]] forKey:@"subject"];
    
    [self presentModalViewController:activityViewController animated:YES];

}

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

    
    
 /* UIAlertView * mALert = [[UIAlertView alloc] initWithTitle:@"Mesaj" message:@"Aici se va intoarce de unde a venit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [mALert show];*/
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

-(IBAction)bookingAction:(UIButton *)sender{
    
    NSMutableArray * roomsSelectionArray = [[NSMutableArray alloc] init];
    for(int i=0; i< [feesArray count] ; i++){
        FeeTableViewCell * cell = (FeeTableViewCell *) [feesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [roomsSelectionArray addObject:cell.numberOfRoomsLabel.text];
    }
    
    //ComNSLog(@"fees  %@",roomsSelectionArray);
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    //ComNSLog(@"netstatus %u", netStatus);
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
//            EcranRezervareViewController *rzvrVC = [[EcranRezervareViewController alloc] initWithNibName:@"EcranRezervareViewController" bundle:nil];
//            rzvrVC.roomsSelectionArray = roomsSelectionArray;
//            rzvrVC.myJson = myJson;
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            
//            [self presentModalViewController:rzvrVC animated:NO];
            [self prezintaEcranRezervare:roomsSelectionArray];
            break;
        }
        case ReachableViaWiFi:
        {
//            EcranRezervareViewController *rzvrVC = [[EcranRezervareViewController alloc] initWithNibName:@"EcranRezervareViewController" bundle:nil];
//            rzvrVC.roomsSelectionArray = roomsSelectionArray;
//            rzvrVC.myJson = myJson;
//            CATransition *transition = [CATransition animation];
//            transition.duration = 0.5;
//            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            transition.type = kCATransitionPush;
//            transition.subtype = kCATransitionFromRight;
//            [self.view.window.layer addAnimation:transition forKey:nil];
//            
//            [self presentModalViewController:rzvrVC animated:NO];
            [self prezintaEcranRezervare:roomsSelectionArray];
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

#define PAGE_CONTROL_DEFAULT_PAGE_DIAMETER  12.0
#define PAGE_CONTROL_DEFAULT_PAGE_MARGIN    10.0
#define PAGE_CONTROL_MINIMUM_PAGE_DIAMETER  3.0
#define PAGE_CONTROL_MINIMUM_PAGE_MARGIN    5.0

- (void)sizePageControlIndicatorsToFit {
	// reset defaults
	[photoViewer.pageControl setIndicatorDiameter:PAGE_CONTROL_DEFAULT_PAGE_DIAMETER];
	[photoViewer.pageControl setIndicatorMargin:PAGE_CONTROL_DEFAULT_PAGE_MARGIN];
    [photoViewer.pageControl setBackgroundColor:UIColorFromRGB(0xebf3d0)];
    
	NSInteger indicatorMargin = photoViewer.pageControl.indicatorMargin;
	NSInteger indicatorDiameter = photoViewer.pageControl.indicatorDiameter;
    
	CGFloat minIndicatorDiameter = PAGE_CONTROL_MINIMUM_PAGE_DIAMETER;
	CGFloat minIndicatorMargin = PAGE_CONTROL_MINIMUM_PAGE_MARGIN;
    
	NSInteger pages = [photoViewer.imagesUrls count];//photoViewer.pageControl.numberOfPages;
	CGFloat actualWidth = [photoViewer.pageControl sizeForNumberOfPages:pages].width;
    
    //ComNSLog(@"actual width---%f,%f",actualWidth,CGRectGetWidth(photoViewer.pageControl.bounds));
    //ComNSLog(@"number of photos---%d",[photoViewer.imagesUrls count]);
	BOOL toggle = YES;
    
	while (actualWidth > CGRectGetWidth(photoViewer.pageControl.bounds) && (indicatorMargin > minIndicatorMargin || indicatorDiameter > minIndicatorDiameter)) {
		if (toggle) {
			if (indicatorMargin > minIndicatorMargin) {
				photoViewer.pageControl.indicatorMargin = --indicatorMargin;
			}
		} else {
			if (indicatorDiameter > minIndicatorDiameter) {
				photoViewer.pageControl.indicatorDiameter = --indicatorDiameter;
			}
		}
		toggle = !toggle;
		actualWidth = [photoViewer.pageControl sizeForNumberOfPages:pages].width;
	}
    
	if (actualWidth > CGRectGetWidth(photoViewer.pageControl.bounds)) {
		//ComNSLog(@"Too many pages! Already at minimum margin (%d) and diameter (%d).", indicatorMargin, indicatorDiameter);
	}
}



- (void)didReceiveMemoryWarning
{
    //ComNSLog(@"%s",__func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
