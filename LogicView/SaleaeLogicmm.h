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

#endif
