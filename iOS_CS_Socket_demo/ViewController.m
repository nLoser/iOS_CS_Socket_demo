//
//  ViewController.m
//  iOS_CS_Socket_demo
//
//  Created by LV on 16/5/20.
//  Copyright © 2016年 lvhongyang. All rights reserved.
// http://www.cnblogs.com/R0SS/p/5508561.html

#import "ViewController.h"
#import "ServiceSocket.h"
#import "ClientSocket.h"

@interface ViewController ()
@property (nonatomic, strong) UITextView    * text;
@property (nonatomic, strong) ServiceSocket * serv_sock;
@property (nonatomic, strong) ClientSocket  * clnt_sock;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    const char ipstr[] = "192.168.1.103"; //*> 服务端IP
    in_port_t portNum  = 1234;
    
#if 1 //*> 客户端
    {
        _clnt_sock = [ClientSocket new];
        [_clnt_sock makeClientIpAdd:ipstr Port:portNum];
        [_clnt_sock sendMsg:"学习中文好榜样"];
    }
#endif
    
#if 0 //*> 服务端
    {
        _serv_sock = [ServiceSocket new];
        [_serv_sock makeServiceIpAddr:ipstr Port:portNum];

    }
#endif
}

@end
