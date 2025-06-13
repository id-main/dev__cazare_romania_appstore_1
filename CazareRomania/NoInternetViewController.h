//
//  NoInternetViewController.h
//  CazareRomania
//  Created by Ioan Ungureanu on 4/15/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NoInternetViewController : UIViewController {
    MKNetworkEngine *engine;
    IBOutlet UIButton *ButonIncearca; //buton incearca din nou -> nu are internet
    IBOutlet UILabel *TextNuAreInternet;
    IBOutlet UIActivityIndicatorView *LoadingDataIndicator; //feedback load
}

@property (nonatomic,strong) IBOutlet UIButton *ButonIncearca;
@property (nonatomic,strong) IBOutlet UILabel *TextNuAreInternet;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *LoadingDataIndicator;

@end
