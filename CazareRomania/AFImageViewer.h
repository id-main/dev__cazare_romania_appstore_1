//
//  AFImageViewer.h
//  ImageViewer
//
//  Created by Adrian Florian on 5/11/12.
//  Copyright (c) 2012 Adrian Florian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPageControl.h"
@protocol AFImageViewerDelegate<NSObject>
-(UIImageView *) imageViewForPage:(int) page;
-(int) numberOfImages;
@end

@interface AFImageViewer : UIView<UIScrollViewDelegate> {
    SMPageControl *pageControl;
    UIView * greenBorder;
}

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *imagesUrls;
@property (nonatomic, strong) UIImage *loadingImage;
@property (nonatomic) BOOL disableSpinnerWhenLoadinImage;
@property (strong, nonatomic) SMPageControl *pageControl;
@property (strong, nonatomic) UIView *greenBorder;
@property (nonatomic) BOOL tempDownloadedImageSavingEnabled;

@property (nonatomic) UIViewContentMode contentMode;

@property (nonatomic, weak) id<AFImageViewerDelegate> delegate;


-(void) setCustomPageControl:(SMPageControl *) customPageControl;

-(void)setInitialPage:(NSInteger)page;
-(NSInteger)currentPage;

@end
