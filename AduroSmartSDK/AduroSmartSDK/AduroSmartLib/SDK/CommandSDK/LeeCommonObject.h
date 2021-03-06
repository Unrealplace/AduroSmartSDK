//
//  LeeCommonObject.h
//  AduroSmartSDK
//
//  Created by MacBook on 2017/4/15.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Debug日志
#ifdef DEBUG
#    define  DLog(...) printf("**%s**\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String])
#    define  FLog(s)   NSLog(@"[%@-%@]:\n%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),s)
#    define  MLog(...) printf("mqtt**%s**\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String])
#    define  NETLog(...) printf("网络**%s**\n",[[NSString stringWithFormat:__VA_ARGS__]UTF8String])
#    define  TLog(...)  NSLog(@"[%@-%@]:\n%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),[NSString stringWithFormat:__VA_ARGS__])
#else
#    define DLog(...)
#    define MLog(...)
#    define FLog(...)
#    define TLog(...)
#endif

#define Lee_Notification     [NSNotificationCenter defaultCenter]
#define Lee_Userdefault      [NSUserDefaults standardUserDefaults]
#define Lee_BROADCAST_PORT   16899
#define Lee_MQTT_HOST        @"data.adurosmart.com"
#define Lee_LINE_HOST        @"www.microsoft.com"
#define Lee_GET_GATEWAY      @"getgateway"
#define Lee_CONNECT_GATEWAT  @"connectgateway"
#define Lee_Staus            @"Statu"
#define Lee_Stau             @"Status"
#define Lee_Local_or_Remote  @"local_or_remote"
#define Lee_Net_Not_Reach    @"not reach"
#define Lee_FIND_DEVICE      @"findDevice"
#define Lee_SAVE_GATEWAY     @"gatewayObject"
#define Lee_PACKAGE_HEAD     0x7e
#define Lee_PACKAGE_TAIL     0x7f
#define Lee_DIRECTION        @"D"
#define Lee_Gateway          @"gateway"
#define Lee_GateIP           @"IP"

typedef enum:NSInteger{
    AduroSmartLinkFailed,
    AduroSmartLinkSuccess
}AduroSmartLinkCode;

typedef enum: NSInteger{
    NetTypeLocal = 0,
    NetTypeRemote = 1,
    NetTypeUnreachble = 2
}NetType;

typedef enum: NSUInteger{
    //照明设备
    AduroDeviceTypeON_OFF_LIGHT    = 0x0000,//开关灯 On/off light
    AduroDeviceTypeON_OFF_SOCKET   = 0x0010,//开关插座 On/off plug-in unit
    AduroDeviceTypeDIMMABLE_LIGHT  = 0x0100,//调光灯 Dimmable light
    AduroDeviceTypeDIMMABLE_SOCKET = 0x0110,//调光插座 Dimmable plug-in unit
    AduroDeviceTypeCOLOR_TEM_LIGHT = 0x0220,//色温灯 Color temperature light
    AduroDeviceTypeETC_LIGHT   = 0x0210,//扩展彩色灯 Extended color light
    AduroDeviceTypeCOLOR_LIGHT = 0x0200,//彩色灯 Color light
    //控制设备
    AduroDeviceTypeCRT_CTR = 0x0202,//窗帘
    AduroDeviceTypeCLR_CTR = 0x0800,//遥控器Color controller
    AduroDeviceTypeSCN_CTR = 0x0810,//遥控器Color scene controller
    AduroDeviceTypeRMT_CTR = 0x0820,//遥控器Non-color controller
    AduroDeviceTypeNCS_CTR = 0x0830,//遥控器Non-color scene controller
    AduroDeviceTypeBRG_CTR = 0x0840,//遥控器Control bridge
    AduroDeviceTypeOOS_CTR = 0x0850,//遥控器On/off sensor
    //传感器设备
    AduroDeviceTypeDOOR_CONTANCT = 0x4215,//门磁
    AduroDeviceTypePIR_CONTANCT  = 0x420d,//PIR
    AduroDeviceTypePM25_SEN = 0x0309,//PM2.5
    AduroDeviceTypeSMK_SEN  = 0x0310 //烟雾传感器
    
}AduroDeviceType;

typedef enum :NSUInteger{

    AduroProfileIDAUTO    = 0x0104,//家居自动化
    AduroProfileIDLink    = 0xc05e,//灯链路
    AduroProfileIDPLANT   = 0x0101,//植物监测
    AduroProfileIDBUILD   = 0x0105,//楼宇自动化
    AduroProfileIDTELECOM = 0x0107,//电信应用
    AduroProfileIDPERSON  = 0x0108,//家庭护理
    AduroProfileIDADVANCE = 0x0109 //计量倡议
    
}AduroProfileID;

typedef enum: NSUInteger{

    AduroGroupTypeLivingRoom  = 0x01,//客厅
    AduroGroupTypeKitchenRoom = 0x02,//厨房
    AduroGroupTypeBedRoom     = 0x03,//卧室
    AduroGroupTypeBathRoom    = 0x04,//浴室
    AduroGroupTypeRestaurantRoom = 0x05,//餐厅
    AduroGroupTypeToiletRoom  = 0x06,//厕所
    AduroGroupTypeOfficeRoom  = 0x07,//办公室
    AduroGroupTypeHallwayRoom = 0x08,//走廊
    AduroGroupTypeStudyRoom   = 0x09,//书房
    AduroGroupTypeBalconyRoom = 0x0a,//阳台
    AduroGroupTypeOtherRoom   = 0x0b//其它
    
}AduroGroupType;

typedef enum :NSUInteger{
    
    AduroSceneTypeLivingRoom = 0x01,//离家
    AduroSceneTypeComingRoom = 0x02,//回家
    AduroSceneTypeWakeUp     = 0x03,//起床
    AduroSceneTypeSleep      = 0x04,//睡觉
    AduroSceneTypeHaveDinner = 0x05,//吃饭
    AduroSceneTypeReading    = 0x06,//阅读
    AduroSceneTypeWatchingTV = 0x07,//看电视
    AduroSceneTypeParty      = 0x08,//聚会
    AduroSceneTypeOther      = 0x09//其他
    
}AduroSceneType;

typedef enum :NSUInteger{

    AduroTaskTypeTimer = 0x00,//时间触发
    AduroTaskTypeThing = 0x01,//事件触发
    AduroTaskTypeOther = 0x03 //其它
}AduroTaskType;

typedef enum:NSUInteger{
    GateWayBackCodeACK_SUC_RTN = 0x00, //成功
    GateWayBackCodeACK_TIM_OUT = 0x01, //超时
    GateWayBackCodeACK_GEN_ERR = 0x02, //失败
    GateWayBackCodeACK_PAR_MSS = 0x03, //参数丢失
    GateWayBackCodeACK_PAR_INV = 0x04, //参数错误
    GateWayBackCodeACK_FRM_ERR = 0x05, //错误帧
    GateWayBackCodeACK_LEN_ERR = 0x06, //长度错误
    GateWayBackCodeACK_CHK_ERR = 0x07, //校验错误
    GateWayBackCodeACK_CMD_ERR = 0x08, //命令错误
    GateWayBackCodeACK_NPR_RTN = 0x09, //此用户无操作权限
    GateWayBackCodeACK_EMP_RTN = 0x0A, //表示没有要检索的结果
    GateWayBackCodeACK_MEM_ERR = 0x0B,  //表示改功能未成功，由于内存错误而完成，包括接收缓冲满
    GateWayBackCodeACK_ZGB_FAI = 0x0C,  //Zigbee协调器故障
    GateWayBackCodeACK_ZGB_DVA = 0x0D   //Zigbee设备异常

}GateWayBackCode;

typedef enum : NSUInteger {
    AduroSmartReturnCodeError    = 0x0001,
    AduroSmartReturnCodeSuccess  = 0x0002,
    AduroSmartReturnCodeNoAccess = 0x0003,
    AduroSmartReturnCodeDeviceNameLengthError = 0x0004,
    AduroSmartReturnCodeTaskNameLengthError   = 0x0005,
    AduroSmartReturnCodeTaskInfoNotAvailable  = 0x0006,
    AduroSmartReturnCodeNetError = 0x0007
} AduroSmartReturnCode;

/*网关指令集*/
//普通命令／
#define GATE_CMD_GTW_INF 0x0001 //获取网关配置信息，见表 4-3
#define GATE_CMD_USR_LST 0x0002 //获取用户列表，见表 4-4
#define GATE_CMD_USR_ADD 0x0003 //添加管理员以为的用户，此命令只有管理员可以控制
#define GATE_CMD_USR_MDF 0x0004 //修改用户名称
#define GATE_CMD_USR_DLT 0x0005 //删除管理员和用户，如果删除管理员，则用户列表清除
#define GATE_CMD_FCT_RST 0x0006 //恢复出厂设置，必须发送正确的 6 字节密码[限管理员]
#define GATE_CMD_SET_TIM 0x0007 //设置系统时钟和时区
#define GATE_CMD_SET_SVR 0x0008 //设置访问服务器地址
#define GATE_CMD_RSR_LST 0x0009 //获取资源列表，见表 4-2
//设备控制命令
#define GATE_CMD_DVC_ADD 0x0010 //添加新设备
#define GATE_CMD_DVC_DJN 0x0011 //禁止添加新设备，用于允许添加后面，停止新设备加入
#define GATE_CMD_DVC_DLT 0x0012 //删除设备
#define GATE_CMD_DVC_INF 0x0013 //获取设备信息
#define GATE_CMD_DVC_MDF 0x0014 //修改设备信息，包括修改设备的名称等
#define GATE_CMD_DVC_LST 0x0015 //获取设备列表
#define GATE_CMD_DVC_SWT 0x0016 //控制设备的开关状态
#define GATE_CMD_DVC_DIM 0x0017 //控制设备的亮度
#define GATE_CMD_DVC_TEM 0x0018 //控制设备的色温
#define GATE_CMD_DVC_COL 0x0019 //控制设备的颜色
#define GATE_CMD_DVC_IDN 0x001A //设备设别
//房间控制命令
#define GATE_CMD_GRP_ADD 0x0020 //添加房间
#define GATE_CMD_GRP_DLT 0x0021 //删除房间
#define GATE_CMD_GRP_INF 0x0022 //获取房间信息
#define GATE_CMD_GRP_MDF 0x0023 //包括修改房间名称、添加或删除房间中的设备等
#define GATE_CMD_GRP_ADC 0x0024 //在已经房间中添加一个或多个设备
#define GATE_CMD_GRP_DDC 0x0025 //在已经房间中删除一个或多个设备
#define GATE_CMD_GRP_LST 0x0026 //获取所有房间列表
#define GATE_CMD_GRP_SWT 0x0027 //控制房间的开关状态
#define GATE_CMD_GRP_DIM 0x0028 //控制房间的亮度
#define GATE_CMD_GRP_TEM 0x0029 //控制房间的色温
#define GATE_CMD_GRP_COL 0x002A //控制房间的颜色
//场景控制命令
#define GATE_CMD_SCN_ADD 0x0030 //添加场景
#define GATE_CMD_SCN_DLT 0x0031 //删除场景
#define GATE_CMD_SCN_INF 0x0032 //获取场景信息
#define GATE_CMD_SCN_MDF 0x0033 //修改场景信息，包括修改场景的名称
#define GATE_CMD_SCN_ADC 0x0034 //在已经场景中添加一个或多个设备
#define GATE_CMD_SCN_DDC 0x0035 //在已经场景中删除一个或多个设备
#define GATE_CMD_SCN_LST 0x0036 //获取所有场景列表
#define GATE_CMD_SCN_CON 0x0037 //控制场景
//任务控制命令
#define GATE_CMD_IFT_ADD 0x0040 //添加任务
#define GATE_CMD_IFT_DLT 0x0041 //删除任务
#define GATE_CMD_IFT_INF 0x0042 //获取任务信息
#define GATE_CMD_IFT_MDF 0x0043 //修改任务，包括修改任务名称、修改任务触发方式等
#define GATE_CMD_IFT_LST 0x0044 //获取任务列表
//在线升级命令
#define GATE_CMD_DWN_INF 0x0050 //启动下载，包括下载固件类型，版本信息，尺寸等 返回数据包的大小，范围[128~1024]字节
#define GATE_CMD_DWN_DAT 0x0051 //数据下载，总包数、当前包数和数据包
#define GATE_CMD_DWN_OVR 0x0052 //下载完成，设备收到此包后，重启并更新固件
//主动上传
#define GATE_CMD_UPD_NLL 0x8000 //空命令，用于接收到的命令不正确时候返回
#define GATE_CMD_UPD_SNS 0x8010 //传感器出发上传



typedef void (^LeeGetDataBlock)(id data);
typedef void (^LeeGetErrorBlock)(NSError* error);
typedef void (^LeeGatewayStatusBlock)(AduroSmartReturnCode code);
typedef void (^LeeGatewaysInLanBlock)(NSArray* gateways);

typedef void (^LeeAduroUDPReceiveDataBlock)(id data);
typedef void (^LeeAduroUDPReceiveErrorBlock)(NSError*error);
typedef void (^LeeAduroMQTTGetDataBlock)(id data);
typedef void (^LeeAduroMQTTGetErrorBlock)(NSError*error);
typedef void (^LeeAduroMQTTLinkSuccessBlock)(AduroSmartLinkCode code);


typedef void (^LeeDeviceStatusBlock)(AduroSmartReturnCode code);
typedef void (^LeeGroupStatusBlock)(AduroSmartReturnCode code);
typedef void (^LeeSceneStatusBlock)(AduroSmartReturnCode code);
typedef void (^LeeTaskStatusBlock)(AduroSmartReturnCode code);

typedef void (^LeeUserStatusBlock)(AduroSmartReturnCode code);

/**
 *  @brief 设备列表
 */
extern NSMutableArray *lee_globalAduroDevicesArray;
/**
 *  @brief 分组列表
 */
extern NSMutableArray *lee_globalAduroGroupsArray;
/**
 *  @brief 场景列表
 */
extern NSMutableArray *lee_globalAduroScenesArray;
/**
 *  @brief 网关列表
 */
extern NSMutableArray *lee_globalAduroGetwaysArray;
/**
 *  @brief 设备任务列表
 */
extern NSMutableArray *lee_globalAduroTaskInfosArray;

/*
  全局网络状态
 */
extern NetType GlobalConnectStatus;

@interface LeeCommonObject : NSObject

@property(nonatomic,strong)NSError * commonError;
@property(nonatomic,assign)BOOL      commentResult;

@end
