# CCCExceptionHandler

用來截取App閃退訊息<br>
Notice: App還是會閃退，但是可以把閃退的原因存到本機，下次開啟時上傳到後台; 或是在閃退時開郵件App寄給開發者(這個我沒試過)。<br>
相關文獻: Google關鍵字搜尋 [NSSetUncaughtExceptionHandler](https://www.google.com.tw/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=nssetuncaughtexceptionhandler)

## Requirements

iOS 7.0以上<br>
tvOS 9.0以上

## Before Installation

教學: [https://help.github.com/articles/connecting-to-github-with-ssh/](https://help.github.com/articles/connecting-to-github-with-ssh/)<br>
要在CocoaPods中使用Github上的private repository，要先在電腦和github帳戶裡設定SSH key。<br>

1. 打開終端機，輸入以下指令檢查是否有已存在的SSH keys:<br>
`ls -al ~/.ssh`
<br><br>
2. 產生新的SSH key，輸入以下指令:<br>
`ssh-keygen -t rsa -b 4096 -C "<你的email>"`
<br>出現:<br>
`Enter a file in which to save the key (/Users/<你的帳戶>/.ssh/id_rsa): [Press enter]`
<br>時，這是詢問你要存放在什麼位置，可以輸入:<br>
`/Users/<你的帳戶>/.ssh/<自定義的名稱>`
<br>或是直接按Enter使用預設的位置(/Users/<你的帳戶>/.ssh/id_rsa)。<br>
按Enter之後接下來出現:<br>
`Enter passphrase (empty for no passphrase): [Type a passphrase]`<br>
`Enter same passphrase again: [Type passphrase again]`
<br>這兩行要請你輸入密碼的訊息，什麼都不要輸入直接按Enter就好了。
<br><br>
3. 接下來要把產生出的SSH key加入 ssh-agent裡，輸入以下指令:<br>
`ssh-add ~/.ssh/<自定義的名稱>`
<br><br>
4. 接下來要把SSH key加到github帳戶設定裡，輸入以下指令:<br>
`pbcopy < ~/.ssh/<自定義的名稱>.pub`
<br>把key複製到剪貼簿裡。
<br><br>
5. 到Github網頁登入帳號，點選右上角頭像，選擇「Setting」進入帳戶設定。<br>
6. 左方功能列切換到「SSH and GPG keys」。<br>
7. 點擊「New SSH key」，在出現的"Title"欄位裡輸入識別此SSH key的名稱(例如:C.C.Chang的MBP)，在"Key"欄位輸入剛剛複製到剪貼簿的key。<br>
8. 點擊「Add SSH key」，就完成新增SSH key的工作了，此後在這台電腦上，就可以用SSH的連結存取到github上的private repository。<br>

## Installation

CCCExceptionHandler is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CCCExceptionHandler', :git => 'git@github.com:realtouchapp/RTErrorReport.git', :tag => '0.0.5'
```

## Usage

在 AppDelegate.m 的<br>
`- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions`<br>
或<br>
`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`<br>
方法裡加上<br>
`[CCCExceptionHandler sharedInstance].delegate = self;`<br>
`[CCCExceptionHandler sharedInstance].enabled = YES;`<br>
這兩行，然後在AppDelegate裡實作CCCExceptionHandlerDelegate協定的<br>
`- (void)cccExceptionHandler:(CCCExceptionHandler *)handler didReceiveException:(NSException *)exception`
方法，就可以截取到App的閃退訊息

## Author

Chih-chieh Chang, ccch.realtouch@gmail.com

## License

CCCExceptionHandler is available under the MIT license. See the LICENSE file for more info.
