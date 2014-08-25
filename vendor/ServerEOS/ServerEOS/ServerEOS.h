//
//  ServerEOS.h
//  ServerEOS
//
//  Created by Will on 10/08/2014.
//  Copyright (c) 2014 EOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Syphon/Syphon.h>

@interface ServerEOS : NSObject
    - (id)createServer:(NSString*)name withView:(NSOpenGLView*)view;
@end
