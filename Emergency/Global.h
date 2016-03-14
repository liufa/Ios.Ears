//
//  Global.h
//  Emergency
//
//  Created by star on 2/24/16.
//  Copyright © 2016 samule. All rights reserved.
//

#ifndef Global_h
#define Global_h

#define TEST_FLAG               0
#define kAPIBaseURLString       @"http://www.ears.uk.com"

typedef enum
{
    STATUS_NONE,
    STATUS_REGISTER,
    STATUS_CALLING,
    
} STATUS_TYPE;

#define TIMER_DURATION          3


/////////////////////////// MESSAGES. ///////////////////////////////////////

#define MSG_ERROR_INTERNET      @"Can't connect with web server. Please check internet connection."


#endif /* Global_h */
