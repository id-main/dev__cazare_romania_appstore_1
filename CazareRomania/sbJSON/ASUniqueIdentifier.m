//
//  ASUniqueIdentifier.m
//
//  Created by Ioan Ungureanu on 4/15/14.
//
//

#import "ASUniqueIdentifier.h"
#import "UICKeyChainStore.h"
#define access_key @"ro.activesoft"
#define access_service @"activesoft"
#define keychain_group @"S549J48A26.activesoft"
#define access_last_save @"access_last_save"

@interface ASUniqueIdentifier(){
    //private interface
}

//the pasteboard dissapears if all the apps that use it are deleted
+(NSString*)checkPasteboard;
+(void)saveToPasteBoard:(NSString*)device_id;

+(NSString*)checkKeyChain;
+(void)saveToKeyChain:(NSString*)device_id;

+(NSString*)checkSharedPreferences;
+(void)saveToSharedPreferences:(NSString*)device_id;

+(NSString*)generateAnIdentifier;
@end

@implementation ASUniqueIdentifier


+(NSString*)checkPasteboard{
//    NSLog(@"%s start",__func__);
    UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:access_key
                                                            create:YES];
	NSString* device_id=[appPasteBoard string];
    if(device_id&&[device_id length]>1){
//        NSLog(@"%s end",__func__);
        return device_id;
    }else{
//        NSLog(@"%s nil end",__func__);
        return nil;
    }
}

+(void)saveToPasteBoard:(NSString*)device_id{
//    NSLog(@"%s start",__func__);
    UIPasteboard *appPasteBoard = [UIPasteboard pasteboardWithName:access_key
                                                            create:YES];
	appPasteBoard.persistent = YES;
	[appPasteBoard setString:device_id];
//    NSLog(@"%s end",__func__);
}

+(NSString*)checkKeyChain{
//    NSLog(@"%s start",__func__);
    UICKeyChainStore* store=[UICKeyChainStore keyChainStoreWithService:access_service];
    
    NSString* device_id=[store stringForKey:access_key];
    if(device_id&&[device_id length]>1){
//        NSLog(@"%s end",__func__);
        return device_id;
    }else{
//        NSLog(@"%s nil end",__func__);
        return nil;
    }
    
}

+(void)saveToKeyChain:(NSString*)device_id{
//    NSLog(@"%s start",__func__);

    UICKeyChainStore* store=[UICKeyChainStore keyChainStoreWithService:access_service];
    [store setString:device_id forKey:access_key];
    
//    NSLog(@"%s end",__func__);
}


+(NSString*)checkSharedPreferences{
//    NSLog(@"%s start",__func__);

    NSUserDefaults* prefs=[NSUserDefaults standardUserDefaults];
    NSString* device_id=[prefs stringForKey:access_key];
    if(device_id&&[device_id length]>1){
//        NSLog(@"%s end",__func__);
        return device_id;
    }else{
//        NSLog(@"%s nil end",__func__);
        return nil;
    }
}


+(void)saveToSharedPreferences:(NSString*)device_id{
//    NSLog(@"%s start",__func__);

    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:device_id forKey:access_key];
    [prefs synchronize];
//    NSLog(@"%s end",__func__);
}


+(NSString*)generateAnIdentifier{
//    NSLog(@"%s start",__func__);

    NSString* device_id;
    //here check version and according to version do a version specific action
    if ([[UIDevice currentDevice].systemVersion floatValue]<6){
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        device_id = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }else if ([[UIDevice currentDevice].systemVersion floatValue]>=6) {
        device_id=[[UIDevice currentDevice] identifierForVendor].UUIDString;
    }
//    NSLog(@"%s %@ end",__func__,device_id);
    return device_id;
}


+(NSString*)getDeviceUniqueIdentifier{
//    NSLog(@"%s start",__func__);
    //this method should be optimized so that it only checks once for the device idetifier on all method
    //unfortunately this can fragmentate the device identifier in case one of the methods gets resseted somehow
    
    /*
        first check to see if any unique identifier is availble on the operating sistem memory spots available for all the apps to see (UIPastebord and security framework keychain)
        if that does not work check to see if anything is stored in the NSUserPreferences (synced from cloud
        if that does not work generate the identifier and put it everywhere
     */
    NSString* idetifier=@"";
    //save the result
    NSUserDefaults* prefs= [NSUserDefaults standardUserDefaults];
//    double time_of_now=[[NSDate date] timeIntervalSince1970];
//    double then=[prefs doubleForKey:access_last_save];
    
    
    BOOL should_save=YES;
    
//    if(then!=0){
//      should_save=YES;
//    } 
    
    if(should_save){
        //check each method by priority
        idetifier=[ASUniqueIdentifier checkSharedPreferences];
        if(!idetifier){
            idetifier=[ASUniqueIdentifier checkPasteboard];
            if(!idetifier){
                idetifier=[ASUniqueIdentifier checkKeyChain];
                if(!idetifier){
                    idetifier=[ASUniqueIdentifier generateAnIdentifier];
                    [ASUniqueIdentifier saveToKeyChain:idetifier];
                    [ASUniqueIdentifier saveToPasteBoard:idetifier];
                    [ASUniqueIdentifier saveToSharedPreferences:idetifier];
//                    [prefs setDouble:time_of_now forKey:access_last_save];
                    [prefs synchronize];
//                    NSLog(@"%s generateAnIdentifier %@",__func__,idetifier);
                }else{
                    [ASUniqueIdentifier saveToPasteBoard:idetifier];
                    [ASUniqueIdentifier saveToSharedPreferences:idetifier];
//                    NSLog(@"%s checkKeyChain %@",__func__,idetifier);
                }
            }else{
                [ASUniqueIdentifier saveToSharedPreferences:idetifier];
//                NSLog(@"%s checkPasteboard %@",__func__,idetifier);
            }
        }else{
//            NSLog(@"%s checkSharedPreferences %@",__func__,idetifier);
        }
    }
//    
//    NSLog(@"identifier going %@",idetifier);
    
   if(!idetifier){
//        NSLog(@"%s problem",__func__);
       
    }
    
    
//    NSLog(@"%s %@ end",__func__,idetifier);
    
    return idetifier;
    
}

@end
