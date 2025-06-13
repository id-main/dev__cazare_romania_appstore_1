//
//  Ecran4Filtre.m
//  CazareRomania
//  Created by Ioan Ungureanu on 4/23/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//  nota  KillerMode se ocupa cu tranzitia la ecranul harta 1 daca este portrait sau landscape


#define TAG_ALERTA_PENSIUNI 1000
#define TAG_ALERTA_OBIECTIVE 2000
#import "AppDelegate.h"
#import "Ecran4Filtre.h"
#import "Reachability.h"
#import "StartViewController.h"
#import "DataBaseMaster.h"
#import "StartViewController.h"
#import "SubFiltruTableViewCell.h"
#import "SimpleCheckTableViewCell.h"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import <objc/runtime.h>
@interface Ecran4Filtre (){
    
}

@end

@implementation Ecran4Filtre
@synthesize LoadingDataIndicator, butonAnulati,BigScroll,butonOK,contentView,TitluriFiltrePensiuni, FiltrePensiuni;
@synthesize  TitluriFiltreObiective, FiltreObiective, toatefiltrele,SubcategoriiObiective, Subcategorie,subcategoriiView,SmallScroll,UTILIZATORtoatefiltrele,titluCategorieinViewSubcategorie,secondView,butonBackCategorii,pensiuniOnOff, obiectiveOnOff,RandObiectiv,totsaunimic,copietoatefiltrele;
@synthesize CopieSELECTIEStelePensiuni, CopieTitluriFiltreObiective,SELECTIEStelePensiuni,JustCompare,preturi,copiepreturi,globalExcludedSubcats,TITLUECRAN,TITLUECRANSUBCATEGORII;
@synthesize labelObiective, stele, pretNoapte,pretulMaxim,pretulMinim,VctrDtl,labelpensiuni/*,labelAnulati*/;
@synthesize _minThumb, _maxThumb,_padding;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    ////ComNSLog(@"%s",__func__);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
//stele la init
-(void) copiazaSteleInitiale {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SELECTIEStelePensiuni = [(NSMutableArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
    CopieSELECTIEStelePensiuni = SELECTIEStelePensiuni;
}
//array compare pentru filtre init -> original
-(void) copiazaTitluriFiltreObiectiveInitiale {
    self.CopieTitluriFiltreObiective = [[NSMutableArray alloc]init];
    self.CopieTitluriFiltreObiective = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:TitluriFiltreObiective]];
    self.JustCompare = [[NSMutableArray alloc]init];
    self.JustCompare = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:TitluriFiltreObiective]];
}
-(void) copiazaPreturiInitiale {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
            VctrDtl.frame = CGRectMake(10,454,screenWidth -20, 80);
    }else{
        //DO Landscape
    
    VctrDtl.frame = CGRectMake(10,454,screenHeight -20, 80);
    }
    pret_slider=[[RangeSlider alloc] initWithFrame:CGRectMake(VctrDtl.bounds.origin.x,VctrDtl.bounds.origin.y+7,VctrDtl.bounds.size.width, VctrDtl.bounds.size.height)];
    [self updatepreturi];
    [VctrDtl addSubview:pret_slider];
    [VctrDtl addSubview:pretulMinim];
    [VctrDtl addSubview:pretulMaxim];
    [self.contentView addSubview:VctrDtl];
    [self.contentView bringSubviewToFront:VctrDtl];
}
-(void) updatepreturi {
    NSString *moneda= [NSString stringWithFormat:@"%@", [preturi valueForKey:@"moneda"]];
    pret_slider.minimumValue = [[preturi valueForKey:@"rangeMin"] floatValue];
    pret_slider.maximumValue = [[preturi valueForKey:@"rangeMax"] floatValue];
    pret_slider.selectedMinimumValue = [[preturi valueForKey:@"pretMin"] floatValue];
    pret_slider.selectedMaximumValue = [[preturi valueForKey:@"pretMax"] floatValue];
    pret_slider.minimumRange = 00;
    [pret_slider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    self.pretulMinim.text=[NSString stringWithFormat:@"%0.0f %@",  pret_slider.selectedMinimumValue, moneda];
    self.pretulMaxim.text=[NSString stringWithFormat:@"%0.0f %@",  pret_slider.selectedMaximumValue, moneda];
  }
-(void) anuleazapreturi {
    NSString *moneda= [NSString stringWithFormat:@"%@", [preturi valueForKey:@"moneda"]];
    pret_slider.minimumValue = [[preturi valueForKey:@"rangeMin"] floatValue];
    pret_slider.maximumValue = [[preturi valueForKey:@"rangeMax"] floatValue];
    pret_slider.selectedMinimumValue = [[preturi valueForKey:@"pretMin"] floatValue];
    pret_slider.selectedMaximumValue = [[preturi valueForKey:@"pretMax"] floatValue];
    pret_slider.minimumRange = 00;
    [pret_slider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    self.pretulMinim.text=[NSString stringWithFormat:@"%0.0f %@",  pret_slider.minimumValue, moneda];
    self.pretulMaxim.text=[NSString stringWithFormat:@"%0.0f %@",  pret_slider.maximumValue, moneda];
    [pret_slider setNeedsDisplay];
    [self.pretulMinim setNeedsDisplay];
    [self.pretulMaxim setNeedsDisplay];
    
}
-(void)updateRangeLabel:(RangeSlider *)slider{
   // //ComNSLog(@"update range label");
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *moneda= [NSString stringWithFormat:@"%@", [preturi valueForKey:@"moneda"]];
    self.pretulMinim.text=[NSString stringWithFormat:@"%0.0f %@", slider.selectedMinimumValue, moneda];
    self.pretulMaxim.text=[NSString stringWithFormat:@"%0.0f %@", slider.selectedMaximumValue,moneda];
  
    NSString *PRETMINSEL =[NSString stringWithFormat:@"%0.0f", slider.selectedMinimumValue];
    NSString *PRETMAXSEL =[NSString stringWithFormat:@"%0.0f", slider.selectedMaximumValue];
    [preturi setValue:PRETMINSEL forKey:@"pretMin"];
    [preturi setValue:PRETMAXSEL forKey:@"pretMax"];
     appDelGlobal.userPreturi = preturi;
//    //ComNSLog(@"slider.BUTONBSCulMinim.center.x %f",slider._pretulMinim.center.x);
//     //ComNSLog(@"slider._pretulMaxim.center.x %f",slider._pretulMaxim.center.x);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
   CGFloat screenHeight = screenRect.size.height;
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
        if(  slider._pretulMinim.center.x <40) {
            pretulMinim.center = CGPointMake(30,pretulMinim.center.y );
        } else if (slider._pretulMinim.center.x > screenWidth -60) {
            pretulMinim.center = CGPointMake(screenWidth -60,pretulMinim.center.y );
        } else{
            pretulMinim.center = CGPointMake(slider._pretulMinim.center.x,pretulMinim.center.y );
        }
        if(  slider._pretulMaxim.center.x <40) {
            pretulMaxim.center = CGPointMake(30,pretulMaxim.center.y );
        } else if (slider._pretulMaxim.center.x > screenWidth -60) {
            pretulMaxim.center = CGPointMake(screenWidth -60,pretulMaxim.center.y );
        } else{
            pretulMaxim.center = CGPointMake(slider._pretulMaxim.center.x,pretulMaxim.center.y );
        }

    }else{
        //DO Landscape
        if(  slider._pretulMinim.center.x <40) {
            pretulMinim.center = CGPointMake(30,pretulMinim.center.y );
        } else if (slider._pretulMinim.center.x > screenHeight -60) {
            pretulMinim.center = CGPointMake(screenHeight -60,pretulMinim.center.y );
        } else{
            pretulMinim.center = CGPointMake(slider._pretulMinim.center.x,pretulMinim.center.y );
        }
        if(  slider._pretulMaxim.center.x <40) {
            pretulMaxim.center = CGPointMake(30,pretulMaxim.center.y );
        } else if (slider._pretulMaxim.center.x > screenHeight -60) {
            pretulMaxim.center = CGPointMake(screenHeight -60,pretulMaxim.center.y );
        } else{
            pretulMaxim.center = CGPointMake(slider._pretulMaxim.center.x,pretulMaxim.center.y );
        }

    }

    
 
}


- (void)viewDidLoad
{
    
    ////ComNSLog(@"%s",__func__);
    [super viewDidLoad];
  
    
    //if(SYSTEM_VERSION_LESS_THAN(@"7.0")){
//        pensiuniOnOff.transform = CGAffineTransformMakeScale(1, 1);
//        obiectiveOnOff.transform = CGAffineTransformMakeScale(0.75, 0.75);
    //}
    
    
    ////ComNSLog(@"%s",__func__);
    
    //ComNSLog(@"self navigationcontroller---%@",self.navigationController);
    [BigScroll setBounces:YES];
    [SmallScroll setBounces:YES];
    
    if ([self respondsToSelector:@selector(prefersStatusBarHidden)]) {
        [self prefersStatusBarHidden];
    }
    else{
//        [UIApplication sharedApplication].statusBarHidden = YES;
         [UIApplication sharedApplication].statusBarHidden = NO;
    }

    
    
    self.navigationController.navigationBar.hidden = YES;
    self.LoadingDataIndicator.hidden =YES;
    Subcategorie = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.hidden = YES;
    DataMasterProcessor *controller;
    controller = [[DataMasterProcessor alloc] init];
    toatefiltrele = [[NSDictionary alloc]init];
    [controller preiaFiltre_Ecran1];
    //////////////    1 pensiuni   ////////////// arie cu titluri si valori pentru pensiuni stele hardcoded
    TitluriFiltrePensiuni=[[NSArray alloc] initWithObjects:@"Neclasificate",@"1 stea",@"2 stele",@"3 stele",@"4 stele",@"5 stele",nil];
     [self copiazaSteleInitiale];
   
 
    //////////////    2  obiective  ////////////// arii
    //nume categ. filtru -> TitluriFiltreObiective[0][0]);
    //nume subcategorii filtru -> TitluriFiltreObiective[0][1]);
    //id categ.filtru ->  TitluriFiltreObiective[0][2]);
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TitluriFiltreObiective = appDelGlobal.UserTitluriFiltreObiective;
    if( appDelGlobal.ListaFiltreServer !=nil  && TitluriFiltreObiective.count==0) {
        TitluriFiltreObiective =[[NSMutableArray alloc]init];
        Subcategorie = [[NSMutableArray alloc]init];
        toatefiltrele =  appDelGlobal.ListaFiltreServer; //este Request 1 global !
        //aici avem dictionarul de filtre de la server
        NSMutableArray *filtre_categorii_obiective = [[[[toatefiltrele objectForKey:@"results" ] objectForKey:@"filtre"]objectForKey:@"obiective"]objectForKey:@"categorii"] ;
        for(int i=0; i< filtre_categorii_obiective.count; i++) {
            NSDictionary *temp1 = filtre_categorii_obiective[i];
            NSString *filtru_categorii_obiective = [NSString stringWithFormat:@"%@",[temp1 objectForKey:@"nume"]];
            NSString *filtru_categorii_id = [NSString stringWithFormat:@"%@",[temp1 objectForKey:@"id"]];
            NSMutableArray *temp2 =[[temp1 objectForKey:@"subcategorii"]mutableCopy];
            NSMutableArray *temp3 = [NSMutableArray arrayWithObjects:filtru_categorii_obiective,temp2,filtru_categorii_id,nil];
            [TitluriFiltreObiective addObject: temp3];
        }
        [self copiazaTitluriFiltreObiectiveInitiale];
      //  [self mesajAlerta:@"nu avem filtre initiale" titluAlerta:@"ok"];
    } else  if( appDelGlobal.ListaFiltreServer !=nil  &&  self.TitluriFiltreObiective.count!=0) {
        //exista date filtrare ale userului
     //   [self mesajAlerta:@"Userul are filtre active pe obiective / sesiune" titluAlerta:@"OK"];
        [self copiazaSteleInitiale];
        [self copiazaTitluriFiltreObiectiveInitiale];
    } else {
        [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
    }
   
    [self.view addSubview:BigScroll];
    [self.view bringSubviewToFront:BigScroll];
      //////////////    3  preturi  ////////////// 5 campuri
    preturi =appDelGlobal.userPreturi;
    if(appDelGlobal.userPreturi !=nil  && preturi.count==0) {
        preturi = [[NSMutableDictionary alloc]init];
        preturi = [[[[toatefiltrele objectForKey:@"results" ] objectForKey:@"filtre"]objectForKey:@"pensiuni"] mutableCopy];
        //ComNSLog(@"preturi %@", preturi);
    } else if(appDelGlobal.userPreturi !=nil  && preturi.count!=0) {
    // [self mesajAlerta:@"Userul are filtre active preturi / sesiune" titluAlerta:@"OK"];
    }
    else {
    [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
    }
    self.copiepreturi = [[NSMutableDictionary alloc]init];
    self.copiepreturi =[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:preturi]];
    //aranjeaza grafic

    
    salveaza = YES;
    
    UIImage* swOff = [UIImage imageNamed:@"switchcoff.png"];
    UIImage* swOn = [UIImage imageNamed:@"switchon.png"];
    pensiuniOnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    [pensiuniOnOff addTarget:self
                      action:@selector(pensiuniOnOffSwitch:)
            forControlEvents:UIControlEventTouchUpInside];
   
    [pensiuniOnOff setBackgroundImage:swOn forState:UIControlStateSelected];
    [pensiuniOnOff setBackgroundImage:swOff forState:UIControlStateNormal];
   
//    [self.contentView bringSubviewToFront:pensiuniOnOff];
    
    obiectiveOnOff = [UIButton buttonWithType:UIButtonTypeCustom];
    [obiectiveOnOff addTarget:self
                       action:@selector(OBIECTIVEOnOffSwitch:)
             forControlEvents:UIControlEventTouchUpInside];
   
    //    [view addSubview:button];
    
    [obiectiveOnOff setBackgroundImage:swOn forState:UIControlStateSelected];
    [obiectiveOnOff setBackgroundImage:swOff forState:UIControlStateNormal];
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
        pensiuniOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width -60, labelpensiuni.frame.origin.y +3, 52.0, 30.0);
        obiectiveOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width -60, labelObiective.frame.origin.y +3, 52.0, 30.0);
    }else{
        //DO Landscape
        pensiuniOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height -60, labelpensiuni.frame.origin.y +3, 52.0, 30.0);
        obiectiveOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height -60, labelObiective.frame.origin.y +3, 52.0, 30.0);
    }
    [self.contentView addSubview:pensiuniOnOff];
    [self.contentView addSubview:obiectiveOnOff];
//    [self.contentView bringSubviewToFront:obiectiveOnOff];
      //ComNSLog(@"switch frame---%@", NSStringFromCGRect(pensiuniOnOff.frame));
      //ComNSLog(@"switch 2 frame---%@", NSStringFromCGRect(obiectiveOnOff.frame));
    
    //    int xPos = (pensiuniOnOff.frame.origin.x + pensiuniOnOff.frame.size.width) - self.view.bounds.size.width;
    
    //    [pensiuniOnOff setFrame:CGRectMake(pensiuniOnOff.frame.origin.x - xPos, pensiuniOnOff.frame.origin.y, pensiuniOnOff.frame.size.width, pensiuniOnOff.frame.size.height)];
    //    [obiectiveOnOff setFrame:CGRectMake(obiectiveOnOff.frame.origin.x - xPos, obiectiveOnOff.frame.origin.y, obiectiveOnOff.frame.size.width, obiectiveOnOff.frame.size.height)];
   

    
    
    [self switchPensiuni];
    [self switchObiective];
    [self copiazaPreturiInitiale];
    [self.BigScroll addSubview:self.contentView];
    
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
        [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
    }else{
        //DO Landscape
        [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
        

    }
//    self.BigScroll.contentSize = size ;
    
    FiltrePensiuni.layer.cornerRadius = 5.0;
    FiltrePensiuni.layer.masksToBounds = YES;
    
    FiltreObiective.layer.cornerRadius = 5.0;
    FiltreObiective.layer.masksToBounds = YES;
    
    SubcategoriiObiective.layer.cornerRadius = 5.0;
    SubcategoriiObiective.layer.masksToBounds = YES;
    
//    [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height )];
//    labelAnulati.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
//    labelAnulati.center = butonAnulati.center;
    TITLUECRAN.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
    TITLUECRANSUBCATEGORII.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
    titluCategorieinViewSubcategorie.font =[UIFont fontWithName:@"OpenSans" size:18.5f];
    butonAnulati.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    butonAnulati.titleLabel.textAlignment = NSTextAlignmentCenter;
    butonAnulati.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    butonOK.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    butonOK.titleLabel.textAlignment = NSTextAlignmentCenter;
    butonOK.titleLabel.textColor =   [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1] ;
    labelpensiuni.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    labelpensiuni.font =[UIFont fontWithName:@"OpenSans-Bold" size:17.5f];
    
    labelObiective.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1];
    labelObiective.font =[UIFont fontWithName:@"OpenSans-Bold" size:17.5f];
    stele.font=[UIFont fontWithName:@"OpenSans" size:18.5f];
    pretNoapte.font =[UIFont fontWithName:@"OpenSans" size:18.5f];
    pretulMinim.font =[UIFont fontWithName:@"OpenSans" size:13.0f];
    pretulMaxim.font =[UIFont fontWithName:@"OpenSans" size:13.0f];
    
      [butonBackCategorii.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    butonBackCategorii.titleLabel.textColor =   [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
    butonBackCategorii.titleLabel.textAlignment = NSTextAlignmentCenter;
    butonBackCategorii.titleLabel.textColor =   [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
    
 
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    //ComNSLog(@"will appear:");
    //ComNSLog(@"big scroll:  %@", NSStringFromCGSize(BigScroll.contentSize));
    [FiltreObiective setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [FiltrePensiuni setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [SubcategoriiObiective setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        int width = [[UIScreen mainScreen] bounds].size.height - pret_slider.frame.origin.x -10;
        [pret_slider setFrame:CGRectMake(pret_slider.frame.origin.x, pret_slider.frame.origin.y,width , pret_slider.frame.size.height)];
        CGRect newFrame=CGRectMake(10,
                                   pret_slider.frame.origin.y,
                                   pret_slider.frame.size.width-30,
                                   10);
        
        [pret_slider._trackBackground setFrame:newFrame];
        pret_slider._trackBackground.center  = pret_slider.center;
////        [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height +50)];
//        
//        [secondView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
//        [SubcategoriiObiective setFrame:CGRectMake(SubcategoriiObiective.frame.origin.x, SubcategoriiObiective.frame.origin.y, [[UIScreen mainScreen]bounds].size.height - SubcategoriiObiective.frame.origin.x *2, SubcategoriiObiective.frame.size.height)];
////        [SmallScroll setContentSize:CGSizeMake(SubcategoriiObiective.frame.size.width,SubcategoriiObiective.frame.size.height)];
        
    }
    else{
        
        int width = [[UIScreen mainScreen] bounds].size.width - pret_slider.frame.origin.x * 2 -10;
        [pret_slider setFrame:CGRectMake(pret_slider.frame.origin.x, pret_slider.frame.origin.y,width , pret_slider.frame.size.height)];
        CGRect newFrame=CGRectMake(10,
                                   pret_slider.frame.origin.y,
                                   pret_slider.frame.size.width-30,
                                   10);
        [pret_slider._trackBackground setFrame:newFrame];
        pret_slider._trackBackground.center  = pret_slider.center;
    
//        [secondView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
//        //ComNSLog(@"secondview frame---%@", NSStringFromCGRect(secondView.frame));
//        [SubcategoriiObiective setFrame:CGRectMake(SubcategoriiObiective.frame.origin.x, SubcategoriiObiective.frame.origin.y, [[UIScreen mainScreen]bounds].size.width - SubcategoriiObiective.frame.origin.x *2, SubcategoriiObiective.frame.size.height)];
////                [SmallScroll setFrame:CGRectMake(0, titluCategorieinViewSubcategorie.frame.origin.y + titluCategorieinViewSubcategorie.frame.size.height, [[UIScreen mainScreen] bounds].size.width, SmallScroll.frame.size.height)];
////        [SmallScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, SubcategoriiObiective.frame.size.height +SubcategoriiObiective.frame.origin.y)];
//        int Fullheight = self.labelpensiuni.frame.size.height + self.stele.frame.size.height + self.FiltrePensiuni.frame.size.height + self.VctrDtl.frame.size.height+ self.FiltreObiective.frame.size.height;
//        [[self contentView]  setFrame:CGRectMake(0,0, contentView.frame.size.width,Fullheight)];
//        CGSize size = self.contentView.bounds.size;
//             self.BigScroll.contentSize = size ;
//        [self.BigScroll setNeedsDisplay];
    }
    
    

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        int width = [[UIScreen mainScreen] bounds].size.height - pret_slider.frame.origin.x -10;
        [pret_slider setFrame:CGRectMake(pret_slider.frame.origin.x, pret_slider.frame.origin.y,width , pret_slider.frame.size.height)];
        CGRect newFrame=CGRectMake(10,
                                   pret_slider.frame.origin.y,
                                   pret_slider.frame.size.width-30,
                                   10);
        
        [pret_slider._trackBackground setFrame:newFrame];
        pret_slider._trackBackground.center  = pret_slider.center;
        //ComNSLog(@"pret slider fr:   %@",NSStringFromCGRect(pret_slider.frame));
        //ComNSLog(@"track back:   %@", NSStringFromCGRect(pret_slider._trackBackground.frame));
        [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
        
        [[self SubcategoriiObiective] setFrame:CGRectMake(SubcategoriiObiective.frame.origin.x,0, SubcategoriiObiective.frame.size.width, 50 *Subcategorie.count)];
        
        [[self subcategoriiView] setFrame:CGRectMake(0, 0, self.view.bounds.size.width,CGRectGetMaxY(self.SubcategoriiObiective.frame) + 25)];
        [self.SubcategoriiObiective setNeedsDisplay];
        pensiuniOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height -60, labelpensiuni.frame.origin.y +3, 52.0, 30.0);
        
        obiectiveOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.height -60, labelObiective.frame.origin.y +3, 52.0, 30.0);
        
        titluCategorieinViewSubcategorie.frame = CGRectMake(15,0, titluCategorieinViewSubcategorie.frame.size.width,titluCategorieinViewSubcategorie.frame.size.height);
        SubcategoriiObiective.frame = CGRectMake( SubcategoriiObiective.frame.origin.x,titluCategorieinViewSubcategorie.frame.origin.y +42, SubcategoriiObiective.frame.size.width,SubcategoriiObiective.frame.size.height);
        //DO Landscape
        [SmallScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, titluCategorieinViewSubcategorie.frame.origin.y + titluCategorieinViewSubcategorie.frame.size.height+ SubcategoriiObiective.frame.origin.y + SubcategoriiObiective.frame.size.height+25)];
        
        
        
        
        
        [self.secondView setNeedsDisplay];
        //ComNSLog(@"LAND SI secondView HEIGHT  modif %f", secondView.frame.size.height);
        //ComNSLog(@"scroll view content   %@",NSStringFromCGSize(SmallScroll.contentSize));
        //ComNSLog(@"table view   %@",NSStringFromCGRect(SubcategoriiObiective.frame));
        
    }
    else{
        
        int width = [[UIScreen mainScreen] bounds].size.width - pret_slider.frame.origin.x * 2 -10;
        [pret_slider setFrame:CGRectMake(pret_slider.frame.origin.x, pret_slider.frame.origin.y,width , pret_slider.frame.size.height)];
        CGRect newFrame=CGRectMake(10,
                                   pret_slider.frame.origin.y,
                                   pret_slider.frame.size.width-30,
                                   10);
        [pret_slider._trackBackground setFrame:newFrame];
        pret_slider._trackBackground.center  = pret_slider.center;
        
        //ComNSLog(@"pret slider fr:   %@",NSStringFromCGRect(pret_slider.frame));
        //ComNSLog(@"track back:   %@", NSStringFromCGRect(pret_slider._trackBackground.frame));
        [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
        [[self SubcategoriiObiective] setFrame:CGRectMake(SubcategoriiObiective.frame.origin.x,0, SubcategoriiObiective.frame.size.width, 50 *Subcategorie.count)];
                [[self subcategoriiView] setFrame:CGRectMake(0, 0, self.view.bounds.size.width,CGRectGetMaxY(self.SubcategoriiObiective.frame) + 25)];
        [self.SubcategoriiObiective setNeedsDisplay];
        pensiuniOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width -60, labelpensiuni.frame.origin.y +3, 52.0, 30.0);
        
        obiectiveOnOff.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width -60, labelObiective.frame.origin.y +3, 52.0, 30.0);
        //        [SmallScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, SubcategoriiObiective.frame.origin.y + SubcategoriiObiective.frame.size.height +34)];
        titluCategorieinViewSubcategorie.frame = CGRectMake(15,0, titluCategorieinViewSubcategorie.frame.size.width,titluCategorieinViewSubcategorie.frame.size.height);
        SubcategoriiObiective.frame = CGRectMake( SubcategoriiObiective.frame.origin.x,titluCategorieinViewSubcategorie.frame.origin.y +42, SubcategoriiObiective.frame.size.width,SubcategoriiObiective.frame.size.height);
        
        //DO Portrait
        [SmallScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width,titluCategorieinViewSubcategorie.frame.origin.y + titluCategorieinViewSubcategorie.frame.size.height+ SubcategoriiObiective.frame.origin.y + SubcategoriiObiective.frame.size.height +25)];
        
        
        [self.secondView setNeedsDisplay];
        
        //ComNSLog(@"secondview frame---%@", NSStringFromCGRect(secondView.frame));
        
        //ComNSLog(@"port  SI SmallScroll HEIGHT %f", SmallScroll.frame.size.height);
        //ComNSLog(@"scroll view content   %@",NSStringFromCGSize(SmallScroll.contentSize));
        //ComNSLog(@"table view   %@",NSStringFromCGRect(SubcategoriiObiective.frame));
        
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    ////ComNSLog(@"%s",__func__);
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// butonul totsaunimic
-(IBAction)totsaunimicSelected:(id)sender {
    if( [totsaunimic.titleLabel.text isEqualToString:@"nimic-btn.png"]) {
        //debifeaza
        ////ComNSLog(@"nimic: %@" ,Subcategorie);
        for(int i=0; i< Subcategorie.count;i++) {
            NSMutableDictionary *SCHIMBASELECT =[[Subcategorie objectAtIndex:i] mutableCopy];
            [SCHIMBASELECT setValue:@"0" forKey:@"selected"];
            [Subcategorie replaceObjectAtIndex:i withObject:SCHIMBASELECT];
            [[TitluriFiltreObiective objectAtIndex:RandObiectiv][1]replaceObjectAtIndex:i withObject:SCHIMBASELECT];
        }
        [SubcategoriiObiective reloadData];
        [FiltreObiective reloadData];
        [self SchimbaTotsauNimic];
        
    } else   if( [totsaunimic.titleLabel.text isEqualToString:@"tot-btn.png"]) {
        //bifeaza tot
        ////ComNSLog(@"tot:%@", Subcategorie);
        for(int i=0; i< Subcategorie.count;i++) {
            NSMutableDictionary *SCHIMBASELECT =[[Subcategorie objectAtIndex:i] mutableCopy];
            [SCHIMBASELECT setValue:@"1" forKey:@"selected"];
            [Subcategorie replaceObjectAtIndex:i withObject:SCHIMBASELECT];
            [[TitluriFiltreObiective objectAtIndex:RandObiectiv][1]replaceObjectAtIndex:i withObject:SCHIMBASELECT];
        }
        [SubcategoriiObiective reloadData];
        [FiltreObiective reloadData];
        [self SchimbaTotsauNimic];
    }
}
-(void)KillerMode {
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromBottom;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //DO Landscape
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }

}


// butonul ok -> inchide modal view
-(IBAction)ButonOkSelected:(id)sender {
 
    //case 1 all
    //case 2 obiective
    //case 3 pensiuni
//#define WEBSERVICE_MARKERS_ALL  @"/all/markers/bounds/?"  // [are bifate si obiective si pensiuni]
//#define WEBSERVICE_MARKERS_OBIECTIVE   @"/obiective/markers/bounds/?" // [are bifate obiective ]
//#define WEBSERVICE_MARKERS_PENSIUNI  @"/pensiuni/markers/bounds/?" // [are bifate pensiuni]
 

    
    if(pensiuniOnOff.selected ==YES && obiectiveOnOff.selected ==NO ) {
          [self stringPentruServer];
        //sync user defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        CopieSELECTIEStelePensiuni = SELECTIEStelePensiuni;
        [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
        if(obiectiveOnOff.selected ==NO) {
            NSString *areObiective = @"0";
            [defaults setObject:areObiective forKey:@"ObiectiveOn.Cazare.ro"];
        } else  if(obiectiveOnOff.selected ==YES) {
            NSString *areObiective = @"1";
            [defaults setObject:areObiective forKey:@"ObiectiveOn.Cazare.ro"];
        }
      
        // CopieTitluriFiltreObiective = TitluriFiltreObiective;
        [self UserTitluriFiltreObiectiveAppDelegate];
        [FiltreObiective reloadData];
        [self excludeCategorii];
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelGlobal.userPreturi = preturi;
        //TODO si salveaza filtre !!
        StartViewController *controller;
        controller = [[StartViewController alloc] init];
        
        appDelGlobal.CMD_STRING = CMD_LISTA_PENSIUNI;
     //            [controller checkCmd:[self stringPentruServer] ];
        NSString *CMD_GLOBAL_FILTRE = CMD_LISTA_PENSIUNI;
           [defaults setObject:CMD_GLOBAL_FILTRE forKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self KillerMode];
    } else  if(pensiuniOnOff.selected ==YES && obiectiveOnOff.selected ==YES ) {
        //sync user defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        CopieSELECTIEStelePensiuni = SELECTIEStelePensiuni;
        [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
        if(obiectiveOnOff.selected ==NO) {
            NSString *areObiective = @"0";
            [defaults setObject:areObiective forKey:@"ObiectiveOn.Cazare.ro"];
        } else  if(obiectiveOnOff.selected ==YES) {
            NSString *areObiective = @"1";
            [defaults setObject:areObiective forKey:@"ObiectiveOn.Cazare.ro"];
        }
        
      
        // CopieTitluriFiltreObiective = TitluriFiltreObiective;
        [self UserTitluriFiltreObiectiveAppDelegate];
        [FiltreObiective reloadData];
        [self excludeCategorii];
        AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelGlobal.userPreturi = preturi;
        //TODO si salveaza filtre !!
        StartViewController *controller;
        controller = [[StartViewController alloc] init];
          [self stringPentruServer];
        
        appDelGlobal.CMD_STRING =CMD_ALL;
        NSString *CMD_GLOBAL_FILTRE = CMD_ALL;
          [defaults setObject:CMD_GLOBAL_FILTRE forKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
 [self KillerMode];
            }
    else if(pensiuniOnOff.selected ==NO && obiectiveOnOff.selected ==YES ) {
                //sync user defaults
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                CopieSELECTIEStelePensiuni = SELECTIEStelePensiuni;
                [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
                if(obiectiveOnOff.selected ==NO) {
                    NSString *areObiective = @"0";
                    [defaults setObject:areObiective forKey:@"ObiectiveOn.Cazare.ro"];
                } else  if(obiectiveOnOff.selected ==YES) {
                    NSString *areObiective = @"1";
                    [defaults setObject:areObiective forKey:@"ObiectiveOn.Cazare.ro"];
                }
        
                // CopieTitluriFiltreObiective = TitluriFiltreObiective;
                [self UserTitluriFiltreObiectiveAppDelegate];
                [FiltreObiective reloadData];
                [self excludeCategorii];
                AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelGlobal.userPreturi = preturi;
                //TODO si salveaza filtre !!
                StartViewController *controller;
                controller = [[StartViewController alloc] init];
       
        appDelGlobal.CMD_STRING =CMD_LISTA_OBIECTIVE;
        NSString *CMD_GLOBAL_FILTRE = CMD_LISTA_OBIECTIVE;
          [defaults setObject:CMD_GLOBAL_FILTRE forKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];

          [self stringPentruServer];
     //    [controller checkCmd:[self stringPentruServer]];
//        [self.navigationController popViewControllerAnimated:YES];
        [self KillerMode];
    } else  if(pensiuniOnOff.selected==NO && obiectiveOnOff.selected ==NO ) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
                                                    message:@"Pentru a filtra trebuie sa aveti un criteriu activ!"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
  

}
// butonul anuleaza
-(IBAction)ButonAnuleazaSelected:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ////ComNSLog(@"CopieSELECTIEStelePensiuni %@",CopieSELECTIEStelePensiuni);
    [defaults setObject:CopieSELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
    SELECTIEStelePensiuni =  CopieSELECTIEStelePensiuni;
    [FiltrePensiuni reloadData];
    //anuleaza mods
    //ComNSLog(@"COPIE %@", self.CopieTitluriFiltreObiective);
    TitluriFiltreObiective = [[NSMutableArray alloc]init];
    TitluriFiltreObiective = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.CopieTitluriFiltreObiective]];
    [FiltreObiective reloadData];
    [SubcategoriiObiective reloadData];
    [self UserTitluriFiltreObiectiveAppDelegate];
    [self excludeCategorii];
    //si preturi iar
    self.preturi = [[NSMutableDictionary alloc]init];
    self.preturi =[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.copiepreturi]];
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelGlobal.userPreturi = self.preturi;
    //ComNSLog(@"preturi---%@", self.preturi);
    [self anuleazapreturi];
    [self switchObiective];
    StartViewController *controller;
    controller = [[StartViewController alloc] init];
    if(pensiuniOnOff.selected ==YES && obiectiveOnOff.selected ==NO ) {
        [self stringPentruServer];
        
        appDelGlobal.CMD_STRING = CMD_LISTA_PENSIUNI;
        NSString *CMD_GLOBAL_FILTRE = CMD_LISTA_PENSIUNI;
        [defaults setObject:CMD_GLOBAL_FILTRE forKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
 [self KillerMode];
    } else  if(pensiuniOnOff.selected ==YES && obiectiveOnOff.selected ==YES ) {
        [self stringPentruServer];
        
        appDelGlobal.CMD_STRING =CMD_ALL;
        NSString *CMD_GLOBAL_FILTRE = CMD_ALL;
        [defaults setObject:CMD_GLOBAL_FILTRE forKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //     [controller checkCmd:[self stringPentruServer] ];
 [self KillerMode];
    }       else if(pensiuniOnOff.selected ==NO && obiectiveOnOff.selected ==YES ) {
        
        appDelGlobal.CMD_STRING =CMD_LISTA_OBIECTIVE;
        NSString *CMD_GLOBAL_FILTRE = CMD_LISTA_OBIECTIVE;
        [defaults setObject:CMD_GLOBAL_FILTRE forKey:@"CMD_GLOBAL_FILTRE.Cazare.ro"];
        // CMD_LISTA_OBIECTIVE CMD_ALL CMD_LISTA_PENSIUNI
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self stringPentruServer];
        //    [controller checkCmd:[self stringPentruServer]];
 [self KillerMode];
    } else  if(pensiuniOnOff.selected==NO && obiectiveOnOff.selected ==NO ) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Atentie"
//                                                        message:@"Trebuie sa activati cel putin un filtru activ"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [self.navigationController popViewControllerAnimated:YES];
         [self KillerMode];
    }
}

-(IBAction)categBack:(id)sender {
    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [secondView.layer addAnimation:transition forKey:nil];
//    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
//        //DO Portrait
//        CGRect frame = secondView.frame;
//        frame.origin.x = 320;
//        [UIView animateWithDuration:0.2
//                              delay:0.3
//                            options:UIViewAnimationOptionCurveEaseIn
//                         animations:^{
//                             [secondView setFrame:frame];
//                         }completion:^(BOOL finished){
//                             [SmallScroll setContentOffset:CGPointZero animated:YES];
//                             [secondView removeFromSuperview];
//                         }];
//        
//
//    }else{
        //DO Landscape
         CGFloat width = CGRectGetWidth(self.view.bounds);
        CGRect frame = secondView.frame;
        frame.origin.x = width;
        [UIView animateWithDuration:0.2
                              delay:0.3
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [secondView setFrame:frame];
                         }completion:^(BOOL finished){
                             [SmallScroll setContentOffset:CGPointZero animated:YES];
                             [secondView removeFromSuperview];
                         }];
        

//    }
   //    [SmallScroll setContentOffset:CGPointZero animated:YES];
//    [secondView removeFromSuperview];
    [self.FiltreObiective reloadData];
    [self.FiltreObiective setNeedsDisplay];
     self.BigScroll.hidden =NO;
//    [self.view bringSubviewToFront:BigScroll];
   
    
}

//// TABEL FILTRE PENSIUNI si FILTRE OBIECTIVE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   //daca se face cautare  -> isFiltered
    //     return 5;
    if(tableView==FiltrePensiuni){
        return TitluriFiltrePensiuni.count; }
    if(tableView==FiltreObiective){
        return TitluriFiltreObiective.count;
    }
    if(tableView==SubcategoriiObiective){
        return Subcategorie.count;
    }
    else return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     //!! important -> ai mai multe tableviews si faci reload
    NSUInteger row=indexPath.row;
    //buton bifa refolosibil
    UIButton *BifaStelePensiuni = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [BifaStelePensiuni setFrame:CGRectMake(270,5,36,31)];
    BifaStelePensiuni.tag =row +100 ; //Tagging the button
    [BifaStelePensiuni setImage:[UIImage imageNamed:@"check-btn_j.png"] forState:UIControlStateNormal];
    BifaStelePensiuni.userInteractionEnabled =NO;
    
    UIButton *BifaObiective = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [BifaObiective setFrame:CGRectMake(270,5,36,31)];
    BifaObiective.tag =row +300 ; //Tagging the button
    [BifaObiective setImage:[UIImage imageNamed:@"check-btn_j.png"] forState:UIControlStateNormal];
    BifaObiective.userInteractionEnabled =NO;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *StelePensiuni = [(NSMutableArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
   
    if(tableView==FiltrePensiuni){
        
        static NSString *CellIdentifier = @"SimpleCheckTableViewCell";
        
        SimpleCheckTableViewCell *cell = (SimpleCheckTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SimpleCheckTableViewCell" owner:self options:nil];
            for (id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell =  (SimpleCheckTableViewCell *) currentObject;
                    break;
                }
            }
        }
    [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [cell.textTitle setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
     
        
     
// verifica daca exista bife pe pensiuni si pune bifa pe selectate
        NSString *RANDBIFAT =[ NSString stringWithFormat:@"%i", row];
//         //ComNSLog(@"stelepensiuni---%@",StelePensiuni);
//        //ComNSLog(@"RANDBIFAT---%@",RANDBIFAT);
//        //ComNSLog(@"contains---%d", [StelePensiuni containsObject:RANDBIFAT]);
        //SCOATE VALOARE DIN ARRAY 0,1,2 -stele
        if ([StelePensiuni containsObject:RANDBIFAT]) {
            cell.cehckImage.hidden=NO;
            cell.textTitle.textColor = [UIColor colorWithRed:175/255.0f green:207/255.0f blue:69/255.0f alpha:1];
        } else {
            //ComNSLog(@"set hidden");
            cell.cehckImage.hidden=YES;
             cell.textTitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
        }
           cell.textTitle.text = [TitluriFiltrePensiuni objectAtIndex:row];
//        UIView *selectionColor = [[UIView alloc] init];
//        selectionColor.backgroundColor = [UIColor clearColor];
//        cell.selectedBackgroundView = selectionColor;
        
        UIView * separatorView;
        for(UIView * mView in cell.contentView.subviews){
            if(mView.tag == 666){
                [mView removeFromSuperview];
            }
        }
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,50 - 0.5 , cell.frame.size.width, 0.5)];
        [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
        [separatorView setTag:666];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:separatorView];
        
        return cell;
        
    }
    else{
        if(tableView==FiltreObiective){
            
            static NSString *CellIdentifier = @"SubFiltruTableViewCell";
            
            SubFiltruTableViewCell *cell = (SubFiltruTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SubFiltruTableViewCell" owner:self options:nil];
                for (id currentObject in topLevelObjects){
                    if ([currentObject isKindOfClass:[UITableViewCell class]]){
                        cell =  (SubFiltruTableViewCell *) currentObject;
                        break;
                    }
                }
            }
            [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
            [cell.tipObiectiv setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
            [cell.labelToate setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0f]];
            cell.tipObiectiv.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];

            NSString *filtru_categorii_obiective = [NSString stringWithFormat:@"%@",[TitluriFiltreObiective objectAtIndex:row][0]];
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 20, 10, 18)];
//            imgView.image = [UIImage imageNamed: @"sageata-categ_j.png"];
//            imgView.contentMode = UIViewContentModeScaleAspectFit;
//            imgView.clipsToBounds = YES;
//            [cell addSubview:imgView];
//            UILabel *lblMainLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 12, 190, 25)];
//            lblMainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
//            lblMainLabel.backgroundColor = [UIColor clearColor];
//            lblMainLabel.textColor = [UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1];
            NSArray *subtemp = [[NSArray alloc]init];
            subtemp =  [TitluriFiltreObiective objectAtIndex:row][1];
            NSMutableArray *cateSelectate = [[NSMutableArray alloc]init];
            for(int i=0;i<[[TitluriFiltreObiective objectAtIndex:row][1] count];i++) {
                NSDictionary *temp4 =[[TitluriFiltreObiective objectAtIndex:row][1] objectAtIndex:i];
                NSString *filtru_selected = [NSString stringWithFormat:@"%@",[temp4 objectForKey:@"selected"]];
                if([filtru_selected isEqualToString:@"1"]) {
                    [cateSelectate addObject:temp4];
                }
            }
            //ComNSLog(@"cateNeselectate %lu",(unsigned long)cateSelectate.count);
            NSString *toatecunumar =@"";
            if(cateSelectate.count == subtemp.count) {
                toatecunumar = @"Toate";
            } else  if(cateSelectate.count < subtemp.count) {
                toatecunumar = [NSString stringWithFormat:@"%i / %i",cateSelectate.count,subtemp.count];
            }
            cell.labelToate.text = toatecunumar;
            //cell.textLabel.text = filtru_categorii_obiective;
            [cell.tipObiectiv setText:filtru_categorii_obiective];
            [SubcategoriiObiective reloadData];
            
            UIView * separatorView;
            for(UIView * mView in cell.contentView.subviews){
                if(mView.tag == 666){
                    [mView removeFromSuperview];
                }
            }
            
            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,50 - 0.5 , cell.frame.size.width, 0.5)];
            [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
            [separatorView setTag:666];
            separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:separatorView];
            return cell;
        }
        
        else{
            ////ComNSLog(@"subcategoria pentru tabel secundar %@", [Subcategorie  objectAtIndex:row]); //good
//            static NSString *CellIdentifier = @"GenericCell";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//            }
//            cell.textLabel.textColor =[UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1];
//            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            NSDictionary *temp1 = [Subcategorie  objectAtIndex:row];
            //   const char* className = class_getName([[Subcategorie  objectAtIndex:row] class]);
            //   ////ComNSLog(@"yourObject is a: %s and content is %@", className, temp1);
            //   ////ComNSLog(@"vezi aici id  %@", [temp1 objectForKey:@"id"]);
            //   ////ComNSLog(@"vezi aici nr %@", [temp1 objectForKey:@"nume"]);
            NSString *subcategorieSelected =[NSString stringWithFormat:@"%@", [temp1 objectForKey:@"selected"]];
            //adauga bifa
            NSString *filtru_subcategorii_obiective = [NSString stringWithFormat:@"%@",[temp1 objectForKey:@"nume"]];
//            cell.textLabel.text = filtru_subcategorii_obiective;
//            

//            [cell addSubview:BifaObiective];
            static NSString *CellIdentifier = @"SimpleCheckTableViewCell";
            
            SimpleCheckTableViewCell *cell = (SimpleCheckTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SimpleCheckTableViewCell" owner:self options:nil];
                for (id currentObject in topLevelObjects){
                    if ([currentObject isKindOfClass:[UITableViewCell class]]){
                        cell =  (SimpleCheckTableViewCell *) currentObject;
                        break;
                    }
                }
            }
            [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
            [cell.textTitle setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
            cell.textTitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];

//            [cell.labelToate setFont:[UIFont fontWithName:@"OpenSans-Light" size:11.0f]];
            cell.textTitle.text = filtru_subcategorii_obiective;
//            [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
            // verifica daca exista bife pe pensiuni si pune bifa pe selectate
//            NSString *RANDBIFAT =[ NSString stringWithFormat:@"%i", row];
//            //ComNSLog(@"stelepensiuni---%@",StelePensiuni);
//            //ComNSLog(@"RANDBIFAT---%@",RANDBIFAT);
//            //ComNSLog(@"contains---%d", [StelePensiuni containsObject:RANDBIFAT]);
            //SCOATE VALOARE DIN ARRAY 0,1,2 -stele

            if([subcategorieSelected isEqualToString:@"1"]) {
                cell.cehckImage.hidden=NO;
                 cell.textTitle.textColor = [UIColor colorWithRed:175/255.0f green:207/255.0f blue:69/255.0f alpha:1];
                
            } else {
                //ComNSLog(@"set hidden");
                cell.textTitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
                cell.cehckImage.hidden=YES;
            }
            UIView * separatorView;
            for(UIView * mView in cell.contentView.subviews){
                if(mView.tag == 666){
                    [mView removeFromSuperview];
                }
            }
            
            separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,50 - 0.5 , cell.frame.size.width, 0.5)];
            [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
            [separatorView setTag:666];
            separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:separatorView];
            

            return cell;
        }

    }
    
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
//    cell.textLabel.backgroundColor =[UIColor clearColor];
//    cell.textLabel.textColor = [UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1] ;
    
    
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    long ROWSelectat =indexPath.row;
    ////ComNSLog(@"aici pensiuni %ld",ROWSelectat);
    
    if(tableView==FiltrePensiuni){
         SimpleCheckTableViewCell *cell =(SimpleCheckTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
           
        //nsuserdef
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        SELECTIEStelePensiuni = [(NSMutableArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
        int deselect = indexPath.row;//button.tag -100 ;
        if( cell.cehckImage.hidden==NO) {
            [cell.cehckImage setHidden:YES];
             cell.textTitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            NSString *DESEL =[ NSString stringWithFormat:@"%i", deselect];
            //SCOATE VALOARE DIN ARRAY 0,1,2 -stele
            if ([SELECTIEStelePensiuni containsObject:DESEL]) {
                [SELECTIEStelePensiuni removeObject:DESEL];
                [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        } else {
           cell.cehckImage.hidden=NO;
           cell.textTitle.textColor = [UIColor colorWithRed:175/255.0f green:207/255.0f blue:69/255.0f alpha:1];
            NSString *DESEL =[ NSString stringWithFormat:@"%i", deselect];
            if (![SELECTIEStelePensiuni containsObject:DESEL]) {
                [SELECTIEStelePensiuni addObject:DESEL];
                [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
           
        }
       
        [self switchPensiuni];
//        UIView *backgroundView = [[UIView alloc] init];
//        [backgroundView setBackgroundColor:[UIColor clearColor]];
//        [cell setSelectedBackgroundView:backgroundView];
        [FiltrePensiuni deselectRowAtIndexPath:indexPath animated:NO];
    }
    if(tableView==FiltreObiective){
        Subcategorie =[[TitluriFiltreObiective objectAtIndex:ROWSelectat][1] mutableCopy];
        NSString *textsecundar =[NSString stringWithFormat:@"%@",[TitluriFiltreObiective objectAtIndex:ROWSelectat][0]];
        titluCategorieinViewSubcategorie.text = [NSString stringWithFormat:@"Obiective %@",[textsecundar lowercaseString]];
//       TITLUECRANSUBCATEGORII.text =[NSString stringWithFormat:@"Obiective %@",[textsecundar lowercaseString]];
//        titluCategorieinViewSubcategorie.text = [NSString stringWithFormat:@"%@",textsecundar];
        TITLUECRANSUBCATEGORII.text =[NSString stringWithFormat:@"%@",textsecundar];
      
//        [butonBackCategorii setTitle:textsecundar forState:UIControlStateNormal];
//        [butonBackCategorii setTitle:textsecundar forState:UIControlStateSelected];
//        [butonBackCategorii sizeToFit];
//        butonBackCategorii.titleLabel.adjustsFontSizeToFitWidth =TRUE;
//        [butonBackCategorii setNeedsDisplay];
        //this one is bad
        [[self SubcategoriiObiective] setFrame:CGRectMake(SubcategoriiObiective.frame.origin.x,0, SubcategoriiObiective.frame.size.width, 50 *Subcategorie.count)];
                [[self subcategoriiView] setFrame:CGRectMake(0, 0, self.view.bounds.size.width,CGRectGetMaxY(self.SubcategoriiObiective.frame) + 25)];
        [self.SubcategoriiObiective setNeedsDisplay];
        [SubcategoriiObiective setNeedsLayout];
        [SubcategoriiObiective setNeedsDisplay];
        [self.SmallScroll addSubview:titluCategorieinViewSubcategorie];
        
        titluCategorieinViewSubcategorie.frame = CGRectMake(15,0, titluCategorieinViewSubcategorie.frame.size.width,titluCategorieinViewSubcategorie.frame.size.height);
        SubcategoriiObiective.frame = CGRectMake( SubcategoriiObiective.frame.origin.x,titluCategorieinViewSubcategorie.frame.origin.y +42, SubcategoriiObiective.frame.size.width,SubcategoriiObiective.frame.size.height);
        
        [self.SmallScroll addSubview:self.subcategoriiView];
        [self.SmallScroll addSubview:titluCategorieinViewSubcategorie];
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
            //DO Portrait
            [SmallScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width,titluCategorieinViewSubcategorie.frame.origin.y + titluCategorieinViewSubcategorie.frame.size.height+ SubcategoriiObiective.frame.origin.y + SubcategoriiObiective.frame.size.height +25)];
               }else{
            //DO Landscape
          [SmallScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, titluCategorieinViewSubcategorie.frame.origin.y + titluCategorieinViewSubcategorie.frame.size.height+ SubcategoriiObiective.frame.origin.y + SubcategoriiObiective.frame.size.height+25)];
        }
        
     [secondView addSubview:SmallScroll];

    
        //some tricks
         CGRect frame = secondView.frame;
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat height = CGRectGetHeight(self.view.bounds);
        frame.size.width = width;
        frame.size.height = height;
        frame.origin.x = width;
          [secondView setFrame:frame];
          frame.origin.x = 0;
       
        [UIView animateWithDuration:0.3
                              delay:0.5
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                               [secondView setFrame:frame];
                             [self.view addSubview:secondView];
                             [self.view bringSubviewToFront:secondView];
                             [secondView setFrame:frame];
                            
                         }completion:^(BOOL finished){
                              self.BigScroll.hidden=YES;
                         }];

        
        

        
        RandObiectiv = ROWSelectat;
        [SubcategoriiObiective reloadData];
         [FiltreObiective reloadData];
               NSArray *subtemp = [[NSArray alloc]init];
        subtemp =  [TitluriFiltreObiective objectAtIndex:RandObiectiv][1];
        
        NSMutableArray *cateSelectate = [[NSMutableArray alloc]init];
        for(int i=0;i<[[TitluriFiltreObiective objectAtIndex:RandObiectiv][1] count];i++) {
            NSDictionary *temp4 =[[TitluriFiltreObiective objectAtIndex:RandObiectiv][1] objectAtIndex:i];
            NSString *filtru_selected = [NSString stringWithFormat:@"%@",[temp4 objectForKey:@"selected"]];
            if([filtru_selected isEqualToString:@"1"]) {
                [cateSelectate addObject:temp4];
            }
        }
        
        if(cateSelectate.count == subtemp.count) {
            
            UIImage *buttonBackground = [UIImage imageNamed:@"nimic-btn.png"];
            totsaunimic.titleLabel.text=@"nimic-btn.png";
            totsaunimic.titleLabel.hidden=YES;
            [totsaunimic setBackgroundImage:buttonBackground forState:UIControlStateNormal];
            [totsaunimic setNeedsDisplay];
            
        } else  if(cateSelectate.count < subtemp.count) {
            UIImage *buttonBackground = [UIImage imageNamed:@"tot-btn.png"];
            totsaunimic.titleLabel.text=@"tot-btn.png";
            totsaunimic.titleLabel.hidden=YES;
            [totsaunimic setBackgroundImage:buttonBackground forState:UIControlStateNormal];
            [totsaunimic setNeedsDisplay];
            
        }
        
        
      

        
    }
    if(tableView==SubcategoriiObiective){
        
        //ComNSLog(@"you're here and is ok");
        
        ////ComNSLog(@"daaaa %@", [Subcategorie objectAtIndex:ROWSelectat]); //good
//        UIButton *button = (UIButton *)[self.view viewWithTag:ROWSelectat +300];
//        //   int deselect = button.tag -300 ;
//        ////ComNSLog(@"suntem in selectul bussss  %ld", RandObiectiv);
        
        
        SimpleCheckTableViewCell *cell =(SimpleCheckTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if( cell.cehckImage.hidden ==NO) {
            //SCOATE select din dictionar si updateaza valoare
             NSMutableDictionary *SCHIMBASELECT =[[Subcategorie objectAtIndex:ROWSelectat] mutableCopy];
            [SCHIMBASELECT setValue:@"0" forKey:@"selected"];
            NSMutableArray *TEMPSub = [[NSMutableArray alloc]init];
            TEMPSub = [NSMutableArray  arrayWithArray:Subcategorie];
            [TEMPSub replaceObjectAtIndex:ROWSelectat withObject:SCHIMBASELECT];
            Subcategorie =TEMPSub;
            //this bug  TitluriFiltreObiective e nsarray -> nsmutablearray
        //  //ComNSLog(@"am ajuns aici 1");
            NSMutableArray* TEMPfo = [[NSMutableArray alloc] initWithArray:TitluriFiltreObiective
                                      ];
            [[TEMPfo objectAtIndex:RandObiectiv][1]replaceObjectAtIndex:ROWSelectat withObject:SCHIMBASELECT];
            TitluriFiltreObiective = TEMPfo;
            [self.SubcategoriiObiective reloadData];
            [self.FiltreObiective reloadData];
            cell.cehckImage.hidden=YES;
             cell.textTitle.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
            ////////refresh la buton
            [self SchimbaTotsauNimic];
            //   [self UserTitluriFiltreObiectiveAppDelegate];
        } else {
            cell.cehckImage.hidden=NO;
            NSMutableDictionary *SCHIMBASELECT =[[Subcategorie objectAtIndex:ROWSelectat] mutableCopy];
            [SCHIMBASELECT setValue:@"1" forKey:@"selected"];
            //  [Subcategorie replaceObjectAtIndex:ROWSelectat withObject:SCHIMBASELECT];
            NSMutableArray *TEMPSub = [[NSMutableArray alloc]init];
            TEMPSub = [NSMutableArray  arrayWithArray:Subcategorie];
            [TEMPSub replaceObjectAtIndex:ROWSelectat withObject:SCHIMBASELECT];
            Subcategorie =TEMPSub;
         // //ComNSLog(@"am ajuns aici 2");
            NSMutableArray* TEMPfo = [[NSMutableArray alloc] initWithArray:TitluriFiltreObiective
                                      ];
            [[TEMPfo objectAtIndex:RandObiectiv][1]replaceObjectAtIndex:ROWSelectat withObject:SCHIMBASELECT];
            TitluriFiltreObiective = TEMPfo;
            
            [self.SubcategoriiObiective reloadData];
            [self.FiltreObiective reloadData];
            ////////refresh la buton
            cell.textTitle.textColor = [UIColor colorWithRed:175/255.0f green:207/255.0f blue:69/255.0f alpha:1];
            [self SchimbaTotsauNimic];
        }
    }
}
///////////// PENSIUNI /////////////
//verifica daca are bifate pensiuni sau nu  // default e on
-(void)switchPensiuni {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    SELECTIEStelePensiuni = [(NSArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
    //ComNSLog(@"selectie stele pensiuni---%@", SELECTIEStelePensiuni);
    if(SELECTIEStelePensiuni.count ==0 && salveaza == NO) {
        
//        pensiuniOnOff.on=false;
//        [self ascundeFiltrePensiuni];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        ////ComNSLog(@"CopieSELECTIEStelePensiuni %@",CopieSELECTIEStelePensiuni);
        
        for(int i=0; i<6;i++) {
            NSString *strsimplu = [NSString stringWithFormat:@"%i", i];
            [SELECTIEStelePensiuni addObject:strsimplu];
        }
        [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [FiltrePensiuni reloadData];
        //pensiuniOnOff.on=true;
        //[self arataFiltrePensiuni];
    } else {
        salveaza = NO;
        if(SELECTIEStelePensiuni.count == 0){
            
          pensiuniOnOff.selected=NO;
        [self ascundeFiltrePensiuni];
           
        }
        else{
            pensiuniOnOff.selected=YES;
            [self arataFiltrePensiuni];
        }

    }
}

-(void)switchObiective {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *areObiective = [NSString stringWithFormat:@"%@",[defaults objectForKey:@"ObiectiveOn.Cazare.ro"] ] ;
    
    //ComNSLog(@"are obiective---%@",areObiective);


    if([areObiective isEqualToString:@"0"]) {
        //ComNSLog(@"ascunde");
        obiectiveOnOff.selected=NO;
        [self ascundeFiltreObiective];
    } else {
        
        if([areObiective isEqualToString:@"1"]){
            //ComNSLog(@"arata");
            obiectiveOnOff.selected=YES;
            [self arataFiltreObiective];
        }
        else{
            //ComNSLog(@"ascunde");
            obiectiveOnOff.selected=NO;
            [self ascundeFiltreObiective];
        }

    }

}
//selecteaza switch OBIECTIVE on /off //alerta daca selecteaza  off
-(IBAction)OBIECTIVEOnOffSwitch:(id)sender {
    obiectiveOnOff.selected =! obiectiveOnOff.selected;
    if(obiectiveOnOff.selected==NO) {
        CGRect frame=self.FiltreObiective.frame;
        frame.origin.x=self.FiltreObiective.frame.origin.x;
        frame.size.height =0;
         [UIView animateWithDuration:1.0f animations:^{
            FiltreObiective.frame = frame ;
         
        }
                         completion:^(BOOL finished){
                             [self.FiltreObiective setNeedsDisplay];
                             [self ascundeFiltreObiective];
                         }];

     //   [self ascundeFiltreObiective]; ANIMATE TO 0
        
        
    } else {
        obiectiveOnOff.selected=YES;
        CGRect frame=self.FiltreObiective.frame;
        frame.origin.x=self.FiltreObiective.frame.origin.x;
        frame.size.height =self.TitluriFiltreObiective.count *50;
        [UIView animateWithDuration:1.0f animations:^{
            FiltreObiective.frame = frame ;
            
        }
                         completion:^(BOOL finished){
                             [self.FiltreObiective setNeedsDisplay];
                             [self arataFiltreObiective];
                         }];
   //     [self arataFiltreObiective]; ANIMATE TO FRAME HEIGHT
        
    }
}

//selecteaza switch pensiuni on /off //alerta daca selecteaza  off
-(IBAction)pensiuniOnOffSwitch:(id)sender {
    pensiuniOnOff.selected =! pensiuniOnOff.selected;
    //ComNSLog(@"taped");
    if(pensiuniOnOff.selected==NO) {
        [self ascundeFiltrePensiuni];

    } else {
        pensiuniOnOff.selected=YES;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        SELECTIEStelePensiuni = [(NSArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
        //ComNSLog(@"selectie stele pensiuni---%@", SELECTIEStelePensiuni);
        if(SELECTIEStelePensiuni.count ==0) {
            
            //        pensiuniOnOff.on=false;
            //        [self ascundeFiltrePensiuni];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            ////ComNSLog(@"CopieSELECTIEStelePensiuni %@",CopieSELECTIEStelePensiuni);
            
            for(int i=0; i<6;i++) {
                NSString *strsimplu = [NSString stringWithFormat:@"%i", i];
                [SELECTIEStelePensiuni addObject:strsimplu];
            }
            [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [FiltrePensiuni reloadData];
            //pensiuniOnOff.on=true;
            //[self arataFiltrePensiuni];
        }
      [self arataFiltrePensiuni];
    }
}
//apasa  da sau nu in alerta //  dezactiveaza switch off
-(void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == TAG_ALERTA_PENSIUNI && buttonIndex == 1) {
        //A APASAT OK si dezactivam toate pensiunile
        ////ComNSLog(@"da");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        SELECTIEStelePensiuni = [(NSMutableArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
        [SELECTIEStelePensiuni removeAllObjects];
        [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        pensiuniOnOff.selected =NO;
        ////ComNSLog(@"curatate %@", SELECTIEStelePensiuni);
        [FiltrePensiuni reloadData];
        // ascunde view de pret
        [ self ascundeFiltrePensiuni];
      
        
    } else if (alertView.tag == TAG_ALERTA_PENSIUNI && buttonIndex == 0){
        //nu face nimic
        ////ComNSLog(@"nu");
       pensiuniOnOff.selected =YES;
     [ self arataFiltrePensiuni];
      
        [self.view bringSubviewToFront:VctrDtl];
    }
    if (alertView.tag == TAG_ALERTA_OBIECTIVE && buttonIndex == 1) {
        //A APASAT OK si dezactivam toate pensiunile
        ////ComNSLog(@"da");
        obiectiveOnOff.selected =NO;
         FiltreObiective.userInteractionEnabled =NO;
        
        ////ComNSLog(@"curatate %@", SELECTIEStelePensiuni);
        [FiltrePensiuni reloadData];
    } else if (alertView.tag == TAG_ALERTA_OBIECTIVE && buttonIndex == 0){
        //nu face nimic
        ////ComNSLog(@"nu");
        obiectiveOnOff.selected =YES;
         FiltreObiective.userInteractionEnabled =YES;
    }

    
    
}
-(void)mesajAlerta:(NSString*)mAlerta titluAlerta:(NSString*)tAlerta {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tAlerta
                                                    message:mAlerta
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void)SchimbaTotsauNimic{
    ////////refresh la buton
    NSArray *subtemp = [[NSArray alloc]init];
    subtemp =  [TitluriFiltreObiective objectAtIndex:RandObiectiv][1];
    
    NSMutableArray *cateSelectate = [[NSMutableArray alloc]init];
    for(int i=0;i<[[TitluriFiltreObiective objectAtIndex:RandObiectiv][1] count];i++) {
        NSDictionary *temp4 =[[TitluriFiltreObiective objectAtIndex:RandObiectiv][1] objectAtIndex:i];
        NSString *filtru_selected = [NSString stringWithFormat:@"%@",[temp4 objectForKey:@"selected"]];
        if([filtru_selected isEqualToString:@"1"]) {
            [cateSelectate addObject:temp4];
        }
    }
    
    if(cateSelectate.count == subtemp.count) {
        UIImage *buttonBackground = [UIImage imageNamed:@"nimic-btn.png"];
        totsaunimic.titleLabel.text=@"nimic-btn.png";
        totsaunimic.titleLabel.hidden=YES;
        [totsaunimic setBackgroundImage:buttonBackground forState:UIControlStateNormal];
        [totsaunimic setNeedsDisplay];
        
    } else  if(cateSelectate.count < subtemp.count) {
        UIImage *buttonBackground = [UIImage imageNamed:@"tot-btn.png"];
        totsaunimic.titleLabel.text=@"tot-btn.png";
        totsaunimic.titleLabel.hidden=YES;
        [totsaunimic setBackgroundImage:buttonBackground forState:UIControlStateNormal];
        [totsaunimic setNeedsDisplay];
        
    }
    // [self UserTitluriFiltreObiectiveAppDelegate];
}
-(void)UserTitluriFiltreObiectiveAppDelegate{
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelGlobal.UserTitluriFiltreObiective= TitluriFiltreObiective;
}
-(void)excludeCategorii {
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    globalExcludedSubcats = [[NSMutableArray alloc]init];
   
    for(int i=0; i< TitluriFiltreObiective.count;i++){
       //ComNSLog(@"TitluriFiltreObiective.count %@",TitluriFiltreObiective[i][1]);
        NSMutableArray *filtre_categorii_obiective = TitluriFiltreObiective[i][1] ;
        for(int i=0; i< filtre_categorii_obiective.count; i++) {
            NSDictionary *temp1 = filtre_categorii_obiective[i];
            NSString *filtru_categorii_obiective = [NSString stringWithFormat:@"%@",[temp1 objectForKey:@"selected"]];
            NSString *filtru_categorii_id = [NSString stringWithFormat:@"%@",[temp1 objectForKey:@"id"]];
            if([filtru_categorii_obiective isEqualToString:@"0"]) {
                        [globalExcludedSubcats addObject:filtru_categorii_id];
           }
        }
    }
    appDelGlobal.globalExcludedSubcats = self.globalExcludedSubcats;

}
-(NSString*) stringPentruServer {
  AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSMutableArray *SELECTIEStelePensiuniFINAL = [(NSMutableArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
    NSString *STELESTRING = [[NSString alloc] init];
    if(SELECTIEStelePensiuniFINAL.count !=0) {
    STELESTRING = [NSString stringWithFormat:@"&stele=%@", [SELECTIEStelePensiuniFINAL componentsJoinedByString:@","]];
    } else if(SELECTIEStelePensiuniFINAL.count ==0) {
        STELESTRING =@"";
    }
    NSMutableArray *EXCLUSEFINAL = appDelGlobal.globalExcludedSubcats;
    //ComNSLog(@"EXCLUSEFINAL %lu", (unsigned long)EXCLUSEFINAL.count);
    NSString *CATEGORIISTRING = [[NSString alloc] init];
    if(EXCLUSEFINAL.count !=0) {
        CATEGORIISTRING = [NSString stringWithFormat:@"&faraCategorii=%@", [EXCLUSEFINAL componentsJoinedByString:@","]];
    } else  if(EXCLUSEFINAL.count ==0) {
        CATEGORIISTRING =@"";
    }
    //ComNSLog(@"CATEGORIISTRING %@",CATEGORIISTRING);
      NSString *stringfinalSERVER = @"";
    NSString *PRETMIN =   [NSString stringWithFormat:@"&pretMin=%@",[appDelGlobal.userPreturi objectForKey:@"pretMin"]];
    NSString *PRETMAX =   [NSString stringWithFormat:@"&pretMax=%@",[appDelGlobal.userPreturi objectForKey:@"pretMax"]];
  
    if( pensiuniOnOff.selected==YES && obiectiveOnOff.selected==NO )  {
          stringfinalSERVER = [NSString stringWithFormat:@"%@%@%@", STELESTRING,PRETMIN,PRETMAX];
    } else if( pensiuniOnOff.selected==NO && obiectiveOnOff.selected==YES) {
        stringfinalSERVER = [NSString stringWithFormat:@"%@", CATEGORIISTRING];
    } else if( pensiuniOnOff.selected==YES && obiectiveOnOff.selected==YES) {
      stringfinalSERVER = [NSString stringWithFormat:@"%@%@%@%@", STELESTRING,CATEGORIISTRING,PRETMIN,PRETMAX];
    }
     //ComNSLog(@"stringfinalSERVER %@", stringfinalSERVER);
    appDelGlobal.stringPentruServer= stringfinalSERVER;
    [defaults setObject:stringfinalSERVER forKey:@"StringFinalServer.Cazare.ro"];
    [defaults synchronize];
    return stringfinalSERVER;
}
// __block id SELFINBLOCK = self; -> referinta pentru self inside block
-(void) ascundeFiltrePensiuni {
    CGRect frame=self.FiltrePensiuni.frame;
    frame.origin.x=self.FiltrePensiuni.frame.origin.x;
    frame.size.height =0;
       __block id SELFINBLOCK = self;
    [UIView animateWithDuration:1.0f animations:^{
        FiltrePensiuni.frame = frame ;
//        [self.FiltrePensiuni setAlpha:0];
    }
                     completion:^(BOOL finished){
                         // your code
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         SELECTIEStelePensiuni = [(NSMutableArray*)[defaults objectForKey:@"StelePensiuni.Cazare.ro"] mutableCopy];
                         [SELECTIEStelePensiuni removeAllObjects];
                         [defaults setObject:SELECTIEStelePensiuni forKey:@"StelePensiuni.Cazare.ro"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
                         pensiuniOnOff.selected =NO;
                         [FiltrePensiuni reloadData];
                         VctrDtl.hidden=TRUE;
                         pretulMinim.hidden=TRUE;
                         pretulMaxim.hidden=TRUE;
                         pretNoapte.hidden=TRUE;
                         stele.hidden=TRUE;
                        [SELFINBLOCK duTabelObiectiveSus];
                     }];

    
   
}
-(void) arataFiltrePensiuni {

    CGRect frame=self.FiltrePensiuni.frame;
    frame.origin.x=self.FiltrePensiuni.frame.origin.x;
    frame.size.height =TitluriFiltrePensiuni.count *50;
      __block id SELFINBLOCK = self;
    [SELFINBLOCK duTabelObiectiveJos];

     [UIView animateWithDuration:1.0f animations:^{
        FiltrePensiuni.frame = frame ;
        //        [self.FiltrePensiuni setAlpha:0];
    }
                     completion:^(BOOL finished){
                         // your code
                         VctrDtl.hidden=FALSE;
                         pretulMinim.hidden=FALSE;
                         pretulMaxim.hidden=FALSE;
                         pretNoapte.hidden=FALSE;
                         stele.hidden=FALSE;
                                                }];

}
-(void) duTabelObiectiveJos {
    if(obiectiveOnOff.selected!=FALSE) {
    //  Tabelul   FiltreObiective cu switch si label  se muta jos
    [[self labelObiective] setFrame:CGRectMake(labelObiective.frame.origin.x,560, labelObiective.frame.size.width,  labelObiective.frame.size.height)];
    [[self obiectiveOnOff] setFrame:CGRectMake(obiectiveOnOff.frame.origin.x,569, obiectiveOnOff.frame.size.width,  obiectiveOnOff.frame.size.height)];
    [[self FiltreObiective] setFrame:CGRectMake(FiltreObiective.frame.origin.x,633, FiltreObiective.frame.size.width, 50*TitluriFiltreObiective.count)];
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
            //DO Portrait
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
        }else{
            //DO Landscape
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
            
            
        }
        //ComNSLog(@"filtreobiective   %@", NSStringFromCGRect(FiltreObiective.frame));
        //ComNSLog(@"big scroll:   %@", NSStringFromCGSize(self.BigScroll.contentSize));
     [self.BigScroll setNeedsDisplay];
        
    } else {
        CGRect frame = self.FiltreObiective.frame;
        frame.size.height = 0;
        frame.origin.y = 633;
        [self.FiltreObiective setFrame:frame];
        [self.FiltreObiective setNeedsDisplay];
        [[self labelObiective] setFrame:CGRectMake(labelObiective.frame.origin.x,560, labelObiective.frame.size.width,  labelObiective.frame.size.height)];
        [[self obiectiveOnOff] setFrame:CGRectMake(obiectiveOnOff.frame.origin.x,569, obiectiveOnOff.frame.size.width,  obiectiveOnOff.frame.size.height)];
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
            //DO Portrait
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
        }else{
            //DO Landscape
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
            
            
        }

         //ComNSLog(@"filtreobiective   %@", NSStringFromCGRect(FiltreObiective.frame));
        //ComNSLog(@"big scroll:   %@", NSStringFromCGSize(self.BigScroll.contentSize));
        [self.BigScroll setNeedsDisplay];

    }
}

-(void) duTabelObiectiveSus{
    if(obiectiveOnOff.selected!=FALSE) {
    //  Tabelul   FiltreObiective cu switch si label  se muta sus
    [[self labelObiective] setFrame:CGRectMake(labelObiective.frame.origin.x,100, labelObiective.frame.size.width,  labelObiective.frame.size.height)];
    [[self obiectiveOnOff] setFrame:CGRectMake(obiectiveOnOff.frame.origin.x,109, obiectiveOnOff.frame.size.width,  obiectiveOnOff.frame.size.height)];
      [[self FiltreObiective] setFrame:CGRectMake(FiltreObiective.frame.origin.x,172, FiltreObiective.frame.size.width, 50*TitluriFiltreObiective.count)];
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
            //DO Portrait
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
        }else{
            //DO Landscape
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
            
            
        }

      [self.BigScroll setNeedsDisplay];
    } else {
        CGRect frame = self.FiltreObiective.frame;
        frame.size.height = 0;
        [self.FiltreObiective setFrame:frame];
        [self.FiltreObiective setNeedsDisplay];
        [[self labelObiective] setFrame:CGRectMake(labelObiective.frame.origin.x,100, labelObiective.frame.size.width,  labelObiective.frame.size.height)];
        [[self obiectiveOnOff] setFrame:CGRectMake(obiectiveOnOff.frame.origin.x,109, obiectiveOnOff.frame.size.width,  obiectiveOnOff.frame.size.height)];
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
            //DO Portrait
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
        }else{
            //DO Landscape
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
            
            
        }

        [self.BigScroll setNeedsDisplay];
    }
}

-(void) ascundeFiltreObiective {
    
    if(pensiuniOnOff.selected==NO) {
        [self duTabelObiectiveSus];
    }else {
     [self duTabelObiectiveJos];
    }
    [self.FiltreObiective setNeedsDisplay];

  
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
        //DO Portrait
        [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
    }else{
        //DO Landscape
        [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
        
        
    }

    [self.BigScroll setNeedsDisplay];
}
-(void) arataFiltreObiective {
    if(pensiuniOnOff.selected==NO) {
        [self duTabelObiectiveSus];
   
                             [self.FiltreObiective setNeedsDisplay];
       
     
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
            //DO Portrait
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
        }else{
            //DO Landscape
            [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
            
            
        }

        [self.BigScroll setNeedsDisplay];
        } else {
        [self duTabelObiectiveJos];
            CGRect frame = self.FiltreObiective.frame;
            frame.size.height = self.TitluriFiltreObiective.count *50;
            [self.FiltreObiective setFrame:frame];
            [self.FiltreObiective setNeedsDisplay];
          
            if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
                //DO Portrait
                [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35 )];
            }else{
                //DO Landscape
                [BigScroll setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, FiltreObiective.frame.origin.y + FiltreObiective.frame.size.height+35)];
                
                
            }

            [self.BigScroll setNeedsDisplay];
    }
    self.FiltreObiective.hidden =NO;
   
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

@end
//garbage
//nimic-btn.png tot-btn.png
//        [controller describeDictionary:filtre_categorii_obiective];
//sageata-categ_j.png
// ////ComNSLog(@"vezi aici id  %@", [FiltruObiectiv objectForKey:@"id"]);
//  ////ComNSLog(@"vezi aici nr %@", [FiltruObiectiv objectForKey:@"nr"]);
// ////ComNSLog(@"vezi aici  nume %@", [FiltruObiectiv objectForKey:@"nume"]);

//        for (id item in filtre_categorii_obiective) {
//            //   if the item is NSDictionary (in this case ... different json file will probably have a different class)
//
//            [TitluriFiltreObiective addObject:item ];
//         // [SubcategoriiFiltreObiective addObject:[item objectForKey:@"nume" ] objectForKey:@"subcategorii"]];
//        }
//
//        ////ComNSLog(@"TitluriFiltreObiective...0. %@", [TitluriFiltreObiective objectForKey:@"nume"]);
//        ////ComNSLog(@"%s",__func__);
//        ////ComNSLog(@"subcat...0. %@", [TitluriFiltreObiective[0]objectForKey:@"subcategorii"]);
// ////ComNSLog(@"subcategorii finale 0 %@", SubcategoriiFiltreObiective[0]);

//   NSArray *subcategorii = (NSArray *) [filtre_categorii_obiective objectForKey:@"subcategorii" ];
//      //  NSArray *subcategorii = (NSArray *) [filtre_categorii_obiective objectForKey:@"subcategorii" ];
//
//           ////ComNSLog(@"subcategoriie  %@", subcategorii);
//        NSArray *items = (NSArray *) [[[[toatefiltrele objectForKey:@"results" ] objectForKey:@"filtre"]objectForKey:@"obiective"]objectForKey:@"categorii"] ;

// reading all the items in the array one by one
// incarca   toateRezultatele
//        {
//            id = 5;
//            nr = 22;
//            nume = Agrement;
//            subcategorii =                         (
//                                                    {
//                                                        id = 54;
//                                                        nume = Agrement;
//                                                        selected = 1;
//                                                    },
//                                                    {
//                                                        id = 59;
//                                                        nume = Aquapark;
//                                                        selected = 1;
//                                                    },
//                                                    {
//                                                        id = 71;
//                                                        nume = Aventura;
//                                                        selected = 1;
//                                                    },
//        TitluriFiltreObiective =[[NSMutableArray alloc]init];
//        for (id item in items) {
//            // if the item is NSDictionary (in this case ... different json file will probably have a different class)
//            //    ////ComNSLog(@"ITEM multe.... %@", item);
//            [TitluriFiltreObiective addObject:item];
//        }
//        ////ComNSLog(@"%s",__func__);
//          ////ComNSLog(@"titlu categorii obiective %@", TitluriFiltreObiective[0]);


//        id = 5;
//        nr = 22;
//        nume = Agrement;

// [self.table reloadData];



//pret minim maxim
// 2 filtre_pret_pensiuni
//        NSDictionary *filtre_pret_pensiuni = [[[toatefiltrele objectForKey:@"results" ] objectForKey:@"filtre"]objectForKey:@"pensiuni"] ;
//        ////ComNSLog(@"filtre pret %@", filtre_pret_pensiuni);
//        // [b_values addObject:[product valueForKey:@"filtre"]];
//        // 3 tip suma
//        NSDictionary *tipsuma = [[toatefiltrele objectForKey:@"results" ] objectForKey:@"tipSuma"] ;
//        ////ComNSLog(@"filtre tip suma  %@", tipsuma);
//
//////ComNSLog(@"filtre %@", b_values);

//const char* className = class_getName([filtre_categorii_obiective[i] class]);
////ComNSLog(@"yourObject is a: %s and content is %@", className, temp1);

/////  Subcategorie =FiltruObiectiv; //pune in array toate dictionarele
//perfect     ////ComNSLog(@"vezi aici id  %@", Subcategorie);
/* for(int i=0; i< FiltruObiectiv.count; i++) {
 NSDictionary *temp1 = FiltruObiectiv[i];
 const char* className = class_getName([FiltruObiectiv[i] class]);
 ////ComNSLog(@"subcateg yourObject is a: %s and content is %@", className, temp1);
 //            ////ComNSLog(@"vezi aici id  %@", [temp1 objectForKey:@"id"]);
 //            ////ComNSLog(@"vezi aici nr %@", [temp1 objectForKey:@"nume"]);
 //            ////ComNSLog(@"vezi aici  nume %@", [temp1 objectForKey:@"selected"]);
 [Subcategorie addObject: temp1];
 }*/

////ComNSLog(@"tabel%@", [NSValue valueWithCGRect:SubcategoriiObiective.frame]);
////ComNSLog(@"scroll %@ content size %@", [NSValue valueWithCGRect:SmallScroll.frame], NSStringFromCGSize(SmallScroll.contentSize));


////ComNSLog(@"subcategoria pentru tabel secundar %@", Subcategorie[0]); //good
// [self.navigationController presentModalViewController:subcategoriiView animated:YES];
// [self.navigationController presentModalViewController:subxR3 animated:YES];
//  ////ComNSLog(@"subcategoria pentru tabel secundar %@", Subcategorie[0]); //good
//   ////ComNSLog(@"vezi aici  nume %@", [FiltruObiectiv objectForKey:@"nume"]);

//pensiuni =             {
//        moneda = RON;
//        pretMax = 690;
//        pretMin = 25;
//        rangeMax = 690;
//        rangeMin = 25;
//    };

//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Atentie"
//                              message:@"Esti sigur ca nu doresti sa vizualizezi pensiuni?"
//                              delegate:self
//                              cancelButtonTitle:@"Nu"
//                              otherButtonTitles:@"Da", nil];
//        alert.tag = TAG_ALERTA_PENSIUNI;
//        [alert show];


//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Atentie"
//                              message:@"Esti sigur ca nu doresti sa vizualizezi obiective?"
//                              delegate:self
//                              cancelButtonTitle:@"Nu"
//                              otherButtonTitles:@"Da", nil];
//        alert.tag = TAG_ALERTA_OBIECTIVE;
//        [alert show];
