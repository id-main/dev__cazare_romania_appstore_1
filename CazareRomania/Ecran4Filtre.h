//
//  Ecran4Filtre.h
//  CazareRomania
//  Created by Ioan Ungureanu on 4/23/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "RangeSlider.h"
@interface Ecran4Filtre : UIViewController {
    MKNetworkEngine *engine;
    RangeSlider *pret_slider;
    bool salveaza;
    UIImageView * _minThumb;
    UIImageView * _maxThumb;
     float _padding;
    id weakSelf;
}

@property (strong, nonatomic) IBOutlet UILabel *labelpensiuni;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *LoadingDataIndicator;
@property (strong, nonatomic) IBOutlet UIButton *butonAnulati; //sterge filtre user dar tine minte initiale
@property (strong, nonatomic) IBOutlet UIButton *butonBackCategorii; //sterge filtre user dar tine minte initiale
@property (strong, nonatomic) IBOutlet UIScrollView *BigScroll; //for main categ
@property (strong, nonatomic) IBOutlet UIScrollView *SmallScroll; //for subcategorii
@property (strong, nonatomic) IBOutlet UIButton *butonOK;
@property (strong, nonatomic) IBOutlet UIButton *pensiuniOnOff;
@property (strong, nonatomic) IBOutlet UIButton *obiectiveOnOff;
@property (nonatomic, strong) IBOutlet UIView *contentView; // principalele categorii pensiuni + obiective
@property (nonatomic, strong) IBOutlet UIView *secondView; // scroll pt subcat
@property (nonatomic, strong) IBOutlet UIView *subcategoriiView; // view pentru subcategorii obiective are propriul scrollview si butoane & labels in top

@property (nonatomic, strong) IBOutlet UITableView *FiltrePensiuni; // tabel filtre pensiuni
@property (nonatomic, strong)  NSArray *TitluriFiltrePensiuni; // titluri rows tabel filtre pensiuni

@property (nonatomic, strong) IBOutlet UITableView *FiltreObiective; // tabel filtre obiective + id +starea selected sau nu
@property (nonatomic, strong)  NSMutableArray *TitluriFiltreObiective;
@property (nonatomic, strong)  NSMutableArray *CopieTitluriFiltreObiective; //copie filtre obiective
@property (nonatomic, strong)  NSMutableArray *JustCompare; //copie filtre obiective de comparat cu filtre init
@property (nonatomic, strong) IBOutlet UITableView *SubcategoriiObiective; // tabel filtre subcategorii obiective + id +starea selected sau nu
@property (nonatomic, strong) NSMutableArray *SELECTIEStelePensiuni; //array pentru stele pensiuni din user defaults
@property (nonatomic, strong) NSMutableArray *CopieSELECTIEStelePensiuni; //contine o copie array pentru stele pensiuni din user defaults
@property (strong, nonatomic) IBOutlet UILabel *titluCategorieinViewSubcategorie;

@property (nonatomic, strong)  NSMutableArray *Subcategorie; // vine din SubcategoriiFiltreObiective at index
@property (nonatomic, strong) NSDictionary *toatefiltrele;  //initializare app
@property (nonatomic, strong)  NSDictionary *copietoatefiltrele;  //initializare app
@property (nonatomic, strong) NSDictionary *UTILIZATORtoatefiltrele;  //ce selecteaza user -> se tine in sesiune app
@property (assign) long RandObiectiv;
@property (strong, nonatomic) IBOutlet UIButton *totsaunimic; //sterge filtre user dar tine minte initiale
@property (strong, nonatomic) IBOutlet UILabel *pretulMinim;
@property (strong, nonatomic) IBOutlet UILabel *pretulMaxim;
@property (nonatomic, strong) NSMutableDictionary *preturi;
@property (nonatomic, strong) NSMutableDictionary *copiepreturi;

@property (nonatomic, strong) NSMutableArray *globalExcludedSubcats;
@property (strong, nonatomic) IBOutlet UILabel *labelObiective;
@property (strong, nonatomic) IBOutlet UILabel *pretNoapte;
@property (strong, nonatomic) IBOutlet UILabel *stele;
@property (strong, nonatomic) IBOutlet UIView *VctrDtl; //selector pret
@property (nonatomic, strong) IBOutlet UILabel *TITLUECRAN;
@property (nonatomic, strong) IBOutlet UILabel *TITLUECRANSUBCATEGORII;
//@property  (strong, nonatomic) IBOutlet UILabel *labelAnulati;

@property (nonatomic, strong) IBOutlet UIImageView * _minThumb;
@property (nonatomic, strong) IBOutlet UIImageView * _maxThumb;
 @property (nonatomic, assign)float _padding;

@end
