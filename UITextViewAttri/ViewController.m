//
//  ViewController.m
//  UITextViewAttri
//
//  Created by LSS on 2022/8/19.
//

#import "ViewController.h"
#import "LSTextView.h"
@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak)LSTextView
*textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LSTextView *textView = [[LSTextView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 500)];
    self.textView = textView;
    [self.view addSubview:textView];
  
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(openPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = CGRectMake(0, CGRectGetMaxY(textView.frame), 100, 100);
}

- (void)openPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
   
    picker.delegate = self;
    picker.allowsEditing = YES;
   
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
     UIImage *newImage  = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.textView addImage:newImage];
   
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
