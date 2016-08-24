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


#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "encryption.h"
#include "sha256.h"
#include "GlobalConfig.h"

#define                MAX_MESSAGE_LENGTH_BYTE                (32)

static  uint32_t       m_Initialize = 0;
static  uint8_t        m_Key[MAX_MESSAGE_LENGTH_BYTE];






void Encryption_Unit_Test(void){
    uint8_t testpoint[10] ="1223412234";
    uint8_t result[10];
    uint8_t finalresult[10];
    Encryption_TranslateMessage((const uint8_t*) &testpoint, sizeof(testpoint), (uint8_t *)&result);
    Encryption_TranslateMessage((const uint8_t*) &result, sizeof(result), (uint8_t *)&finalresult);     
    uint8_t i;
    uint8_t * tpointer = (uint8_t *)&testpoint;
    uint8_t * rpoint = (uint8_t *)&finalresult;
    for(i = 0; i < sizeof(testpoint); i++){
       assert(*tpointer == *rpoint);
       tpointer++;
        rpoint++;
   } 
}

