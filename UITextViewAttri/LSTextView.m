//
//  LSTextView.m
//  UITextViewAttri
//
//  Created by LSS on 2022/8/19.
//

#import "LSTextView.h"

@interface LSDeleteBtn : UIButton
@property (nonatomic, assign)NSRange range;
@end
@implementation LSDeleteBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
@interface LSTextView ()<UITextViewDelegate>
@property (nonatomic,copy) NSString *newstr;
@property (nonatomic,assign) NSRange newRange;
@property (nonatomic,assign) BOOL isDelete;        //是否是回删
@property (nonatomic,strong) NSMutableAttributedString * locationStr;
@property (nonatomic,strong)  NSMutableArray<LSDeleteBtn *> *deleteBtnArray;
@end
@implementation LSTextView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blueColor;
        self.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.delegate = self;
    }
    return self;
}
- (void)addImage:(UIImage *)image {
    NSAttributedString *enterStr = [[NSAttributedString alloc] initWithString:@"\n"];
    // 前文
    NSMutableAttributedString *bfStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSUInteger startLoc = bfStr.length;
    // 转换图片
    CGFloat newImgW = image.size.width;
    CGFloat newImgH = image.size.height;
    CGFloat textW   = [UIScreen mainScreen].bounds.size.width - (20);
    CGFloat textH = textW * newImgH / newImgW;
    image = [self imageCompressForSize:image targetSize:CGSizeMake(textW, textH)];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    attachment.image = image;
    NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *imageText = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    // 前文拼接图片
    // 换行
    [imageText insertAttributedString:enterStr atIndex:imageText.length];
    [bfStr insertAttributedString:imageText atIndex:bfStr.length];
    // 换行
    [bfStr insertAttributedString:enterStr atIndex:bfStr.length];
    // 拼接转换后的attributeStirng
    NSMutableAttributedString *newAtt = [[NSMutableAttributedString alloc]init];
    [newAtt setAttributedString:bfStr];
    NSUInteger endLoc = newAtt.length - startLoc;
    self.attributedText = newAtt;
    
    [self layoutIfNeeded];
    
    LSDeleteBtn *deleteBtn = [LSDeleteBtn buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(textW - 30, self.contentSize.height - textH - 35, 30, 30);
    deleteBtn.backgroundColor = [UIColor redColor];
    NSRange range= NSMakeRange(startLoc, endLoc);
    deleteBtn.range = range;
    [deleteBtn addTarget:self action:@selector(deleteImageFromChooseView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
    [self.deleteBtnArray addObject:deleteBtn];
    [self becomeFirstResponder];
    [self setInitLocation];
    [self scrollRangeToVisible: self.selectedRange];
}
-(void)setInitLocation
{
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSInteger len = self.attributedText.length - self.locationStr.length;
    if (len > 0) {
        self.isDelete = NO;
        self.newRange = NSMakeRange(self.selectedRange.location - len, len);
        self.newstr = [textView.text substringWithRange:self.newRange];
    } else {
        self.isDelete = YES;
    }
    [self setStyle];

}
- (void)setStyle{
    [self setInitLocation];
    if (self.isDelete) return;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle,};
    NSAttributedString * replaceStr=[[NSAttributedString alloc] initWithString:self.newstr attributes:attributes                                                  ];
    [self.locationStr replaceCharactersInRange:self.newRange withAttributedString:replaceStr];
    self.attributedText = self.locationStr;
    self.selectedRange  = NSMakeRange(self.newRange.location+self.newRange.length, 0);
    [self scrollRangeToVisible: self.selectedRange];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self.deleteBtnArray enumerateObjectsUsingBlock:^(LSDeleteBtn * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.range.location == range.location) {
            [obj removeFromSuperview];
            *stop = YES;
        }
    }];
    
    return YES;
}
- (void)deleteImageFromChooseView:(LSDeleteBtn *)sender {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    [text deleteCharactersInRange:sender.range];
    self.attributedText = text;
    [sender removeFromSuperview];
}
- (UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    CGFloat scale = [[UIScreen mainScreen]scale];
    CGSize imageSize = size;//取出要压缩的image尺寸
    //进行尺寸重绘
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [sourceImage drawInRect:CGRectMake(0,0,imageSize.width,imageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (NSMutableArray<LSDeleteBtn *> *)deleteBtnArray {
    if (!_deleteBtnArray) {
        _deleteBtnArray = [NSMutableArray new];
    }
    return _deleteBtnArray;
}
@end
