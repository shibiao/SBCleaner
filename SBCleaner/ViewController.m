//
//  ViewController.m
//  SBCleaner
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 ShiBiao. All rights reserved.
//

#import "ViewController.h"
#import "PermissionTool.h"
@interface ViewController()<NSOpenSavePanelDelegate>{
    NSString *applicationsPath;
    NSOpenPanel *openPanel;
    NSURL *applicationURL;
    NSAlert *alert;
    BOOL  flag;
}
- (IBAction)handleRemove:(NSButton *)sender;
@property (weak) IBOutlet NSImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = [NSImage imageNamed:NSImageNameFolder];
    applicationsPath = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSSystemDomainMask, YES).firstObject;
    flag = YES;
}

- (IBAction)handleButton:(id)sender {
    openPanel = [NSOpenPanel openPanel];
    openPanel.directoryURL = [NSURL fileURLWithPath:applicationsPath];
    openPanel.canChooseDirectories = YES;
    openPanel.canChooseFiles = NO;
    openPanel.canResolveUbiquitousConflicts = YES;
    openPanel.prompt = @"允许";
    openPanel.message = @"请点击允许获得文件夹的权限";
    openPanel.delegate = self;
//    [self.view.window beginSheet:openPanel completionHandler:^(NSModalResponse returnCode) {
//
//    }];
    NSInteger i = [openPanel runModal];
    if (i == NSModalResponseOK) {
        NSURL *url = openPanel.URL;
        applicationURL = url;
        NSLog(@"url   : %@",url.path);
    }
}

- (IBAction)handleRemove:(NSButton *)sender {
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:applicationURL includingPropertiesForKeys:@[NSURLLocalizedNameKey,NSURLEffectiveIconKey,NSURLApplicationIsScriptableKey,NSURLIsPackageKey,NSURLIsApplicationKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    for (NSURL *url in enumerator) {
        NSString *isLocalizedName = nil;
        [url getResourceValue:&isLocalizedName forKey:NSURLLocalizedNameKey error:nil];
        NSNumber *isApplication = nil;
        [url getResourceValue:&isApplication forKey:NSURLIsApplicationKey error:nil];
        // NSURLLocalizedTypeDescriptionKey
//        NSString *localizedTypeDescript = nil;
        
        if (isLocalizedName &&  [isApplication boolValue]) {
            NSLog(@"--- %@",isLocalizedName);
            if ([isLocalizedName isEqualToString:@"Dr. Cleaner"]) {
                [PermissionTool removeFileWithElevatedPrivilegesFromLocation:url.path];
                return;
            }
            if ([url.path isEqualToString:@"/Applications/Camtasia 2.app"]) {
//                [PermissionTool removeFileWithElevatedPrivilegesFromLocation:url.path];
                NSError *error = nil;
//                [[NSFileManager defaultManager]trashItemAtURL:url resultingItemURL:nil error:&error];
//                [[NSFileManager defaultManager]removeItemAtURL:url error:&error];

                if (error) {
                    NSLog(@"----- %@",error);
                }else{
                    NSLog(@"success");
                }
            }
    }else {
            [enumerator skipDescendants];
        }
        
    }
//    NSArray<NSURL *> *files = [[NSFileManager defaultManager]contentsOfDirectoryAtURL:applicationURL includingPropertiesForKeys:@[NSURLIsApplicationKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
//    NSArray<NSString *> *files = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:applicationURL.path error:nil];
//    [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"files:  %@",obj);
////        if (obj.path isEqualToString:@"") {
////            <#statements#>
////        }
//    }];
    
}

-(void)getPermission {
    
   
    
    
//    NSDictionary *error = [NSDictionary new];
//
//    NSString *script =  @"do shell script \"command\" user name \"ShiBiao\" password \"1\" with administrator privileges";
//    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
//    if ([appleScript executeAndReturnError:&error]) {
//        NSLog(@"success!");
//    } else {
//        NSLog(@"failure!");
//    }

}
//MARK: NSOpenSavePanelDelegate
- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url {
    if ([url.path isEqualToString:applicationsPath]) {
        return YES;
    }
    return NO;
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    NSArray *arr;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj: %@, index:%lu",obj,(unsigned long)idx);
    }];
}
@end
