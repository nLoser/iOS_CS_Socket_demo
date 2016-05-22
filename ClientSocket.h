//
//  ClientSocket.h
//  iOS_CS_Socket_demo
//
//  Created by LV on 16/5/22.
//  Copyright © 2016年 lvhongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientSocket : NSObject

- (void)makeClientIpAdd:(const char *)ip_addr
                   Port:(in_port_t)port;

- (void)sendMsg:(char *)msg;

@end
