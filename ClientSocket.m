//
//  ClientSocket.m
//  iOS_CS_Socket_demo
//
//  Created by LV on 16/5/22.
//  Copyright © 2016年 lvhongyang. All rights reserved.
//

#import "ClientSocket.h"
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUF_SIZE 100

@interface ClientSocket ()
{
    struct sockaddr_in serv_addr;
}
@end

char bufRecv[BUF_SIZE] = {0};

@implementation ClientSocket

- (void)makeClientIpAdd:(const char *)ip_addr Port:(in_port_t)port
{
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_addr.s_addr = inet_addr(ip_addr);
    serv_addr.sin_port        = htons(port);
    serv_addr.sin_family      = AF_INET;
}

- (void)sendMsg:(const char *)msg
{
    NSLog(@"-------- %lu -----------",sizeof(msg));
    while (1) {
        int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        int success = connect(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
        
        if (success != -1)
        {
            write(serv_sock, msg, sizeof(msg));           // 1.发送msg数据给服务端
            read(serv_sock, bufRecv, sizeof(bufRecv)-1);  // 2.接收服务端发来的数据
            NSLog(@"【客户端】收到数据：%@ %lu",[NSString stringWithUTF8String:bufRecv],sizeof(msg));
            memset(bufRecv, 0, BUF_SIZE);
        }
        
        close(serv_sock);
    }
}

@end
