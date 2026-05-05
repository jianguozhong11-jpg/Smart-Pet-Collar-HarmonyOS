import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct EnvironmentLinkage {
  @State humidity: number = 65;
  @State airQuality: number = 72;

  build() {
    Column({ space: 20 }) {
      Text('环境智能联动')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })

      // 环境数据卡片
      Row({ space: 20 }) {
        Column() {
          Text('💧 湿度')
          Text(`${this.humidity}%`).fontSize(22).fontColor('#2196F3')
        }
        .width(120)
        .height(100)
        .backgroundColor('#E3F2FD')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)

        Column() {
          Text('🌬️ 空气质量')
          Text(`${this.airQuality} 优`).fontSize(22).fontColor('#4CAF50')
        }
        .width(120)
        .height(100)
        .backgroundColor('#E8F5E9')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
      }

      // 环境感知除味
      Column({ space: 10 }) {
        Text('🌬️ 环境感知除味')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        Button('触发除味')
          .width('100%')
          .height(50)
          .backgroundColor('#00BCD4')
          .onClick(() => promptAction.showToast({ message: "已根据环境数据自动触发除味", duration: 1500 }))
      }
      .width('90%')
      .padding(15)
      .backgroundColor('#F0F7FF')
      .borderRadius(16)

      // 如厕后精准除味
      Column({ space: 10 }) {
        Text('🚽 如厕后精准除味')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        Button('模拟如厕事件')
          .width('100%')
          .height(50)
          .backgroundColor('#FF9800')
          .onClick(() => {
            promptAction.showToast({ message: "检测到如厕事件，自动触发精准除味", duration: 1500 });
          })
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