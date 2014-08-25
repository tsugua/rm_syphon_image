//
//  ServerEOS.m
//  ServerEOS
//
//  Created by Will on 10/08/2014.
//  Copyright (c) 2014 EOS. All rights reserved.
//

#import "ServerEOS.h"

@implementation ServerEOS
-(id) createServer:(NSString*) name withView: (NSOpenGLView*) view {
    CGLContextObj context = [[view openGLContext] CGLContextObj];
    return [[SyphonServer alloc] initWithName:name context:context options:nil];
}

-(id) createSyphonServer:(NSString*) name withContext: (NSOpenGLContext*) context {
    // CGLContextObj context = [[view openGLContext] CGLContextObj];
    return [[SyphonServer alloc] initWithName:name context:[context CGLContextObj] options:nil];
}
@end
