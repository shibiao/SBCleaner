//
//  PermissionTool.h
//  SBCleaner
//
//  Created by ShiBiao on 2018/6/8.
//  Copyright © 2018年 ShiBiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PermissionTool : NSObject
+ (BOOL)removeFileWithElevatedPrivilegesFromLocation:(NSString *)location;
@end
