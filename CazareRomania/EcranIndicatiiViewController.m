//
//  EcranIndicatiiViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 21/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranIndicatiiViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IndicationTableViewCell.h"
#import "AppDelegate.h"
#import "EcranLocalizareViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface EcranIndicatiiViewController ()

@end

@implementation EcranIndicatiiViewController
@synthesize backView, backButton, backLabel, indications, mainScrollView, printButton,indicationsArray,stringEndRuta,TITLUECRAN;

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
    
//    [indications setScrollEnabled:YES];
    
    [mainScrollView setScrollsToTop:YES];
    [indications setScrollsToTop:NO];
    
    [mainScrollView setBounces:YES];
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
   printButton.layer.cornerRadius = 5.0;
   printButton.layer.borderWidth = 1.0;
//    printButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    printButton.layer.borderColor = [UIColor clearColor].CGColor;
    printButton.layer.masksToBounds = YES;
    

    self.indicationsArray = indicationsArray;
    //    myJson = @{@"indication" :@[@"Mergeti spre vest pe Strada Gheorghe Grigorie Cantacuzino",@"La sensul giratoriu, urmati a treia iesire spre Strada Vlad Tepes pe langa Georgescu Complex(pe partea dreapta)",@"Mergeti spre vest pe Strada Gheorghe Grigorie Cantacuzino",@"Mergeti spre vest pe Strada Gheorghe Grigorie Cantacuzino",@"La sensul giratoriu, urmati a treia iesire spre Strada Vlad Tepes pe langa Georgescu Complex(pe partea dreapta)",@"Mergeti spre vest pe Strada Gheorghe Grigorie Cantacuzino"]};
    //    indicationsArray = myJson[@"indication"];
    
    resizedPaths = [[NSMutableArray alloc] init];
    heightForRow = [[NSMutableArray alloc] init];
    
    CGFloat total = 0.0;
    for(int i=0; i< [indicationsArray count]; i++){
        IndicationTableViewCell * cell;
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IndicationTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (IndicationTableViewCell *) currentObject;
                break;
            }
        }
          UIFont *fonddecalcul =   [UIFont fontWithName:@"OpenSans-Light" size:16.0f];
        
//        CGFloat temp = [self sizeOfText:indicationsArray[i] widthOfTextView:255 withFont:[UIFont systemFontOfSize:13]].height;
          CGFloat temp = [self sizeOfText:indicationsArray[i] widthOfTextView:255 withFont:fonddecalcul].height;
        CGFloat  diff;
        if (temp <20 ) {
            diff = temp *2+20;
        } else {
            diff = temp +20;
        }
         //= (temp - cell.descriptionTextView.frame.size.height) ;
        total += diff;
    }
    
    //ComNSLog(@"total :   %f",total);
    
    [indications setFrame:CGRectMake(indications.frame.origin.x, indications.frame.origin.y, indications.frame.size.width, total+10)];
    
    //ComNSLog(@"indicatii:  %@", NSStringFromCGRect(indications.frame));
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, indications.frame.size.height + indications.frame.origin.y+30)];
        [indications setNeedsDisplay];
    }
    else{
        if([[UIScreen mainScreen] bounds].size.height > 480){
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, indications.frame.size.height + indications.frame.origin.y +30)];
            [indications setNeedsDisplay];
        }
        else{
            [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, indications.frame.size.height + indications.frame.origin.y+30)];
            [indications setNeedsDisplay];
        }
    }
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.stringSursaRuta  = appDelGlobal.startLocatie;
    //ComNSLog(@"appDelGlobal.startLocatie %@",appDelGlobal.startLocatie);
    self.stringEndRuta =appDelGlobal.endLocatie;
    //ComNSLog(@"appDelGlobal.endLocatie %@",appDelGlobal.endLocatie);
    TITLUECRAN.font = [UIFont fontWithName:@"OpenSans" size:21.5f];
 
    backButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    printButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    printButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    printButton.titleLabel.textColor =   [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
   [indications setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

// metode tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //    static NSString *CellIdentifier = @"IndicationTableViewCell";
    
    IndicationTableViewCell *cell = (IndicationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IndicationTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (IndicationTableViewCell *) currentObject;
                break;
            }
        }
    }
    cell.positionLabel.font =[UIFont fontWithName:@"OpenSans-Light" size:17.5f];
    cell.descriptionTextView.font=[UIFont fontWithName:@"OpenSans-Light" size:16.0f];
    cell.descriptionTextView.textColor =[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1] ;
    
    [cell.positionLabel setText:[NSString stringWithFormat:@"%d",indexPath.row +1]];
    [cell.descriptionTextView setText:indicationsArray[indexPath.row]];
    
    if(![resizedPaths containsObject:indexPath]){
        
        UIFont *fonddecalcul =   [UIFont fontWithName:@"OpenSans-Light" size:16.0f];
        cell.descriptionTextView.contentInset = UIEdgeInsetsMake(-8,0,0,0);
        [cell.descriptionTextView setUserInteractionEnabled:NO];
        CGSize size =   [self sizeOfText:cell.descriptionTextView.text widthOfTextView:255 withFont:fonddecalcul];
        cell.descriptionTextView.frame = CGRectMake(40,7,255,size.height);
        [cell.positionLabel setFrame:CGRectMake(cell.positionLabel.frame.origin.x, 10, cell.positionLabel.frame.size.width, cell.positionLabel.frame.size.height)];
        
        
        
    }
    
    UIView * separatorView;
    for(UIView * mView in cell.contentView.subviews){
        if(mView.tag == 666){
            [mView removeFromSuperview];
        }
    }
    
    UIFont *fonddecalcul =   [UIFont fontWithName:@"OpenSans-Light" size:16.0f];
    
    CGFloat temp  =   [self sizeOfText:indicationsArray[indexPath.row] widthOfTextView:255 withFont:fonddecalcul].height;
    
    
    //    //ComNSLog(@"cell at row %f SI SIZEOFTEXT %i",temp, row);
    if (temp <20 ) {
        temp = temp *2+20;
    } else {
        temp = temp +20;
    }
    
    //ComNSLog(@"temp---%f",temp);
    
    separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,temp-0.5 , cell.frame.size.width, 0.5)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
    [separatorView setTag:666];
    
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    
    [cell.contentView addSubview:separatorView];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
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

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize ts = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return ts;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IndicationTableViewCell * cell;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"IndicationTableViewCell" owner:self options:nil];
    for (id currentObject in topLevelObjects){
        if ([currentObject isKindOfClass:[UITableViewCell class]]){
            cell =  (IndicationTableViewCell *) currentObject;
            break;
        }
    }
    
    
    UIFont *fonddecalcul =   [UIFont fontWithName:@"OpenSans-Light" size:16.0f];
    
    CGFloat temp  =   [self sizeOfText:indicationsArray[indexPath.row] widthOfTextView:255 withFont:fonddecalcul].height;
    
    
    //    //ComNSLog(@"cell at row %f SI SIZEOFTEXT %i",temp, row);
    if (temp <20 ) {
        return temp *2+20;
    } else {
        return temp +20;
    }
    
    
    //    CGSize stringSize = [cell.descriptionTextView.text sizeWithFont:fonddecalcul
    //                          constrainedToSize:CGSizeMake(240 ,100)
    //                              lineBreakMode:NSLineBreakByWordWrapping];
    //
    //    return stringSize.height+25;
    //
    //
    //  CGFloat temp = [self sizeOfText:indicationsArray[indexPath.row] widthOfTextView:240 withFont:fonddecalcul].height;
    ////
    //   CGFloat  diff = (temp - cell.descriptionTextView.frame.size.height) ;
    //    //    //ComNSLog(@"diff ----%f", diff);
    //    // pentru ca...
    //    return stringSize.height + diff +10;
    //    return 58;
    
    //    return 100;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [indicationsArray count];
}


-(IBAction)backAction:(UIButton *)sender{
    [self prezintaBack];
}

-(void)prezintaBack{
    if(UIInterfaceOrientationIsPortrait(self.interfaceOrientation)){
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        EcranLocalizareViewController * ecr = [[EcranLocalizareViewController alloc] init];
        ecr.showOverlay = YES;
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
            EcranLocalizareViewController * ecr = [[EcranLocalizareViewController alloc] init];
            ecr.showOverlay = YES;
            [self.navigationController popViewControllerAnimated:NO];
        }
        else{
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [self.view.window.layer addAnimation:transition forKey:nil];
            EcranLocalizareViewController * ecr = [[EcranLocalizareViewController alloc] init];
            ecr.showOverlay = YES;
            [self.navigationController popViewControllerAnimated:NO];
        }
        
    }
    
}



-(IBAction)printAction:(UIButton *)sender{
    NSArray *myArray = [ self.stringSursaRuta componentsSeparatedByString:@","];
    NSString *str = [[NSString alloc]init];
    if(myArray.count !=0) {
        str = [NSString stringWithFormat:@"Indicatii rutiere de la %@ la %@ \n", myArray[0], self.stringEndRuta ];
        //ComNSLog(@"TITLU PRINT %@", str);
    }
    
    for(int i=0; i< [indicationsArray count]; i++){
        str = [str stringByAppendingFormat:@"%d. %@\n",i+1,indicationsArray[i]];
    }
    //ComNSLog(@"str---%@",str);
    
    [self printText:str];
}

-(void)printText:(NSString *)myText{
    UIPrintInteractionController *printCtrl =  [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.jobName = @"InfoTurism - printare indicatii";
    printInfo.orientation = UIPrintInfoOrientationPortrait;
    
    UISimpleTextPrintFormatter *textFormatter = [[UISimpleTextPrintFormatter alloc] initWithText:myText];
    
    [textFormatter setStartPage:1];
    
    [printCtrl setPrintFormatter:textFormatter];
    [printCtrl setShowsPageRange:YES];
    [printCtrl setDelegate:self];
    [printCtrl presentAnimated:YES completionHandler:^(UIPrintInteractionController* printCtrl, BOOL completed, NSError * error){
        
        if(completed){
            //ComNSLog(@"succes");
            
        }
        else{
            //ComNSLog(@"fail");
        }
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
////


@end
