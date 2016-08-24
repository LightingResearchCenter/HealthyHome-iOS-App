//$Id: $
//$Header: $
//$Date:  $
//$DateTime: $
//$Change: $
//$File: $
//$Revision: $
//$Author:  $
//Purpose :  This unit is contains the constants used in the App

#ifndef _GlobalConfig_h
#define _GlobalConfig_h



#define k_PULSE_BUTTON_ANIMATION_SCALE_MAX  (1.05f)  // Amount of Connect button maximum transformation in Size
#define k_PULSE_BUTTON_ANIMATION_SCALE_MIN  (1.0f)   // Amount of Connect button minimum transformation in Size

#define k_SCAN_ATTEMPT_INTERVAL_SECONDS (10)         // Amount of time to scan looking for Peripherals
#define k_SCAN_ATTEMPT_DELAY_INTERVAL_SECONDS (2)     // Amount of time to delay before attempting the scan looking for Peripherals
#define k_REFRESH_UI_INTERVAL_SECONDS (5)     

#define k_ANIMATION_RING_ROTATE_TIME_SECONDS (5)             // Animate a ring while scanning - this is a animation constant
#define k_PERIPHERAL_CONNECT_INTERVAL_SECONDS (5)            // Amount of to wait after initiating a connect with a peripheral
#define k_POPUP_DISPLAY_TIME_SECONDS (3)                     // Amount of time a popup stays ON
#define k_TIMER_CIRCADIAN_MODEL_COMPUTE_SECS (3600)          // How often in Seconds to run the Circadian Model.
#define k_TIMER_CIRCADIAN_MODEL_RECOMPUTE_HOLDOFF_SECS (1)  // Hold off the Recompute algorithm from running 
#define k_TIME_REMAINING_PERCENTAGE_THRESHOLD (75)


//Constants related to the Gauge
#define k_ARC_ANGLE_MAX (294.0f)                   // Angle at which the  Gauge Arc stops
#define k_ARC_ANGLE_MIN (0.0f)                    // Angle at which the  Gauge Arc starts
#define k_PSI_MAX (24.0f)

#define k_MAX_RECORDS_LOGGED_IN_CORE_DATA (20000)            // Maximum number of records logged in Sqlite database
#define k_CIRACDIAN_MODEL_MIN_TIME_SECS   (360)

#define k_FEATURE_USE_REDPARK_DEBUG (1)                       // Whether we are using Redpark Serial Cable
#define k_FEATURE_SCAN_CONTINOUSALLY (1)                      // When set the App continouslly scans peripherals

#define K_FEATURE_SUPPORT_LANDSCAPE (0)                       // When set the App attempts to Relayout controls
#define k_FEATURE_DISPLAY_FAULTS (1)                          // Diaplsy faults when set
#define k_FEATURE_USE_SHAKE_FOR_DEBUG (1)
#define k_FEATURE_USE_PINCH_ZOOM_IN_TICKER (0)

#define k_FEATURE_USE_TEST_LOG_FILE (0)                      // Used to run test files to validate the circadian Algorithm
#define k_FEATURE_RUN_CIRCADIAN_AT_STARTUP (1)
#define k_FEATURE_POST_TEST_LOG_FILE (0)
#define k_FEATURE_DISCONNECT_IF_LOW_IPHONE_BATTERY (0)

#define k_FEATURE_SHOW_GOGGLE_CONTROL (0)


#define BATTERY_THRESOLD_FULL_MILLIVOLTS (2999)
#define BATTERY_THRESOLD_HIGH_MILLIVOLTS (2700)
#define BATTERY_THRESOLD_MEDIUM_MILLIVOLTS (2300)
#define BATTERY_THRESOLD_LOW_MILLIVOLTS  (2000)

#define k_DAYSI_LIGHT_SYNC_INTERVAL (180)
#define k_DAYSI_MOTION_SYNC_INTERVAL (180)

#define kPLOTSTRIP_TEXT_OFFSET (0.2f)
#define kLIGHT_CS_MAX ((0.7f) + kPLOTSTRIP_TEXT_OFFSET)
#define kLIGHT_CS_MIN (0.0f)

#define kMOTION_AI_MAX ((1.0f) + kPLOTSTRIP_TEXT_OFFSET)
#define kMOTION_AI_MIN (0.0f)

#define TICKER_MOVING_AVERAGE_FILTER_COUNT (10)

#define k_TRENDLINE_ARRAY_MAX_HRS (48)
#define kLIGHT_TRENDLINE_ARRAY_MAX ((int)(k_TRENDLINE_ARRAY_MAX_HRS * (3600 / k_DAYSI_LIGHT_SYNC_INTERVAL)))
#define kMOTION_TRENDLINE_ARRAY_MAX ((int)(k_TRENDLINE_ARRAY_MAX_HRS * (3600 / k_DAYSI_MOTION_SYNC_INTERVAL)))

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define kSYNC_WARN_INTERVAL_SECS (3600)
#define k_IPHONE_BATTERY_MINIMUM_LEVEL (90)


#endif
