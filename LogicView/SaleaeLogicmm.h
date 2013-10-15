//
//  SaleaeLogicmm.h
//  LogicView
//
//  Created by Rene Hopf on 7/17/11.
//  Copyright 2011 Reroo. All rights reserved.
//

#ifndef LogicView_SaleaeLogicmm_h
#define LogicView_SaleaeLogicmm_h

#import <SaleaeDeviceApi.h>

void __stdcall OnConnect( U64 device_id, GenericInterface* device_interface, void* user_data );
void __stdcall OnDisconnect( U64 device_id, void* user_data );
void __stdcall OnReadData( U64 device_id, U8* data, U32 data_length, void* user_data );
void __stdcall OnWriteData( U64 device_id, U8* data, U32 data_length, void* user_data );
void __stdcall OnError( U64 device_id, void* user_data );

int samplerates[] = {
    25000,
    50000,
    100000,
    200000,
    250000,
    500000,
    1000000,
    2000000,
    4000000,
    8000000,
    12000000,
    24000000,
    24000000};

#endif
