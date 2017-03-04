//
//  NANavigator.h
//  Pods
//
//  Created by  on 15/11/30.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NANavigator : NSObject <UINavigationControllerDelegate>

@property(nonatomic,assign)UINavigationController *navigationController;
@property(nonatomic,assign)UINavigationController *modalNavigationController;
+(instancetype)sharedInstance;
-(UIViewController *)showController:(Class)clasname withParam:(NSDictionary *)param;
-(UIViewController *)pushControllerWithClass:(Class) clazz animated:(BOOL)animated withParam:(NSDictionary *)param;

@end
