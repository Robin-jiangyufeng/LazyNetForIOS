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
  * 8.支持自定义请求参数,不管是什么类型,只需要自定义一个[RequestParam](https://github.com/Robin-jiangyufeng/LazyNetForIOS/blob/master/LazyNetLibrary/RequestParam.m)的子类,并重写bodys方法即可
  * 9.日志输出请求信息清晰明了
   
### 使用场景:
  * 1.替换SharePreference当做配置文件
  * 2.缓存网络数据,比如json,图片数据等
  * 3.自己想...

#   使用方法
### 库引入方式
   * Gradle: 
     ````compile 'com.robin.lazy.cache:CacheLibrary:1.0.6'````
   * Maven:
     ````
       <dependency>
          <groupId>com.robin.lazy.cache</groupId>
          <artifactId>CacheLibrary</artifactId>
          <version>1.0.6</version>
          <type>pom</type>
        </dependency>
      ````
  
### 所需权限
```java
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"/>
```

### 初始化
   * 想要直接使用CacheLoaderManager进行数据储存的话,请先进行初始化,初始化方式如下:
```java
  /***
	 * 初始化缓存的一些配置
	 * 
	 * @param diskCacheFileNameGenerator
	 * @param diskCacheSize 磁盘缓存大小
	 * @param diskCacheFileCount 磁盘缓存文件的最大限度
	 * @param maxMemorySize 内存缓存的大小
	 * @return CacheLoaderConfiguration
	 * @throws
	 * @see [类、类#方法、类#成员]
	 */
CacheLoaderManager.getInstance().init(Context context,FileNameGenerator diskCacheFileNameGenerator, long diskCacheSize,
                                      			int diskCacheFileCount, int maxMemorySize);
```
### 缓存数据
   * 以下代码只列举了储存String类型的数据,其它数据类型储存类似,具体请阅读 CacheLoaderManager.java
```java
   /**
	 * save String到缓存
	 * @param key 
	 * @param value 要缓存的值
	 * @param maxLimitTime 缓存期限(单位分钟)
	 * @return 是否保存成功
	 * boolean
	 * @throws
	 * @see [类、类#方法、类#成员]
	 */
CacheLoaderManager.getInstance().saveString(String key,String value,long maxLimitTime);
```
### 加载缓存数据
   * 以下代码只列举了加载String类型的数据方法,其它数据加载类似,具体请阅读 CacheLoaderManager.java
```java
   /**
     * 加载String
     * @param key
     * @return 等到缓存数据
     * String
     * @throws
     * @see [类、类#方法、类#成员]
     */
CacheLoaderManager.getInstance().loadString(String key);
```
### 其它
   * 上面介绍的是很小的一部分已经实现的功能,其中有还有很多功能可以高度定制,扩展性很强,更多功能待你发现;
   
# 关于作者Robin
* 屌丝程序员
* GitHub: [Robin-jiangyufeng](https://github.com/Robin-jiangyufeng)
* QQ:429257411
* 交流QQ群 236395044
