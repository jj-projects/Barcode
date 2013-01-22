//
//  UPCEngine.m
//  Barcode
//
//  Created by Stefan Hafeneger on 03.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UPCEngine.h"


@implementation UPCEngine
#pragma mark Private

- (void)encode:(NSDictionary *)dictionary {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[self performSelectorOnMainThread:@selector(didNotEncode:) withObject:dictionary waitUntilDone:NO];
	
	[pool release];
	
}

- (void)decode:(NSDictionary *)dictionary {
	NSLog(@"decode:");
   
   
}


@end
