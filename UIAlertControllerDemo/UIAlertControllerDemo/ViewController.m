//
//  ViewController.m
//  UIAlertControllerDemo
//
//  Created by bingoogol on 15/6/12.
//  Copyright (c) 2015年 bingoogolapple. All rights reserved.
//

#import "ViewController.h"
#import "BGAAlertController.h"

@interface ViewController ()<UIAlertViewDelegate, UIActionSheetDelegate>
@property (nonatomic, weak) UITextField *test1Tf;
@property (nonatomic, weak) UITextField *test2Tf;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self testAlertController];
}

- (void)testAlertController {
    // UIAlertControllerStyleActionSheet = 0,
    // UIAlertControllerStyleAlert
//    UIAlertController *alert = [BGAAlertController alertControllerWithTitle:@"我是标题" message:@"我是消息" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"我是标题" message:@"我是消息" preferredStyle:UIAlertControllerStyleActionSheet];
    
    // UIAlertActionStyleDefault = 0,
    // UIAlertActionStyleCancel,
    // UIAlertActionStyleDestructive
    
    // 不用在controller中定义变量来保存textField，但是也要通过__weak来避免block循环引用
    __weak typeof(alert) weakAlert = alert;
    // 不管添加顺序怎样，取消按钮始终是在最底部的
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:[weakAlert.textFields firstObject]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"其他1" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了其他1按钮");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:[weakAlert.textFields firstObject]];
    }]];
    
    
    // 确定按钮和其他按钮按添加的先后顺序显示
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了确定按钮");
        NSArray *textFields = weakAlert.textFields;
        UITextField *pwdTf = [textFields objectAtIndex:1];
        NSLog(@"用户名=%@, 密码=%@, 短信验证码=%@", [textFields.firstObject text],pwdTf.text,[textFields.lastObject text]);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:[weakAlert.textFields firstObject]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"其他2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"点击了其他2按钮");
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:[weakAlert.textFields firstObject]];
    }]];
    
    
    // 在iPad中使用UIAlertControllerStyleActionSheet时，必须使用popover的形式展示。在iPad中alert.modalPresentationStyle的默认值就是UIModalPresentationPopover，不用开发者手动指定
    alert.modalPresentationStyle = UIModalPresentationPopover;
    alert.popoverPresentationController.sourceView = self.slider;
    alert.popoverPresentationController.sourceRect = self.slider.bounds;
    alert.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    // 使用上面三项，或者下面这一项
    // alert.popoverPresentationController.barButtonItem =
    
//    // You can add a text field only if the preferredStyle property is set to UIAlertControllerStyleAlert.
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.textColor = [UIColor redColor];
//        textField.placeholder = @"用户名";
//        // 通过通知的方式监听UITextField文本变化需要在alert关闭时取消通知，比较麻烦
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
//    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.secureTextEntry = YES;
//        textField.placeholder = @"密码";
//        // 监听UITextField文本变化的最简单方法就是addTarget，不要用通知的方式
//        [textField addTarget:self action:@selector(pwdDidChange:) forControlEvents:UIControlEventEditingChanged];
//    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"短信验证码";
//    }];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)usernameDidChange:(NSNotification *)notification {
    UITextField *usernameTf = notification.object;
    NSLog(@"%@", usernameTf.text);
}

- (void)pwdDidChange:(UITextField *)pwdTf {
    NSLog(@"%@", pwdTf.text);
}


- (void)testActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"我是标题" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"摧毁" otherButtonTitles:@"其他1", @"其他2", nil];
    [sheet showInView:self.view];
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    // 1
    NSLog(@"%s", __func__);
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
    // 2
    NSLog(@"%s", __func__);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 催婚按钮是0，otherButton一次递增，点击屏幕其他区域或者取消按钮是时值相同，最大
    NSLog(@"%s -- buttonIndex = %ld", __func__, buttonIndex);
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    // 没搞懂时撒时候调用
    NSLog(@"%s", __func__);
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    // 4
    NSLog(@"%s -- buttonIndex = %ld", __func__, buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // 5
    NSLog(@"%s -- buttonIndex = %ld", __func__, buttonIndex);
}



- (void)testUIAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"我是标题" message:@"我是消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", @"测试1", @"测试2", nil];
    // UIAlertViewStyleDefault = 0,
    // UIAlertViewStyleSecureTextInput,
    // UIAlertViewStylePlainTextInput,
    //  UIAlertViewStyleLoginAndPasswordInput
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    _test1Tf = [alert textFieldAtIndex:0];
    _test2Tf = [alert textFieldAtIndex:1];
    
    [alert show];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    // 1
    NSLog(@"%s", __func__);
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    // 2
    NSLog(@"%s", __func__);
    return NO;
}
- (void)didPresentAlertView:(UIAlertView *)alertView {
    // 3
    NSLog(@"%s", __func__);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 取消按钮是0，otherButton一次递增
    NSLog(@"%s -- buttonIndex = %ld -- test1 = %@  -test2 = %@", __func__, buttonIndex, _test1Tf.text, _test2Tf.text);
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView {
    // 没搞懂时撒时候调用
    NSLog(@"%s", __func__);
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    // 5
    NSLog(@"%s", __func__);
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // 6
    NSLog(@"%s", __func__);
}




@end