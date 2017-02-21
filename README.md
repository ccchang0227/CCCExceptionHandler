# CCCExceptionHandler

用來截取App閃退訊息<br>
Notice: App還是會閃退，但是可以把閃退的原因存到本機，下次開啟時上傳到Server; 或是在閃退時開郵件App寄給開發者(沒試過)。<br>
相關文獻: Google關鍵字搜尋 [NSSetUncaughtExceptionHandler](https://www.google.com.tw/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=nssetuncaughtexceptionhandler)

## Requirements

iOS 7.0以上<br>
tvOS 9.0以上

## How to use

在 AppDelegate.m 的<br>
<code> - (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions; </code><br>
或<br>
<code> - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions; </code><br>
方法裡加上<br>
<code> [CCCExceptionHandler sharedInstance].delegate = self; </code><br>
<code> [CCCExceptionHandler sharedInstance].enabled = YES; </code><br>
這兩行，然後實作`CCCExceptionHandlerDelegate`協定的<br>
<code> - (void)cccExceptionHandler:(CCCExceptionHandler *)handler didReceiveException:(NSException *)exception; </code><br>
方法，就可以截取到App的閃退訊息

## Author

Chih-chieh Chang, ccch.realtouch@gmail.com

## License

CCCExceptionHandler is available under the MIT license. See the LICENSE file for more info.
