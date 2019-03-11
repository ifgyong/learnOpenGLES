//
//  ViewController.m
//  FYCALayers
//
//  Created by Charlie on 2019/3/6.
//  Copyright © 2019年 www.fgyong.cn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UI];
}
- (void)UI{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FYItemCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"FYItemCollectionViewCell"];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.estimatedItemSize = CGSizeMake(100, 100);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    self.dataSource=@[@"FYCaShapeLayer",@"FYTextLayer",@"FYCAtransformLayer",
                      @"FYCAGradientLayer",@"FYReplicatorLayer",@"CAEmitterLayer",
                      @"FYAVplayerLayer",@"FYCAkeyFrameAnimation",@"CATransformEasyIn"];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"FYItemCollectionViewCell"
                                                                forIndexPath:indexPath];
    cell.backgroundColor = @[[UIColor whiteColor],[UIColor redColor],[UIColor lightGrayColor],[UIColor greenColor]][arc4random()%4];
    cell.titleLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.dataSource[indexPath.row];
    NSString *className=[NSString stringWithFormat:@"%@ViewController",self.dataSource[indexPath.row]];
    Class cla = NSClassFromString(className);
    UIViewController *vc=[cla new];
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
    return;
    switch (indexPath.row) {
        case 0:{
            FYCaShapeLayerViewController *shape=[[FYCaShapeLayerViewController alloc]initWithNibName:@"FYCaShapeLayerViewController" bundle:nil];
            [self.navigationController pushViewController:shape animated:YES];
        }
            break;
            
        default:
            break;
    }
    NSLog(@"");
}
@end
