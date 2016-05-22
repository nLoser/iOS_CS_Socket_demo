//
//  ServiceSocket.m
//  iOS_CS_Socket_demo
//
//  Created by LV on 16/5/22.
//  Copyright © 2016年 lvhongyang. All rights reserved.
//

#import "ServiceSocket.h"
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUF_SIZE 100

@implementation ServiceSocket

- (void)makeServiceIpAddr:(const char *)ip_addr Port:(in_port_t)port
{
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_addr.s_addr = inet_addr(ip_addr);
    serv_addr.sin_port        = htons(port);
    serv_addr.sin_family      = AF_INET;
    
    bind(serv_sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
    listen(serv_sock, 20);
    
    struct sockaddr_in clnt_addr;
    socklen_t clnt_len = sizeof(clnt_addr);
    char clnt_buff[BUF_SIZE] = {0};

    while (1) {
        int clnt_sock = accept(serv_sock, (struct sockaddr *)&clnt_addr, &clnt_len);
        
        read(clnt_sock, clnt_buff, sizeof(clnt_buff)-1);
        write(clnt_sock, clnt_buff, sizeof(clnt_buff));
        
        NSLog(@"【服务端】收到信息：%@",[NSString stringWithUTF8String:clnt_buff]);
        
        close(clnt_sock);
        memset(clnt_buff, 0, BUF_SIZE);
    }
}

@end
