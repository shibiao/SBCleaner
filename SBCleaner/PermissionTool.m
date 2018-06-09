//
//  PermissionTool.m
//  SBCleaner
//
//  Created by ShiBiao on 2018/6/8.
//  Copyright © 2018年 ShiBiao. All rights reserved.
//

#import "PermissionTool.h"

@implementation PermissionTool
+ (BOOL)removeFileWithElevatedPrivilegesFromLocation:(NSString *)location
{
    // Create authorization reference
    OSStatus status;
    AuthorizationRef authorizationRef;
    
    // AuthorizationCreate and pass NULL as the initial
    // AuthorizationRights set so that the AuthorizationRef gets created
    // successfully, and then later call AuthorizationCopyRights to
    // determine or extend the allowable rights.
    // http://developer.apple.com/qa/qa2001/qa1172.html
    status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Error Creating Initial Authorization: %d", status);
        return NO;
    }
    
    // kAuthorizationRightExecute == "system.privilege.admin"
    AuthorizationItem right = {kAuthorizationRightExecute, 0, NULL, 0};
    AuthorizationRights rights = {1, &right};
    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed |
    kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
    
    // Call AuthorizationCopyRights to determine or extend the allowable rights.
    status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Copy Rights Unsuccessful: %d", status);
        return NO;
    }
    
    // use rm tool with -rf
    char *tool = "/bin/rm";
    char *args[] = {"-rf", (char *)[location UTF8String], NULL};
    FILE *pipe = NULL;
    
    status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &pipe);
    if (status != errAuthorizationSuccess)
    {
        NSLog(@"Error: %d", status);
        return NO;
    }
    
    // The only way to guarantee that a credential acquired when you
    // request a right is not shared with other authorization instances is
    // to destroy the credential.  To do so, call the AuthorizationFree
    // function with the flag kAuthorizationFlagDestroyRights.
    // http://developer.apple.com/documentation/Security/Conceptual/authorization_concepts/02authconcepts/chapter_2_section_7.html
    status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
    return YES;
}
@end
