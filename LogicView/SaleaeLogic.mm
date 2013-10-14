//
//  SaleaeLogic.m
//  LogicView
//
//  Created by Rene Hopf on 7/17/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#import "SaleaeLogic.h"
#import "SaleaeLogicmm.h"

LogicInterface* gDeviceInterface = NULL;

U64 gLogicId = 0;
U32 gSampleRateHz = 1000000;

id objcptr;
bool polling = NO;

@implementation SaleaeLogic

@synthesize isConnected,delegate;

- (id)init
{
    self = [super init];
    if (self) {
        objcptr = self;
        DevicesManagerInterface::RegisterOnConnect( &OnConnect,self);
        DevicesManagerInterface::RegisterOnDisconnect( &OnDisconnect,self);
        DevicesManagerInterface::BeginConnect();
        isConnected = NO;
    }
    
    return self;
}

- (BOOL)startPoll{
    if(polling == NO){
        gDeviceInterface->ReadStart();
        polling = YES;
        return polling;
    }
    else{
        gDeviceInterface->Stop();
        NSLog(@"stopping");
        polling = NO;
        return polling;
        }
    /*if(pollTimer == nil){
        pollTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(poll) userInfo:nil repeats:YES];
        return YES;
    }
    else{
        return NO;
    }*/
}

- (BOOL)stopPoll{
    if(polling == YES){
        gDeviceInterface->Stop();
        NSLog(@"stopping");
        polling = NO;
        return polling;
    }
    else{
        return polling;
    }
    /*if(pollTimer != nil){
        [pollTimer invalidate];
        pollTimer = nil;
        return YES;
    }
    else{
        return NO;
    }*/
}

- (void)poll{
    [[self delegate] dataArrived:@"polled" data:[NSString stringWithFormat:@"%x",U32( gDeviceInterface->GetInput())]];
}

- (void)hallo:(unsigned char*)data length:(unsigned int)length{
    int i = 0;
    int flanken = 0;
    float freq = 0;
    float time = 0;
    for(i = 1;i<length;i++){
        if (data[i] == 127 && data[i-1] == 255) {
            flanken++;
        }
    }
    time = (float)length/(float)gSampleRateHz;
    if (time == 0) {
        freq = 8;
    }else{
    freq = (float)flanken/(float)time;
    }
        

    NSLog(@"hallo %f",freq);
}

void __stdcall OnConnect( U64 device_id, GenericInterface* device_interface, void* user_data )
{    
	if( dynamic_cast<LogicInterface*>( device_interface ) != NULL )
	{
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        [[(id)user_data delegate] deviceConnected:[NSString stringWithFormat:@"%llx",device_id]];
        [pool release];
		gDeviceInterface = (LogicInterface*)device_interface;
		gLogicId = device_id;
        
		gDeviceInterface->RegisterOnReadData( &OnReadData,user_data);
		gDeviceInterface->RegisterOnWriteData( &OnWriteData,user_data);
		gDeviceInterface->RegisterOnError( &OnError,user_data);
        
		gDeviceInterface->SetSampleRateHz( gSampleRateHz );
	}
}

void __stdcall OnDisconnect( U64 device_id, void* user_data )
{    
	if( device_id == gLogicId )
	{
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        [[(id)user_data delegate] deviceDisconnected:[NSString stringWithFormat:@"%llx",device_id]];
        [pool release];
        
		gDeviceInterface = NULL;
	}
}

void __stdcall OnReadData( U64 device_id, U8* data, U32 data_length, void* user_data )
{
    [objcptr hallo:data length:data_length];
	DevicesManagerInterface::DeleteU8ArrayPtr( data );
}

void __stdcall OnWriteData( U64 device_id, U8* data, U32 data_length, void* user_data )
{
	static U8 dat = 0;

	for( U32 i=0; i<data_length; i++ )
	{
		*data = dat;
		dat++;
		data++;
	}
}

void __stdcall OnError( U64 device_id, void* user_data )
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    [[(id)user_data delegate] deviceError:[NSString stringWithFormat:@"%llx",device_id]];
    [pool release];
}

@end
