import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct HealthMonitor {
  // 模拟宠物健康数据
  @State heartRate: number = 95;
  @State temperature: number = 38.2;
  @State breathRate: number = 22;
  @State activity: number = 60;
  @State anxietyLevel: number = 20;

  // 模拟异常预警检测
  checkAbnormal() {
    if (this.heartRate > 140) {
      promptAction.showToast({ message: "⚠️ 心率异常！请关注宠物状态", duration: 2000 });
    }
  }

  build() {
    Column({ space: 20 }) {
      Text('宠物健康监测')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })

      // 健康数据卡片
      // 健康数据卡片
      Grid() {
        GridItem() {
          Column() {
            Text('❤️ 心率')
            Text(`${this.heartRate} BPM`).fontSize(20).fontColor('#F44336')
          }.justifyContent(FlexAlign.Center)
        }.backgroundColor('#FFF5F5').borderRadius(12)

        GridItem() {
          Column() {
            Text('🌡️ 体温')
            Text(`${this.temperature} ℃`).fontSize(20).fontColor('#FF9800')
          }.justifyContent(FlexAlign.Center)
        }.backgroundColor('#FFF9E5').borderRadius(12)

        GridItem() {
          Column() {
            Text('🌬️ 呼吸')
            Text(`${this.breathRate} 次/分`).fontSize(20).fontColor('#2196F3')
          }.justifyContent(FlexAlign.Center)
        }.backgroundColor('#F0F7FF').borderRadius(12)

        GridItem() {
          Column() {
            Text('🏃 活动量')
            Text(`${this.activity} 步`).fontSize(20).fontColor('#4CAF50')
          }.justifyContent(FlexAlign.Center)
        }.backgroundColor('#E8F5E9').borderRadius(12)
      }
      .columnsTemplate('1fr 1fr')  // 2列，宽度均分
      .rowsTemplate('1fr 1fr')    // 2行，高度均分
      .width('90%')
      .height(200)
      // 焦虑指数展示
      Column() {
        Text('😰 实时焦虑指数')
          .fontSize(18)
          .margin({ bottom: 10 })
        Progress({ value: this.anxietyLevel, total: 100, style: ProgressStyle.Linear })
          .width('80%')
          .color(this.anxietyLevel > 70 ? '#F44336' : '#4CAF50')
        Text(`当前等级：${this.anxietyLevel > 70 ? "高" : this.anxietyLevel > 40 ? "中" : "低"}`)
          .fontSize(16)
          .margin({ top: 10 })
      }
      .width('90%')
      .padding(20)
      .backgroundColor('#F5F5F5')
      .borderRadius(16)

      Button('刷新模拟数据')
        .width('60%')
        .height(50)
        .onClick(() => {
          this.heartRate = Math.floor(Math.random() * 80) + 70;
          // 修复温度的类型问题
          this.temperature = Math.round((Math.random() * 2 + 37.5) * 10) / 10;
          this.breathRate = Math.floor(Math.random() * 20) + 15;
          this.activity = Math.floor(Math.random() * 100);
          this.anxietyLevel = Math.floor(Math.random() * 100);
          this.checkAbnormal();
        })
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