//
//  UPCEngine.m
//  Barcode
//
//  Created by Stefan Hafeneger on 03.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "UPCEngine.h"
#import "ZBarImage.h"
#import "ZBarSymbol.h"
#import "ZBarImageScanner.h"


@implementation UPCEngine
#pragma mark Private

- (void)encode:(NSDictionary *)dictionary {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[self performSelectorOnMainThread:@selector(didNotEncode:) withObject:dictionary waitUntilDone:NO];
	
	[pool release];
	
}

- (void)decode:(NSDictionary *)dictionary {
	NSLog(@"decode:");
   
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	UIImage *image = (UIImage *)[dictionary objectForKey:@"image"];
	
	NSMutableArray *messages = [NSMutableArray array];
	
	
	// Create gray image.
	CGImageRef grayImage = [self grayImageFromImage:image withRect:(CGRect)[(NSValue *)[dictionary objectForKey:@"rect"] CGRectValue]];
	if(grayImage == NULL) {
		if(!self.cancel)
			[self performSelectorOnMainThread:@selector(didNotDecode:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:image, @"image", nil] waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(didStopOperation) withObject:nil waitUntilDone:NO];
		[pool release];
		return;
	}
	
	if(self.cancel) {
		CGImageRelease(grayImage);
		[self performSelectorOnMainThread:@selector(didStopOperation) withObject:nil waitUntilDone:NO];
		[pool release];
		return;
	}   

   ZBarImage * zImage = [[[ZBarImage alloc] initWithCGImage:grayImage] autorelease];
   assert(NULL != zImage);
   
   ZBarImageScanner *scanner = [[[ZBarImageScanner alloc] init] autorelease];
   assert(NULL != scanner);
   
   [scanner scanImage:zImage];
   ZBarSymbolSet *result = [scanner results];
   
   NSString *message = [[NSString alloc] initWithData:[result data] encoding:NSUTF8StringEncoding];
   assert(NULL != message);
   [messages addObject:message];

   if([messages count] > 0) {
		if(!self.cancel)
			[self performSelectorOnMainThread:@selector(didDecode:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:image, @"image", [messages objectAtIndex:0], @"string", nil] waitUntilDone:NO];
	} else {
		if(!self.cancel)
			[self performSelectorOnMainThread:@selector(didNotDecode:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:image, @"image", nil] waitUntilDone:NO];
	}
	
	[self performSelectorOnMainThread:@selector(didStopOperation) withObject:nil waitUntilDone:NO];
	
	[pool release];

}


@end
