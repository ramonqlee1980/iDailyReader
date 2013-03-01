//
//  Unrar4iOS.h
//  Unrar4iOS
//
//  Created by Rogerio Pereira Araujo on 10/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Unrar4iOS/raros.hpp>
#import <Unrar4iOS/dll.hpp>
#import <Unrar4iOS/Unrar4iOS.h>

@interface Unrar4iOSEx : Unrar4iOS {
}
-(BOOL) unrarFileTo:(NSString*) path overWrite:(BOOL) overwrite;
-(BOOL)validRarFile:(NSString*)path;
@end
