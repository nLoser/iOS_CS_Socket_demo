//
//  ViewController.m
//  iOS_CS_Socket_demo
//
//  Created by LV on 16/5/20.
//  Copyright © 2016年 lvhongyang. All rights reserved.
// http://www.cnblogs.com/R0SS/p/5508561.html

#import "ViewController.h"
#import <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface ViewController ()
@property (nonatomic, strong) UITextView * text;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _text = [[UITextView alloc] initWithFrame:CGRectMake(30, 100, 250, 90)];
    _text.backgroundColor = [UIColor orangeColor];
    _text.textColor = [UIColor blackColor];
    _text.text = @"你猜猜看看";
    [self.view addSubview:_text];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //*> 选择客户端和服务端
        [self client];
        //        [self server];
    });
}

//*> 客户端代码
- (void)client
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _text.text = @"我是 - 客户端";
        _text.font = [UIFont boldSystemFontOfSize:22];
    });
    
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    //向服务器（特定的IP和端口）发起请求
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));  //每个字节都用0填充
    serv_addr.sin_family = AF_INET;  //使用IPv4地址
    serv_addr.sin_addr.s_addr = inet_addr("192.168.1.3");  //具体的IP地址
    serv_addr.sin_port = htons(1234);  //端口
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _text.text = @"【客户端】\n 开始寻找服务IP";
    });
    connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _text.text = @"【客户端】\n IP连接完成";
    });
    //读取服务器传回的数据
    char buffer[40] = "我还是空的";
    read(sock, buffer, sizeof(buffer)-1);
    
    NSString * string = [NSString stringWithFormat:@"【客户端】收到信息 \n %@",[NSString stringWithUTF8String:buffer]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _text.text = string;
    });
    //关闭套接字
    close(sock);
}

//*> 服务端代码
- (void)server
{
    
    //[self activeGPRSThread];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _text.text = @"我是 - 服务端";
        _text.font = [UIFont boldSystemFontOfSize:22];
    });
    
    //创建套接字
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    //将套接字和IP、端口绑定
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));   //每个字节都用0填充
    serv_addr.sin_family      = AF_INET;        //使用IPv4地址
    serv_addr.sin_addr.s_addr = inet_addr("192.168.1.3") ;//;//; //具体的IP地址
    serv_addr.sin_port        = htons(1234);    //端口
    
    bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    //进入监听状态，等待用户发起请求
    
    listen(serv_sock, 20);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _text.text = @"【服务端】\n IP绑定完成,开始监听";
    });
    
    //等待堵塞，接收客户端请求
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    int clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_size);
    //向客户端发送数据
    char str[] = "hellowrold!";
    write(clnt_sock, str, sizeof(str));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _text.text = @"【服务端】\n 消息发送成功";
    });
    
    //关闭套接字
    close(clnt_sock);
    close(serv_sock);
}


@end
