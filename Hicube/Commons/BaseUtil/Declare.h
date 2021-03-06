//
//  Declare.h
//  CloudSalePlatform
//
//  Created by Kiwaro on 14-7-20.
//  Copyright (c) 2014年 Kiwaro. All rights reserved.
//
// 全局需要的一些枚举类型数据声明在这里


// 0－男 1－女
typedef enum {
    Male = 0,
    Female = 1,
}Gender;


typedef enum {
    forMessagePerson = 0,
    forMessageSystem = 1,
}MessageType;

typedef struct {
    double lat;
    double lng;
} Location;

typedef enum {
    forNotifySystem = 1,                // 系统
    forNotifyAdd = 2,                   // 添加关注
    forNotifyCancelAdd = 6,
    forNotifyKickUser = 20,             // 踢用户出房间
    forNotifyDestroyRoom = 21,          // 删除房间
    forNotifyInviteUser = 22,           // 邀请用户进房间
    forNotifyLeaveRoom = 23,            // 用户离开房间
    forNotifyChangeRoomName = 24,       // 修改房间信息
} NotifyType;

extern Location kLocationMake(double la, double ln);
typedef enum
{
    forCommentGood = 0,
    forCommentBad,
    forCommentAnonymous,
    forCommentNonAnonymous,
}CommentShowType;
typedef enum
{
    SHOP =0,
    ACTIVITY,
    WARE,
    EMPLOYEE,
    NoneCommentType,
    WORKS,
}CommentType;

