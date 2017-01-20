        LazyNetForIOS
---------------------
# 由于本人不太会写文章,有写得不好得地方请见谅,之前也是一直都是写的android的,这是第一次写ios的
#  项目介绍
### 项目地址
  * [LazyNetForIOS](https://github.com/Robin-jiangyufeng/LazyNetForIOS)

### 介绍:
  * 这是一个ios网络请求框架,基于[AFNetworking](https://github.com/AFNetworking/AFNetworking)封装,其中缓存模块依赖[TMCache](https://github.com/tumblr/TMCache),JSON解析模块依赖[MJExtension](https://github.com/CoderMJLee/MJExtension)
  * 非常感谢这三个作品得作者,个人也热衷与开源,以后有觉得好的东西都会热于与大家分享
  * 如果觉得框架写的还不错,或者对自己有用的话,请给个star吧,感谢您的支持,谢谢
  * 如果框架中有什么写的不足的地方,请告诉我,非常感谢
  * 如果对与使用方法不懂的地方你也可以联系我,乐于为你解答(联系方式你看末尾)
  
### 功能:
  * 1.支持json,NSString,NSData,以及自定义的请求,自定义请求可以自行扩展,只需要自定义一个[AFHTTPRequestSerializer](https://github.com/Robin-jiangyufeng/LazyNetForIOS/blob/master/Pods/AFNetworking/AFNetworking/AFURLRequestSerialization.m)和[AFHTTPResponseSerializer](https://github.com/Robin-jiangyufeng/LazyNetForIOS/blob/master/Pods/AFNetworking/AFNetworking/AFURLResponseSerialization.m)子类,并重写对应方法即可
  * 2.目前支持GET和POST方式请求(一般开发场景中已足够用),以及文件上传和下载功能
  * 3.如果是json方式的请求,你只需要把对象的类型传过去,返回结果中就能够得到对应的对象数据,model格式参照[MJExtension](https://github.com/CoderMJLee/MJExtension)
  * 4.支持缓存,虽然Cocoa网络请求就支持缓存功能,但实际很多时候都不能满足我们的需求,比如先获取缓存数据再获取网络数据,后续将增加缓存期限
  * 5.支持block方式和delegate方式的数据回调,当一个页面中有多个请求的情况,强烈建议使用delegate方式,然后根据requestId(请求id)取区分是哪一个请求,并且做对应的处理,增加代码的复用性
  * 6.支持返回数据的加工处理,只需要自定义一个[ResponseProcess](https://github.com/Robin-jiangyufeng/LazyNetForIOS/blob/master/LazyNetLibrary/ResponseProcess.m)的子类,并重写process方法替换默认加工器即可
  * 7.支持自定义请求参数,不管是什么类型,只需要自定义一个[RequestParam](https://github.com/Robin-jiangyufeng/LazyNetForIOS/blob/master/LazyNetLibrary/RequestParam.m)的子类,并重写bodys方法即可
  * 8.支持加载框,并且自定义加载框
  * 9.支持取消对应requestId的请求,以及取消所有请求
  * 10.支持取消当前ViewController中的所有请求,请求与ViewController联动
  * 11.日志输出请求信息清晰明了

#   使用方法(以下使用方法只举了几个例,更多使用方法请自己查看代码,或者联系我)
### 库引入方式
   * 由于种种原因这个库暂时还没有提交到Cocoapods,如果需要使用请自行导出framework或者把LazyNetLibrary代码直接考到自己项目中

  
### 所需权限
  * 联网权限

### 更新baseUrl
   * 如果你的项目中请求地址前缀是统一的,请使用以下方法来设置基础url;如果不统一就不用设置了
```
  [[LazyHttpClient getInstance] updateBaseUrl:url];
  或者
  HttpClient *httpClient=[[HttpClient alloc]initWithBaseUrl:url];
  或者
  HttpClient *httpClient=[[HttpClient alloc]init];
  [httpClient updateBaseUrl:url];
```

### get方式请求(以下是block回调方式,delegate方式请自行看例子;例子的回调是重新包装过的,为了使用更加简单)
   * 不带缓存功能请求
````
    RequestParam* param=[[RequestParam alloc]initWithUrl:@"/mobile/get"];
    [param addBody:self.phoneText.text withKey:@"phone"];
    [param addBody:@"158e0590ea4e597836384817ee4108f3" withKey:@"key"];
    [[LazyHttpClient getInstance]GET_JSON:self param:param responseClazz:[GetPhoneProvinceResponseModel class] loadingDelegate:nil loadCache:nil success:^(NSString *requestId, id response) {
        GetPhoneProvinceResponseModel*model=response;
        self.lable.text=[JSONUtils objectToJSONString:model];
    } fail:^(NSString *requestId, NSInteger *errorCode, NSString *errorMsaaege) {
        self.lable.text=[NSString stringWithFormat:@"获取手机号归属地错误,错误原因:%@",errorMsaaege];
    }];
````

    * 带缓存功能请求(缓存类型有四种,代码中自行查看)
````
    RequestParam* param=[[RequestParam alloc]initWithUrl:@"/mobile/get"];
    [param addBody:self.phoneText.text withKey:@"phone"];
    [param addBody:@"158e0590ea4e597836384817ee4108f3" withKey:@"key"];
    param.cacheLoadType=USE_CACHE_UPDATE_CACHE;
    [[LazyHttpClient getInstance]GET_JSON:self param:param responseClazz:[GetPhoneProvinceResponseModel class] loadingDelegate:nil 
    loadCache:^(NSString *requestId, id response) {
        GetPhoneProvinceResponseModel*model=response;
        self.lable.text=[JSONUtils objectToJSONString:model];
    } success:^(NSString *requestId, id response) {
        GetPhoneProvinceResponseModel*model=response;
        self.lable.text=[JSONUtils objectToJSONString:model];
    } fail:^(NSString *requestId, NSInteger *errorCode, NSString *errorMsaaege) {
        self.lable.text=[NSString stringWithFormat:@"获取手机号归属地错误,错误原因:%@",errorMsaaege];
    }];
````


### post方式请求(以下是block回调方式,delegate方式请自行看例子;例子是经过包装了的)
   * 不带缓存功能的
````
     NSString*theUrl=@"/qqevaluate/qq";
     RequestParam* param=[[RequestParam alloc]initWithUrl:theUrl];
     [param addBody:self.phoneText.text withKey:@"qq"];
     [param addBody:@"780e8bced58c6203140b858d7aa2644c" withKey:@"key"];
     [[LazyHttpClient getInstance]POST_JSON:self param:param responseClazz:[QQXiongJIResponseModel class] loadingDelegate:nil loadCache:nil success:^(NSString *requestId, id response) {
           QQXiongJIResponseModel*model=response;
           self.lable.text=[JSONUtils objectToJSONString:model];
      } fail:^(NSString *requestId, NSInteger *errorCode, NSString *errorMsaaege) {
           self.lable.text=[NSString stringWithFormat:@"调用QQ测凶吉接口错误,错误原因:%@",errorMsaaege];
      }];
````
    * 带缓存功能的(缓存类型有四种,代码中自行查看)
````
    NSString*theUrl=@"/qqevaluate/qq";
    RequestParam* param=[[RequestParam alloc]initWithUrl:theUrl];
    [param addBody:self.phoneText.text withKey:@"qq"];
    [param addBody:@"780e8bced58c6203140b858d7aa2644c" withKey:@"key"];
    param.cacheLoadType=USE_CACHE_UPDATE_CACHE;
    [[LazyHttpClient getInstance]POST_JSON:self param:param responseClazz:[QQXiongJIResponseModel class] loadingDelegate:nil loadCache:^(NSString *requestId, id response) {
        QQXiongJIResponseModel*model=response;
        self.lable.text=[JSONUtils objectToJSONString:model];
    } success:^(NSString *requestId, id response) {
        QQXiongJIResponseModel*model=response;
        self.lable.text=[JSONUtils objectToJSONString:model];
    } fail:^(NSString *requestId, NSInteger *errorCode, NSString *errorMsaaege) {
        self.lable.text=[NSString stringWithFormat:@"调用QQ测凶吉接口错误,错误原因:%@",errorMsaaege];
    }];
````

### 上传
   * 待续...
   
### 下载
   * 待续...
   
# 关于作者Robin
* 屌丝程序员
* 如果对你有帮助,请给个star,谢谢支持
* GitHub: [Robin-jiangyufeng](https://github.com/Robin-jiangyufeng)
* QQ:429257411
* 交流QQ群 236395044
