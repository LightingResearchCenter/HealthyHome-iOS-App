//*****************************************************************************
//*****************************************************************************
//
// Filename:     $File: $
// Unit:         ENCRYPTION
// Author:       $Author: $
// Revision:     $Revision: $
// Date:         $DateTime: $
// Change:       $Change:$
// Company:      MPR Associates
// Ref:          xxxx-xx-xxxx - Software Design Document
//
//*****************************************************************************
//*****************************************************************************
#ifndef __ENCRYPTION_H
#define __ENCRYPTION_H
#include <stdint.h>


uint32_t Encryption_Init(void);

void Encryption_Unit_Test(void);

//returns error or success code
uint32_t Encryption_TranslateMessage(const uint8_t* input_message, uint16_t length_message_bytes, uint8_t*  output_message);

#endif
