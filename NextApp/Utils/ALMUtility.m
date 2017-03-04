//
//  ALMUtility.m
//  Pods
//
//  Created by wmy on 15/11/23.
//
//

#import "ALMUtility.h"

BOOL isNullForALM(id value) {
    return (!value || [value isKindOfClass:[NSNull class]]);
}
int toInt(id value) {
    return (isNullForALM(value) ? 0 : [value intValue]);
}
BOOL isEmptyString(id value) {
    return (isNullForALM(value) || [value isEqual:@""] || [value isEqual:@"(null)"]);
}
NSTimeInterval tNow() {
    return [[NSDate date] timeIntervalSince1970];
}
NSString *str(NSString *fmt, ...) {
    va_list valist;
    va_start(valist, fmt);
    NSString *s = [[NSString alloc] initWithFormat:fmt arguments:valist];
    va_end(valist);
    return s;
}

/**sizeForFilePath**/


unsigned long long __sizeForPathForALM(NSString* path, BOOL isRecursion, bool isRoot) {
    unsigned long long fileSize = 0;
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL isDir;
    if ([fileMgr fileExistsAtPath:path isDirectory:&isDir]) {
        if (!isDir) {
            NSDictionary *fileDictionary = [fileMgr attributesOfItemAtPath:path error:nil];
            fileSize += [[fileDictionary valueForKey:NSFileSize] unsignedLongLongValue];
        }else if (isDir && (isRoot || isRecursion)) {
            NSArray *allFiles = [fileMgr contentsOfDirectoryAtPath:path error:nil];
            for (NSString *sub in allFiles) {
                fileSize += __sizeForPathForALM([path stringByAppendingPathComponent:sub], isRecursion, FALSE);
            }
        }
    }
    return fileSize;
}

unsigned long long sizeForPath(NSString* path, BOOL isRecursion) {
    return __sizeForPathForALM(path, isRecursion, YES);
}

