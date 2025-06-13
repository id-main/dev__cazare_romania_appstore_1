//
//  DataBaseMaster.h
//  CazareRomania
//  Created by Ioan Ungureanu on 4/24/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface DataMasterProcessor : NSObject{
   
}
//totate apelurile locale pentru date
@property (nonatomic,retain)  NSArray *filtreObiective;
+(NSDictionary *)test1;

//-(void)preiaFiltre_Ecran1; //filtre
-(void)preiaFiltre_Ecran1;
-(void)endRequestTaskWithData:(NSDictionary*)result; //rezultat filtre
-(void)mesajAlerta:(NSString*)mAlerta titluAlerta:(NSString*)tAlerta;
-(void)describeDictionary:(NSDictionary*)dict;
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock;
@end
