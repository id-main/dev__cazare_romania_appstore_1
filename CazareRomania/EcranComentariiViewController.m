//
//  EcranComentariiViewController.m
//  CazareRomania
//
//  Created by Vasile Croitoru on 12/05/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//

#import "EcranComentariiViewController.h"
#import "CommentTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface EcranComentariiViewController ()

@end

@implementation EcranComentariiViewController

@synthesize commentsTableView, bottomImageView, mainScrollView, backButton, backLabel, backView, nameLabel, nameView, noCommentsView, messageTextView, myJson,commentsArray,messageView, messageText, messageTextParentView, commentsIcon, commentPageTitle, greenBorder,noCommentsTextView,noCommentsParentView;

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
    
    [mainScrollView setScrollsToTop:YES];
    [commentsTableView setScrollsToTop:NO];
    [messageText setScrollsToTop:NO];
    
    [messageText setScrollEnabled:NO];

    
    [commentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Do any additional setup after loading the view from its nib.
//    commentsArray = @[@{@"numeTurist":@"Cristi Iordache",@"data":@"2013-11-23",@"pozitiv":@"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ":@"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist":@"Cristi Iordache",@"data":@"2013-11-23",@"pozitiv": @"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ":@"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist":@"Cristi Iordache",@"data": @"2013-11-23",@"pozitiv":@"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ":@"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist":@"Cristi Iordache",@"data":@"2013-11-23",@"pozitiv":@"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ":@"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist":@"Cristi Iordache",@"data": @"2013-11-23",@"pozitiv": @"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ": @"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist": @"Cristi Iordache",@"data": @"2013-11-23",@"pozitiv": @"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ": @"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist": @"Cristi Iordache",@"data": @"2013-11-23",@"pozitiv": @"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ": @"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist": @"Cristi Iordache",@"data": @"2013-11-23",@"pozitiv": @"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ": @"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist": @"Cristi Iordache",@"data": @"2013-11-23",@"pozitiv": @"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ": @"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist": @"Cristi Iordache",@"data":@"2013-11-23",@"pozitiv":@"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ":@"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist":@"Cristi Iordache",@"data": @"2013-11-23",@"pozitiv":@"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ":@"Comentariu negativ, care poate fi lung si pe mai multe randuri"},@{@"numeTurist":@"Cristi Iordache",@"data":@"2013-11-23",@"pozitiv":@"Comentariu pozitiv, care poate fi lung si pe mai multe randuri",@"negativ":@"Comentariu negativ, care poate fi lung si pe mai multe randuri"}];
    
    
    messageTextParentView.layer.borderWidth = 2.0f;
    [messageTextParentView.layer setBorderColor:UIColorFromRGB(0xb7d457).CGColor];
    [messageTextParentView.layer setCornerRadius:5.0f];
    [messageTextParentView.layer setMasksToBounds:YES];
//    [messageText setTextColor:UIColorFromRGB(0xb7d457)];
//    [messageText setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
    [messageText setTextColor:[UIColor colorWithRed:160/255.0 green:200/255.0 blue:55/255.0 alpha:1.0]];
    
    noCommentsParentView.layer.borderWidth = 2.0f;
    [noCommentsParentView.layer setBorderColor:[UIColor colorWithRed:230/255.0 green:240/255.0 blue:197/255.0 alpha:1.0].CGColor];
    [noCommentsParentView.layer setCornerRadius:5.0f];
    [noCommentsParentView.layer setMasksToBounds:YES];
    [noCommentsTextView setTextColor:[UIColor colorWithRed:160/255.0 green:200/255.0 blue:55/255.0 alpha:1.0]];
    
    if(self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [messageText setText:@"Pentru a adauga comentarii trebuie sa fi facut o rezervare prin infopensiuni.ro"];
    }
    else{
        [messageText setText:@"Pentru a adauga comentarii\ntrebuie sa fi facut o rezervare\nprin infopensiuni.ro"];
    }

    [messageText setEditable:NO];
    [mainScrollView setBounces:YES];
    //commentsArray = @[];
    
    self.commentsArray = myJson[@"comentarii"];
    
    //ComNSLog(@"comments array:   %@", self.commentsArray);
   
}

-(void)viewWillAppear:(BOOL)animated{
    

    [backLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [backLabel setTextColor:UIColorFromRGB(0x666666)];
    
    [commentPageTitle setFont:[UIFont fontWithName:@"OpenSans" size:21.5f]];
    
    [self addStarsWithInt:[myJson[@"categorie"] intValue]];
    
    [nameLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.5f]];
    
    resizedPaths = [[NSMutableArray alloc] init];
    heightForRow = [[NSMutableArray alloc] init];
    CGFloat total = 0.0;
    for(int i=0; i< [commentsArray count]; i++){
        CommentTableViewCell * cell;
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (CommentTableViewCell *) currentObject;
                break;
            }
        }
        
        
        CGFloat temp = [self sizeOfText:commentsArray[i][@"pozitiv"] widthOfTextView:280 withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
        CGFloat temp2 = [self sizeOfText:commentsArray[i][@"negativ"] widthOfTextView:280 withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
        
        //ComNSLog(@"temp, temp2,h,h---%f,%f,%f,%f",temp,temp2,cell.positiveComment.frame.size.height , cell.negativeComment.frame.size.height);
        CGFloat  diff = (temp - cell.positiveComment.frame.size.height) + temp2 - cell.negativeComment.frame.size.height;
        
        total += diff;
    }
    
       [commentsTableView setFrame:CGRectMake(commentsTableView.frame.origin.x, commentsTableView.frame.origin.y, self.view.bounds.size.width, 100 * [commentsArray count] + total)];
    
//    [mainScrollView addSubview:messageView];
    
    [messageView setFrame:CGRectMake(0, CGRectGetMaxY(commentsTableView.frame)+20, self.view.bounds.size.width, messageView.frame.size.height)];
//    [bottomImageView setFrame:CGRectMake(bottomImageView.frame.origin.x, commentsTableView.frame.origin.y + commentsTableView.frame.size.height, bottomImageView.frame.size.width, bottomImageView.frame.size.height)];
    

    
    

    
    [mainScrollView setBounces:YES];
  
    
    
//    if([[UIScreen mainScreen] bounds].size.height > 480){
//        
//        [mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, bottomImageView.frame.size.height + bottomImageView.frame.origin.y+ 100)];
//    }
//    else{
//        [mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, bottomImageView.frame.size.height + bottomImageView.frame.origin.y+ 150)];
//    }

    //ComNSLog(@"table frame---%@", NSStringFromCGRect(commentsTableView.frame));
    //ComNSLog(@"bottom image---%@", NSStringFromCGRect(messageView.frame));
    
    [commentsTableView setScrollEnabled:NO];
    
    [mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, CGRectGetMaxY(messageView.frame) + 30)];
    
    //ComNSLog(@"frame:  %@", NSStringFromCGRect(mainScrollView.frame));
    //ComNSLog(@"content:   %@", NSStringFromCGSize(mainScrollView.contentSize));
    
    
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setShowsVerticalScrollIndicator:YES];
    
//    [noCommentsTextView setText:[NSString stringWithFormat:@"%@ %@ nu are niciun comentariu mai recent de 6 luni.\n\nDe retinut: comentariile pentru aceasta pensiune se pot face cu o rezervare facuta aici in aplicatie, sau pe www.infopensiuni.ro dupa 3 zile de la data terminarii sejurului asa cum este trecuta in rezervare.",myJson[@"tip"],myJson[@"nume"]]];
//    
//    [noCommentsTextView setFont:[UIFont fontWithName:@"OpenSans" size:15.0f]];
//    [noCommentsTextView setTextColor:UIColorFromRGB(0xb7d457)];
    
    if([commentsArray count] == 0){
        [commentsTableView setHidden:YES];
        [bottomImageView setHidden:YES];
        
        [mainScrollView addSubview:noCommentsView];
        
        [noCommentsTextView setText:[NSString stringWithFormat:@"\"%@ %@ nu are niciun comentariu mai recent de 6 luni.\n\nDe retinut: comentariile pentru aceasta pensiune se pot face cu o rezervare facuta aici in aplicatie sau pe www.infopensiuni.ro dupa 3 zile de la data terminarii sejurului asa cum este trecuta in rezervare.\"",myJson[@"tip"],myJson[@"nume"]]];
        
        [noCommentsTextView setFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]];
        [noCommentsTextView setTextColor:UIColorFromRGB(0xb7d457)];
        
     // check if deviceorientation
        if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)){
          
            CGRect framedemodif = noCommentsView.frame;
            framedemodif.size.width =commentsTableView.frame.size.width;
            framedemodif.origin.y = ([[UIScreen mainScreen] bounds].size.width - noCommentsView.frame.size.height) /2;
            noCommentsView.frame =framedemodif;
            
            CGRect txtFrame = noCommentsTextView.frame;
            txtFrame.size.height = [self sizeOfText:noCommentsTextView.text widthOfTextView:noCommentsTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]].height+5;
            [noCommentsTextView setFrame:txtFrame];
            
            CGRect noCommPVFr = noCommentsParentView.frame;
            noCommPVFr.size.height = CGRectGetMaxY(noCommentsTextView.frame) + 10;
            [noCommentsParentView setFrame:noCommPVFr];
            
            CGRect noCommVFr = noCommentsView.frame;
            noCommVFr.size.height = CGRectGetMaxY(noCommentsParentView.frame);
            
            [noCommentsView setFrame:noCommVFr];

            
       
            
            
        }else{
            //DO Landscape
                 CGRect framedemodif = noCommentsView.frame;
            framedemodif.size.width =commentsTableView.frame.size.width;
            framedemodif.origin.y = ([[UIScreen mainScreen] bounds].size.width - noCommentsView.frame.size.height) /2;
            noCommentsView.frame =framedemodif;
            
            CGRect txtFrame = noCommentsTextView.frame;
            txtFrame.size.height = [self sizeOfText:noCommentsTextView.text widthOfTextView:noCommentsTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]].height+5;
            [noCommentsTextView setFrame:txtFrame];
            
            CGRect noCommPVFr = noCommentsParentView.frame;
            noCommPVFr.size.height = CGRectGetMaxY(noCommentsTextView.frame) + 10;
            [noCommentsParentView setFrame:noCommPVFr];
            
            CGRect noCommVFr = noCommentsView.frame;
            noCommVFr.size.height = CGRectGetMaxY(noCommentsParentView.frame);
            
            [noCommentsView setFrame:noCommVFr];
        }
 
   

        
        [messageView setHidden:YES];
    }

    
//    //ComNSLog(@"mess size:   %@", NSStringFromCGSize([self sizeOfText:noCommentsTextView.text widthOfTextView:self.view.bounds.size.width withFont:[UIFont fontWithName:@"OpenSans" size:12.5f]]));
//    //ComNSLog(@"mess text: %@",messageTextView.text);
//    
//    // redimensionam height dupa content
//    float aux;
//    
//    CGRect txtFrame = noCommentsTextView.frame;
//    txtFrame.size.height = [self sizeOfText:noCommentsTextView.text widthOfTextView:self.view.bounds.size.width withFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]].height;
//    [noCommentsTextView setFrame:txtFrame];
//    
//    CGRect noCommPVFr = noCommentsParentView.frame;
//    noCommPVFr.size.height = CGRectGetMaxY(noCommentsTextView.frame) + 10;
//    [noCommentsParentView setFrame:noCommPVFr];
//    
//    CGRect noCommVFr = noCommentsView.frame;
//    noCommVFr.size.height = CGRectGetMaxY(noCommentsParentView.frame);
//    
//    [noCommentsView setFrame:noCommVFr];
    
    
    //ComNSLog(@"tabel:   %@",NSStringFromCGRect(commentsTableView.frame));
    //ComNSLog(@"bottom view: %@", NSStringFromCGRect(messageView.frame));
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if(UIInterfaceOrientationIsPortrait(fromInterfaceOrientation)){
        //        [messageView setFrame:CGRectMake(messageView.frame.origin.x,messageView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, messageView.frame.size.height)];
        //        int xPos, yPos;
        //        xPos = (messageView.frame.size.width - bottomImageView.frame.size.width)/2;
        //        yPos = (messageView.frame.size.height - bottomImageView.frame.size.height)/2;
        //        [bottomImageView setFrame:CGRectMake(xPos, yPos, bottomImageView.frame.size.width, bottomImageView.frame.size.height)];
        
        //        //ComNSLog(@"mainscrollview size:    %@", NSStringFromCGSize(mainScrollView.contentSize));
        //        //ComNSLog(@"maxy:    %f", CGRectGetMaxY(commentsTableView.frame));
        //        [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, CGRectGetMaxY(commentsTableView.frame))];
        //        //ComNSLog(@"mainscrollview size:    %@", NSStringFromCGSize(mainScrollView.contentSize));
        //
        //        //ComNSLog(@"messageview:    %@",NSStringFromCGRect(messageView.frame));
        //        //ComNSLog(@"tableview:    %@",NSStringFromCGRect(commentsTableView.frame));
        [messageText setText:@"Pentru a adauga comentarii trebuie sa fi facut o rezervare prin infopensiuni.ro"];
        
        //          [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height,CGRectGetMaxY(messageView.frame))];
        //                //ComNSLog(@"mainscroll width: %f and table width %f", mainScrollView.frame.size.width, commentsTableView.frame.size.width);
        CGRect framedemodif = noCommentsView.frame;
        framedemodif.size.width =commentsTableView.frame.size.width;
        noCommentsView.frame =framedemodif;
        CGRect txtFrame = noCommentsTextView.frame;
        txtFrame.size.height = [self sizeOfText:noCommentsTextView.text widthOfTextView:noCommentsTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]].height + 5;
        //ComNSLog(@"height:   %f", txtFrame.size.height);
        //ComNSLog(@"nocomm:   %@", NSStringFromCGRect(noCommentsTextView.frame));
        [noCommentsTextView setFrame:txtFrame];
        
        CGRect noCommPVFr = noCommentsParentView.frame;
        noCommPVFr.size.height = CGRectGetMaxY(noCommentsTextView.frame) + 10;
        [noCommentsParentView setFrame:noCommPVFr];
        
        CGRect noCommVFr = noCommentsView.frame;
        noCommVFr.size.height = CGRectGetMaxY(noCommentsParentView.frame);
        
        [noCommentsView setFrame:noCommVFr];
    }
    else{
        //       [messageView setFrame:CGRectMake(messageView.frame.origin.x,messageView.frame.origin.y , [[UIScreen mainScreen] bounds].size.width, messageView.frame.size.height)];
        //
        //        int xPos, yPos;
        //        xPos = (messageView.frame.size.width - bottomImageView.frame.size.width)/2;
        //        yPos = (messageView.frame.size.height - bottomImageView.frame.size.height)/2;
        //        [bottomImageView setFrame:CGRectMake(xPos, yPos, bottomImageView.frame.size.width, bottomImageView.frame.size.height)];
        [messageText setText:@"Pentru a adauga comentarii\ntrebuie sa fi facut o rezervare\nprin infopensiuni.ro"];
        //        [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY(messageView.frame))];
        //        //ComNSLog(@"mainscroll width: %f and table width %f", mainScrollView.frame.size.width, commentsTableView.frame.size.width);
        CGRect framedemodif = noCommentsView.frame;
        framedemodif.size.width =commentsTableView.frame.size.width;
        noCommentsView.frame =framedemodif;
        
        CGRect txtFrame = noCommentsTextView.frame;
        txtFrame.size.height = [self sizeOfText:noCommentsTextView.text widthOfTextView:noCommentsTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]].height + 5;
        [noCommentsTextView setFrame:txtFrame];
        
        CGRect noCommPVFr = noCommentsParentView.frame;
        noCommPVFr.size.height = CGRectGetMaxY(noCommentsTextView.frame) + 10;
        [noCommentsParentView setFrame:noCommPVFr];
        
        CGRect noCommVFr = noCommentsView.frame;
        noCommVFr.size.height = CGRectGetMaxY(noCommentsParentView.frame);
        
        [noCommentsView setFrame:noCommVFr];
    }
}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
//    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
////        [messageView setFrame:CGRectMake(messageView.frame.origin.x,messageView.frame.origin.y, [[UIScreen mainScreen] bounds].size.height, messageView.frame.size.height)];
////        int xPos, yPos;
////        xPos = (messageView.frame.size.width - bottomImageView.frame.size.width)/2;
////        yPos = (messageView.frame.size.height - bottomImageView.frame.size.height)/2;
////        [bottomImageView setFrame:CGRectMake(xPos, yPos, bottomImageView.frame.size.width, bottomImageView.frame.size.height)];
//        
////        //ComNSLog(@"mainscrollview size:    %@", NSStringFromCGSize(mainScrollView.contentSize));
////        //ComNSLog(@"maxy:    %f", CGRectGetMaxY(commentsTableView.frame));
////        [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height, CGRectGetMaxY(commentsTableView.frame))];
////        //ComNSLog(@"mainscrollview size:    %@", NSStringFromCGSize(mainScrollView.contentSize));
////        
////        //ComNSLog(@"messageview:    %@",NSStringFromCGRect(messageView.frame));
////        //ComNSLog(@"tableview:    %@",NSStringFromCGRect(commentsTableView.frame));
//            [messageText setText:@"Pentru a adauga comentarii trebuie sa fi facut o rezervare prin infopensiuni.ro"];
//        
////          [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.height,CGRectGetMaxY(messageView.frame))];
////                //ComNSLog(@"mainscroll width: %f and table width %f", mainScrollView.frame.size.width, commentsTableView.frame.size.width);
//        CGRect framedemodif = noCommentsView.frame;
//        framedemodif.size.width =commentsTableView.frame.size.width;
//        noCommentsView.frame =framedemodif;
//        CGRect txtFrame = noCommentsTextView.frame;
//        txtFrame.size.height = [self sizeOfText:noCommentsTextView.text widthOfTextView:noCommentsTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]].height;
//        //ComNSLog(@"height:   %f", txtFrame.size.height);
//        //ComNSLog(@"nocomm:   %@", NSStringFromCGRect(noCommentsTextView.frame));
//        [noCommentsTextView setFrame:txtFrame];
//        
//        CGRect noCommPVFr = noCommentsParentView.frame;
//        noCommPVFr.size.height = CGRectGetMaxY(noCommentsTextView.frame) + 10;
//        [noCommentsParentView setFrame:noCommPVFr];
//        
//        CGRect noCommVFr = noCommentsView.frame;
//        noCommVFr.size.height = CGRectGetMaxY(noCommentsParentView.frame);
//        
//        [noCommentsView setFrame:noCommVFr];
//    }
//    else{
//
////       [messageView setFrame:CGRectMake(messageView.frame.origin.x,messageView.frame.origin.y , [[UIScreen mainScreen] bounds].size.width, messageView.frame.size.height)];
////        
////        int xPos, yPos;
////        xPos = (messageView.frame.size.width - bottomImageView.frame.size.width)/2;
////        yPos = (messageView.frame.size.height - bottomImageView.frame.size.height)/2;
////        [bottomImageView setFrame:CGRectMake(xPos, yPos, bottomImageView.frame.size.width, bottomImageView.frame.size.height)];
//            [messageText setText:@"Pentru a adauga comentarii\ntrebuie sa fi facut o rezervare\nprin infopensiuni.ro"];
////        [mainScrollView setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY(messageView.frame))];
////        //ComNSLog(@"mainscroll width: %f and table width %f", mainScrollView.frame.size.width, commentsTableView.frame.size.width);
//        CGRect framedemodif = noCommentsView.frame;
//        framedemodif.size.width =commentsTableView.frame.size.width;
//        noCommentsView.frame =framedemodif;
//        
//        CGRect txtFrame = noCommentsTextView.frame;
//        txtFrame.size.height = [self sizeOfText:noCommentsTextView.text widthOfTextView:noCommentsTextView.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Italic" size:14.0f]].height;
//        [noCommentsTextView setFrame:txtFrame];
//        
//        CGRect noCommPVFr = noCommentsParentView.frame;
//        noCommPVFr.size.height = CGRectGetMaxY(noCommentsTextView.frame) + 10;
//        [noCommentsParentView setFrame:noCommPVFr];
//        
//        CGRect noCommVFr = noCommentsView.frame;
//        noCommVFr.size.height = CGRectGetMaxY(noCommentsParentView.frame);
//        
//        [noCommentsView setFrame:noCommVFr];
//        
//    }
//}

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //ComNSLog(@"scroll to :   %f,%f", scrollView.contentOffset.x, scrollView.contentOffset.y);
}

-(void)viewDidLayoutSubviews{
    //ComNSLog(@"view did layout subviews");

}
-(void)viewDidAppear:(BOOL)animated{
    //ComNSLog(@"view did appear");
    
    

    [nameLabel setText:myJson[@"nume"]];
    [nameView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.7]];

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
    
    
    yPosition = nameView.frame.origin.y + (nameView.frame.size.height - 18) / 2;
    
    
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




// metode tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //ComNSLog(@"cell for row---%d",[resizedPaths containsObject:indexPath]);
    static NSString *CellIdentifier = @"CommentTableViewCell";
    
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
        for (id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell =  (CommentTableViewCell *) currentObject;
                break;
            }
        }
    }
    
    [cell.touristName setText:commentsArray[indexPath.row][@"numeTurist"]];
    [cell.dateLabel setText:commentsArray[indexPath.row][@"data"]];
    [cell.positiveComment setText:commentsArray[indexPath.row][@"pozitiv"]];
    [cell.negativeComment setText:commentsArray[indexPath.row][@"negativ"]];

    [cell.dateLabel setTextColor:UIColorFromRGB(0x898d91)];
    [cell.touristName setTextColor:UIColorFromRGB(0x333333)];
    [cell.positiveComment setTextColor:UIColorFromRGB(0x898d91)];
    [cell.negativeComment setTextColor:UIColorFromRGB(0x898d91)];
    
    [cell.touristName setFont:[UIFont fontWithName:@"OpenSans-Light" size:17.5f]];
    [cell.positiveComment setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
    [cell.negativeComment setFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]];
    [cell.dateLabel setFont:[UIFont fontWithName:@"OpenSans-Light" size:9.5f]];
    UIView * separatorView;
    
    if(![resizedPaths containsObject:indexPath]){
        //ComNSLog(@"pozitiv----%@",NSStringFromCGSize([self sizeOfText:cell.positiveComment.text widthOfTextView:cell.positiveComment.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]]));
        //ComNSLog(@"negativ----%@",NSStringFromCGSize([self sizeOfText:cell.negativeComment.text widthOfTextView:cell.negativeComment.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]]));
        CGFloat positiveContentHeight = [self sizeOfText:cell.positiveComment.text widthOfTextView:cell.positiveComment.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
        
        cell.positiveComment.contentInset = UIEdgeInsetsMake(-8,0,0,0);
        [cell.positiveComment setUserInteractionEnabled:NO];
        [cell.positiveComment setFrame:CGRectMake(cell.positiveComment.frame.origin.x,cell.pinkHeartImage.frame.origin.y , cell.positiveComment.frame.size.width, positiveContentHeight)];
        
        CGFloat negativeContentHeight = [self sizeOfText:cell.negativeComment.text widthOfTextView:cell.negativeComment.frame.size.width withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
        
        
        
        cell.negativeComment.contentInset = UIEdgeInsetsMake(-8,0,0,0);
        [cell.negativeComment setUserInteractionEnabled:NO];
        [cell.negativeComment setFrame:CGRectMake(cell.negativeComment.frame.origin.x,cell.positiveComment.frame.origin.y + cell.positiveComment.frame.size.height+ 12, cell.negativeComment.frame.size.width, negativeContentHeight)];
        
        CGRect grayHeartFrame = cell.grayHeartImage.frame;
        grayHeartFrame.origin.y = cell.positiveComment.frame.origin.y + cell.positiveComment.frame.size.height+12;
        
        [cell.grayHeartImage setFrame:grayHeartFrame];
        
        //ComNSLog(@"bottom---%f", cell.negativeComment.frame.origin.y + cell.negativeComment.frame.size.height);
       
        CGFloat temp = [self sizeOfText:commentsArray[indexPath.row][@"pozitiv"] widthOfTextView:280 withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
        CGFloat temp2 = [self sizeOfText:commentsArray[indexPath.row][@"negativ"] widthOfTextView:280 withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
        
        CGFloat  diff = (temp - cell.positiveComment.frame.size.height) + temp2 - cell.negativeComment.frame.size.height;
        
        //ComNSLog(@"diff    %f", diff);
        
        for(UIView * mView in cell.contentView.subviews){
            if(mView.tag == 666){
                [mView removeFromSuperview];
            }
        }
        
        
        separatorView = [[UIView alloc] initWithFrame:CGRectMake(0,cell.negativeComment.frame.origin.y + cell.negativeComment.frame.size.height  + 6-0.5 , cell.frame.size.width, 0.5)];
        [separatorView setBackgroundColor:UIColorFromRGB(0xe5e5e5)];
        [separatorView setTag:666];
        separatorView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        
        [cell.contentView addSubview:separatorView];
        
        //ComNSLog(@"separator view frame:    %@", NSStringFromCGRect(separatorView.frame));
        //ComNSLog(@"separator view frame:    %@", NSStringFromCGRect(cell.contentView.frame));
        //ComNSLog(@"separator view frame:    %@", NSStringFromCGRect(cell.frame));

    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [commentsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CommentTableViewCell * cell = (CommentTableViewCell *)[commentsTableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
//    
    
//    //ComNSLog(@"height---%@", heightForRow);
//    if([resizedPaths containsObject:indexPath]){
//        return [heightForRow[indexPath.row] floatValue] + 150;
//    }
//    else{
//        return 100;
//    }
    CommentTableViewCell * cell;
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
    for (id currentObject in topLevelObjects){
        if ([currentObject isKindOfClass:[UITableViewCell class]]){
            cell =  (CommentTableViewCell *) currentObject;
            break;
        }
    }
    
    CGFloat temp = [self sizeOfText:commentsArray[indexPath.row][@"pozitiv"] widthOfTextView:280 withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
    CGFloat temp2 = [self sizeOfText:commentsArray[indexPath.row][@"negativ"] widthOfTextView:280 withFont:[UIFont fontWithName:@"OpenSans-Light" size:14.0f]].height;
    
    CGFloat  diff = (temp - cell.positiveComment.frame.size.height) + temp2 - cell.negativeComment.frame.size.height;
    
    //ComNSLog(@"diff ----%f", diff);
    
    return 100 + diff;
    


}

//-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
//{
//    //ComNSLog(@"text to measure---%@,%f,%@",textToMesure,width,font);
//    CGSize size = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake(width-20.0, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    return size;
//}

-(IBAction)backAction:(UIButton *)sender{
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
