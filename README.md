# ChongScanData
Qr code,Bar code

**前言**

```
	前言:前几天要做查询快递的功能,需要用到扫码,找了别人写好的,
	但是总感觉和自己想要实现的功能不一样,所以干脆自己定义了一个,
	留着以后使用.

```

**使用方法**

```
(1)打开DEMO 其他东西不用管;你只需要把 ChongScanDataClass文件
夹的东西拷贝到 你自己的项目里面,
(2)导入ChongScanDataClass.h
(3)模态或者Push 进入出ChongScanDataClass类的对象, 
(4)进行扫码;

-------代码----------
    ChongScanDataClass *chong = [[ChongScanDataClass alloc]init];
    chong.getCodingBlock = ^(NSString *code) {
        label.text = code;//code 即为搜码得到的字符;
    };
    [self presentViewController:chong animated:YES completion:nil];

```

# 深度解析

**ChongScanDataClass的优点**

```
* 可深度自定义界面  
* 可自定义扫码范围 
* 可自定义扫码类型(默认:条形码和二维码  可设置扫码类别为:只扫条形码或者只扫二维码)

```

**如何深度自定义界面**

```
自定义界面很简单
打开ChongScanDataClass.m文件,可任意在[self _creatSbView];
后面写上自己想写的任何界面;

例如我创建了一个返回按钮在哪里([self _creatReturnBtn];)
```

**如何自定义扫码范围**

```

打开 ChongScanDataClass.m文件;
  //创建扫码视图  withBorderFrame:扫码范围
    ScanViewChong *chong = [[ScanViewChong alloc]initWithFrame:self.view.bounds withBorderFrame:CGRectMake(10,KscreenHeightZC*.3,KScreenWidthZC-20, KScreenWidthZC*.7)];
    chong.disMissBlock = ^(BOOL isDissMiss) {
        if (isDissMiss) {
            if ([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    };
    chong.delegate = self;
    chong.scantype = typeALL;//二维码和条形码;
    [self.view addSubview:chong];


从注释中可以看到  withBorderFrame 后面的frame就是我们的扫码范围;

```

**如何设置扫码类型**

```
ScanViewChong 有一个属性,该属性有三个值  分别表示不同的扫码类型(默认为:条形码和二维码  )

chong.scantype = typeALL;//二维码和条形码;
chong.scantype = typeQR;//只扫二维码;
chong.scantype = typeRecent;//只扫条形码;

```



