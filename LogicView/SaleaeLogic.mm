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

//id objcptr;

@implementation SaleaeLogic

@synthesize pollTimer,isConnected,delegate;

- (id)init
{
    self = [super init];
    if (self) {
        //objcptr = self;
        pollTimer = nil;
        DevicesManagerInterface::RegisterOnConnect( &OnConnect,self);
        DevicesManagerInterface::RegisterOnDisconnect( &OnDisconnect,self);
        DevicesManagerInterface::BeginConnect();
        isConnected = NO;
    }
    
    return self;
}

- (BOOL)startPoll{
    if(pollTimer == nil){
        pollTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(poll) userInfo:nil repeats:YES];
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)stopPoll{
    if(pollTimer != nil){
        [pollTimer invalidate];
        pollTimer = nil;
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void)poll{
    [[self delegate] dataArrived:@"polled" data:[NSString stringWithFormat:@"%x",U32( gDeviceInterface->GetInput())]];
}

void __stdcall OnConnect( U64 device_id, GenericInterface* device_interface, void* user_data )
{    
	if( dynamic_cast<LogicInterface*>( device_interface ) != NULL )
	{
        //[[objcptr delegate] deviceConnected:[NSString stringWithFormat:@"%x",device_id]];
        [[(id)user_data delegate] deviceConnected:[NSString stringWithFormat:@"%x",device_id]];
		gDeviceInterface = (LogicInterface*)device_interface;
		gLogicId = device_id;
        
		gDeviceInterface->RegisterOnReadData( &OnReadData );
		gDeviceInterface->RegisterOnWriteData( &OnWriteData );
		gDeviceInterface->RegisterOnError( &OnError );
        
		gDeviceInterface->SetSampleRateHz( gSampleRateHz );
	}
}

void __stdcall OnDisconnect( U64 device_id, void* user_data )
{    
	if( device_id == gLogicId )
	{
        //[[objcptr delegate] deviceDisconnected:[NSString stringWithFormat:@"%x",device_id]];
        [[(id)user_data delegate] deviceDisconnected:[NSString stringWithFormat:@"%x",device_id]];
        
		gDeviceInterface = NULL;
	}
}

void __stdcall OnReadData( U64 device_id, U8* data, U32 data_length, void* user_data )
{
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
    //[[objcptr delegate] deviceError:[NSString stringWithFormat:@"%x",device_id]];
}

@end
