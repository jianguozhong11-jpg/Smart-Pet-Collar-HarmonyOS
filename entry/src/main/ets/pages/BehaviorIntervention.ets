import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct BehaviorIntervention {
  @State forbiddenZoneEnabled: boolean = false;

  build() {
    Column({ space: 20 }) {
      Text('智能行为干预')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })

      // 声音安抚模块
      Column({ space: 10 }) {
        Text('🎵 声音安抚')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        Row({ space: 10 }) {
          Button('舒缓音乐')
            .width('45%')
            .height(50)
            .backgroundColor('#2196F3')
            .onClick(() => promptAction.showToast({ message: "正在播放舒缓音乐", duration: 1500 }))

          Button('主人呼唤')
            .width('45%')
            .height(50)
            .backgroundColor('#4CAF50')
            .onClick(() => promptAction.showToast({ message: "正在播放主人呼唤录音", duration: 1500 }))
        }

        Row({ space: 10 }) {
          Button('警告音')
            .width('45%')
            .height(50)
            .backgroundColor('#FF9800')
            .onClick(() => promptAction.showToast({ message: "已播放警告音", duration: 1500 }))

          Button('自定义录音')
            .width('45%')
            .height(50)
            .backgroundColor('#9C27B0')
            .onClick(() => promptAction.showToast({ message: "正在播放自定义安抚录音", duration: 1500 }))
        }
      }
      .width('90%')
      .padding(15)
      .backgroundColor('#F0F7FF')
      .borderRadius(16)

      // 气味释放模块
      Column({ space: 10 }) {
        Text('🌸 气味释放')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        Row({ space: 10 }) {
          Button('安抚信息素')
            .width('30%')
            .height(50)
            .backgroundColor('#E91E63')
            .onClick(() => promptAction.showToast({ message: "已释放安抚信息素", duration: 1500 }))

          Button('环境除味剂')
            .width('30%')
            .height(50)
            .backgroundColor('#00BCD4')
            .onClick(() => promptAction.showToast({ message: "已释放环境除味剂", duration: 1500 }))

          Button('驱离气味')
            .width('30%')
            .height(50)
            .backgroundColor('#607D8B')
            .onClick(() => promptAction.showToast({ message: "已释放禁区驱离气味", duration: 1500 }))
        }
      }
      .width('90%')
      .padding(15)
      .backgroundColor('#FFF5F5')
      .borderRadius(16)

      // 禁区闯入干预
      Column({ space: 10 }) {
        Text('🚫 禁区闯入干预')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        Toggle({ type: ToggleType.Switch, isOn: this.forbiddenZoneEnabled })
          .onChange((isOn: boolean) => {
            this.forbiddenZoneEnabled = isOn;
            promptAction.showToast({
              message: isOn ? "禁区干预已开启，闯入将自动触发警告" : "禁区干预已关闭",
              duration: 1500
            });
          })
          .alignSelf(ItemAlign.Start)
          .margin({ left: 10 })
      }
      .width('90%')
      .padding(15)
      .backgroundColor('#FFF9E5')
      .borderRadius(16)

      // 返回按钮
      Button('返回主页面')
        .width('50%')
        .height(45)
        .backgroundColor('#78909C')
        .onClick(() => router.back())
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F7F8FA')
  }
}