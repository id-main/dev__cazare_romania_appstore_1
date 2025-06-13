//
//  ASUniqueIdentifier.h
//
//  Created by Ioan Ungureanu on 4/15/14.
//
//

#import <Foundation/Foundation.h>

@interface ASUniqueIdentifier : NSObject{
    
}//incearca sa genereze un identificator unic care sa persiste dupa dezinstalarea aplicatiei, pana acum s-a dovedit inutil

+(NSString*)getDeviceUniqueIdentifier;

@end
