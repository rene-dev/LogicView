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
U32 gSampleRateHz = 4000000;

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
    //[[self delegate] dataArrived:@"polled" data:[NSString stringWithFormat:@"%x",U32(data[0])]];
    int i = [self trigger:data length:length channel:2 rising:YES] - 3;
    const int leng = 250;
    unsigned char j[leng];
    int k = 0;
    unsigned char text1[leng+1];
    unsigned char text2[leng+1];
    unsigned char text3[leng+1];
    unsigned char text4[leng+1];
    unsigned char text5[leng+1];
    unsigned char text6[leng+1];
    unsigned char text7[leng+1];
    unsigned char text8[leng+1];
    //NSLog(@"hallo %i",i);
    if(i>-1){
        for(;k<leng;k++){
            j[k] = (i+k<length)?data[i+k]:0;
            text1[k] = (j[k]&(1<<0))?'-':'_';
            text2[k] = (j[k]&(1<<1))?'-':'_';
            text3[k] = (j[k]&(1<<2))?'-':'_';
            text4[k] = (j[k]&(1<<3))?'-':'_';
            text5[k] = (j[k]&(1<<4))?'-':'_';
            text6[k] = (j[k]&(1<<5))?'-':'_';
            text7[k] = (j[k]&(1<<6))?'-':'_';
            text8[k] = (j[k]&(1<<7))?'-':'_';
        }
    
    text1[leng] = '\0';
    text2[leng] = '\0';
    text3[leng] = '\0';
    text4[leng] = '\0';
    text5[leng] = '\0';
    text6[leng] = '\0';
    text7[leng] = '\0';
    text8[leng] = '\0';
    //NSLog([NSString stringWithFormat:@"%s",text]);
    [[self delegate] dataArrived:nil data:[NSString stringWithFormat:@"%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s",text1,text2,text3,text4,text5,text6,text7,text8]];
    }
    
}

- (int)trigger:(unsigned char*)data length:(unsigned int)length channel:(int)ch rising:(BOOL)fl{
    int i = 0;
    for(i = 1;i<length;i++){
        if ((data[i]&(1<<ch)) != (data[i-1]&(1<<ch)) && !(data[i]&(1<<ch)) != fl) {
            return i;
        }
    }    
    return -1;
    NSLog(@"hallo %i",length);
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
