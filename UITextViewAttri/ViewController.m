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
@property (nonatomic, weak)UILabel *text;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LSTextView *textView = [[LSTextView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 500)];
    self.textView = textView;
    [self.view addSubview:textView];
  
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:btn];
    [btn setTitle:@"选择图片" forState:(UIControlStateNormal)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(openPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    btn.frame = CGRectMake(0, CGRectGetMaxY(textView.frame), 100, 100);
    UIButton *btn1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:btn1];
    [btn1 setTitle:@"提交" forState:(UIControlStateNormal)];
    btn1.backgroundColor = [UIColor orangeColor];
    [btn1 addTarget:self action:@selector(push) forControlEvents:(UIControlEventTouchUpInside)];
    btn1.frame = CGRectMake(210, CGRectGetMaxY(textView.frame), 100, 100);
    UILabel *text = [[UILabel alloc]init];
    self.text = text;
    [self.view addSubview:text];
    text.frame = CGRectMake(0, 300, 300, 600);
}

- (void)openPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
   
    picker.delegate = self;
    picker.allowsEditing = YES;
   
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)push {
    [self.textView.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textView.attributedText.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if ([value isKindOfClass:[NSTextAttachment class]]) {
            NSTextAttachment *textAtt = (NSTextAttachment *)value;
            NSLog(@"%@", textAtt.image);
        } else {
            NSAttributedString *attrString = [self.textView.attributedText attributedSubstringFromRange:range];
            NSString *string = attrString.string;
            NSLog(@"%@", string);
        }
    }];
  
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
