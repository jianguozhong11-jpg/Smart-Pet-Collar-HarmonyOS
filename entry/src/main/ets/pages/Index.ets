import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct Index {
  build() {
    Column({ space: 20 }) {
      // 标题
      Text('智能宠物项圈系统')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      // 宠物图标
      Image($r('app.media.tubiao_bg'))
        .width(160)
        .height(160)
        .borderRadius(20)
        .margin({ bottom: 20 })

      // 功能模块入口
      Column({ space: 15 }) {
        // 1. 宠物健康监测
        Button('🐾 宠物健康监测')
          .width('90%')
          .height(60)
          .fontSize(20)
          .backgroundColor('#4CAF50')
          .onClick(() => {
            promptAction.showToast({ message: "进入健康监测模块", duration: 1000 });
            router.pushUrl({ url: "pages/HealthMonitor" });
          })

        // 2. 智能行为干预
        Button('🎵 智能行为干预')
          .width('90%')
          .height(60)
          .fontSize(20)
          .backgroundColor('#2196F3')
          .onClick(() => {
            promptAction.showToast({ message: "进入行为干预模块", duration: 1000 });
            router.pushUrl({ url: "pages/BehaviorIntervention" });
          })

        // 3. 环境智能联动
        Button('🌬️ 环境智能联动')
          .width('90%')
          .height(60)
          .fontSize(20)
          .backgroundColor('#FF9800')
          .onClick(() => {
            promptAction.showToast({ message: "进入环境联动模块", duration: 1000 });
            router.pushUrl({ url: "pages/EnvironmentLinkage" });
          })

        // 4. 智能场景模式
        Button('🏠 智能场景模式')
          .width('90%')
          .height(60)
          .fontSize(20)
          .backgroundColor('#9C27B0')
          .onClick(() => {
            promptAction.showToast({ message: "进入场景模式模块", duration: 1000 });
            router.pushUrl({ url: "pages/SmartScene" });
          })

        // 5. 鸿蒙多端协同
        Button('📱 鸿蒙多端协同')
          .width('90%')
          .height(60)
          .fontSize(20)
          .backgroundColor('#795548')
          .onClick(() => {
            promptAction.showToast({ message: "进入多端协同模块", duration: 1000 });
            router.pushUrl({ url: "pages/MultiDeviceSync" });
          })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
    .justifyContent(FlexAlign.Center)
  }
}