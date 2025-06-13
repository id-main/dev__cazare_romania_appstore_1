//
//  DataBaseMaster.m
//  CazareRomania
//  Created by Ioan Ungureanu on 4/24/14.
//  Copyright (c) 2014 Activesoft. All rights reserved.
//
#import "DataBaseMaster.h"
#import "AppDelegate.h"

@interface DataMasterProcessor()

@end
@implementation DataMasterProcessor
@synthesize filtreObiective;
MKNetworkEngine *engine;
    ////////////////// Preia filtre generice  ////////////////// rezultat_REQ1
+(NSDictionary *)test1{
 NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"value1", @"key1", @"value2", @"key2", nil];
    return dict;
}
-(void)preiaFiltre_Ecran1{
    NSString *id_user_test = @"myx1j3";
    NSString *REQ1_path =[NSString stringWithFormat:@"http://%@%@",request1_url,id_user_test];
   //ComNSLog(@" userinfo_path_feedback %@ ",REQ1_path);
    engine=[[MKNetworkEngine alloc] initWithHostName:@"json.infopensiuni.ro" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:@"/app_cr/init/?id=myx1j3"
                                                params:nil
                                            httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary* rezultat_REQ1 = [completedOperation responseJSON];
        if(rezultat_REQ1) {
            NSString *status= [NSString stringWithFormat:@"%@",[rezultat_REQ1 objectForKey:@"status"]];
            if(![status isEqualToString:@"OK"]){
                [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
            } else{
                [self endRequestTaskWithData:rezultat_REQ1];
            }
        }
    }  errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
       //ComNSLog(@"%@", error); //show err
        [self endRequestWithConnectionError:@"eroare"];
    }];
    /////add to the http queue and the request is sent
    [engine enqueueOperation: op];
}

/////alerte
-(void)mesajAlerta:(NSString*)mAlerta titluAlerta:(NSString*)tAlerta {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:tAlerta
                                                    message:mAlerta
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
////generice pentru dicts
-(void)endRequestTaskWithData:(NSDictionary*)result{
    AppDelegate *appDelGlobal = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      if(result){
          appDelGlobal.ListaFiltreServer = result;
        }else{
           [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
           appDelGlobal.ListaFiltreServer = nil;
        }
}
-(void)endRequestWithConnectionError:(NSString*)data{
  [self mesajAlerta:@"A intervenit o eroare, te rugam sa incerci mai tarziu." titluAlerta:@"Atentie"];
    
}

////incarca poza asynchron

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

-(void)describeDictionary:(NSDictionary*)dict
{
    NSArray *keys;
    int i, count;
    id key, value;
    
    keys = [dict allKeys];
    count = [keys count];
    for (i = 0; i < count; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
       //ComNSLog (@"Key: %@ for value: %@", key, value);
    }
}
@end