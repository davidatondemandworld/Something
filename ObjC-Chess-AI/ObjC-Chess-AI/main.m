//
//  main.m
//  ObjC-Chess-AI
//
//  Created by Andy Tung on 13-9-18.
//  Copyright (c) 2013年 Andy Tung (tanghuacheng.cn). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AI_XQWLight.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        AIEngine *aiEngine=[[AI_XQWLight alloc] init];
        [aiEngine initGame];
        //[aiEngine onHumanMove:9 fromCol:1 toRow:7 toCol:2];
 
        int frow,fcol,torow,tocol;
        
        [aiEngine generateMove:&frow fromCol:&fcol toRow:&torow toCol:&tocol];
        NSLog(@"%i,%i,%i,%i",frow,fcol,torow,tocol);        
        [aiEngine generateMove:&frow fromCol:&fcol toRow:&torow toCol:&tocol];
        NSLog(@"%i,%i,%i,%i",frow,fcol,torow,tocol);
        [aiEngine generateMove:&frow fromCol:&fcol toRow:&torow toCol:&tocol];
        NSLog(@"%i,%i,%i,%i",frow,fcol,torow,tocol);
        [aiEngine generateMove:&frow fromCol:&fcol toRow:&torow toCol:&tocol];
        NSLog(@"%i,%i,%i,%i",frow,fcol,torow,tocol);
        [aiEngine generateMove:&frow fromCol:&fcol toRow:&torow toCol:&tocol];
        NSLog(@"%i,%i,%i,%i",frow,fcol,torow,tocol);
        [aiEngine generateMove:&frow fromCol:&fcol toRow:&torow toCol:&tocol];
        NSLog(@"%i,%i,%i,%i",frow,fcol,torow,tocol);
          
    }
    return 0;
}

