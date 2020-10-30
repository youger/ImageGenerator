//
//  ViewController.m
//  ImageGenerator
//
//  Created by youger on 2020/10/30.
//

#import "ViewController.h"
#import "LYImageGenerator.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageView0.image = [LYImageGenerator circleImageForKey:@"70_70_F7B222_3_000000"];
    _imageView1.image = [LYImageGenerator borderCircleImageForKey:@"70_70_F7B222_5"];
    _imageView2.image = [LYImageGenerator intersectLineImageForKey:@"60_60_F7B222_5"];
    _imageView3.image = [LYImageGenerator gradientImageForKey:@"70_70_FB7200_2_FFFFFF"];
    _imageView4.image = [LYImageGenerator popoverImageWithSize:CGSizeMake(70, 50) triangleSize:CGSizeMake(12, 7) triangleInsets:UIEdgeInsetsZero cornerRadius:4 fillColor:[UIColor colorWithWhite:0 alpha:0.7]];
    _imageView5.image = [LYImageGenerator featureDecorationImage];
}


@end
