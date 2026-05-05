import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

@Entry
@Component
struct SmartScene {
  @State antiConflictMode: boolean = false;
  @State homeWatchMode: boolean = false;

  // 点击计数器
  @State antiConflictClickCount: number = 0;
  @State homeWatchClickCount: number = 0;

  // 演示状态
  @State showingAntiConflictDemo: boolean = false;
  @State showingHomeWatchDemo: boolean = false;
  @State demoProgress: number = 0;
  @State demoSteps: string[] = [];
  @State currentDemoType: string = ''; // 'antiConflict' 或 'homeWatch'

  // 模拟防邻里冲突情景
  simulateAntiConflictScenario() {
    if (this.showingAntiConflictDemo) return;

    this.showingAntiConflictDemo = true;
    this.antiConflictMode = true;
    this.currentDemoType = 'antiConflict';

    // 设置演示步骤
    this.demoSteps = [
      "🔍 检测到宠物轻度吠叫 (强度: 3/10)",
      "🔊 检测到宠物中度吠叫 (强度: 5/10)",
      "🚨 检测到宠物剧烈吠叫 (强度: 8/10)",
      "🎵 触发安抚措施: 播放舒缓音乐",
      "✅ 宠物情绪逐渐平静，安抚完成"
    ];

    this.demoProgress = 0;
    this.startDemo();
  }

  // 模拟离家守望情景
  simulateHomeWatchScenario() {
    if (this.showingHomeWatchDemo) return;

    this.showingHomeWatchDemo = true;
    this.homeWatchMode = true;
    this.currentDemoType = 'homeWatch';

    // 设置演示步骤
    this.demoSteps = [
      "🚪 主人离家，开始监控宠物行为",
      "😰 检测到宠物焦虑踱步 (焦虑指数: 5/10)",
      "🔊 检测到持续高分贝吠叫 (强度: 7/10)",
      "🎤 播放主人录音安抚: '宝贝别怕，我很快就回来'",
      "📱 向您的手机推送焦虑报告",
      "✅ 宠物情绪稳定，安抚完成"
    ];

    this.demoProgress = 0;
    this.startDemo();
  }

  // 开始演示
  startDemo() {
    // 清除之前的定时器
    if (this.demoTimer) {
      clearTimeout(this.demoTimer);
    }

    const playStep = () => {
      if (this.demoProgress < this.demoSteps.length) {
        // 显示当前步骤
        this.demoProgress++;

        // 继续下一步
        this.demoTimer = setTimeout(() => {
          playStep();
        }, 2000);
      } else {
        // 演示结束
        clearTimeout(this.demoTimer);

        // 延迟3秒后关闭演示
        this.endTimer = setTimeout(() => {
          this.showingAntiConflictDemo = false;
          this.showingHomeWatchDemo = false;
          this.demoProgress = 0;
          this.demoSteps = [];
        }, 3000);
      }
    };

    // 开始播放
    playStep();
  }

  // 处理防邻里冲突模式标题点击
  handleAntiConflictClick() {
    this.antiConflictClickCount++;

    if (this.antiConflictClickCount >= 3) {
      this.antiConflictClickCount = 0;
      this.simulateAntiConflictScenario();
    } else if (this.antiConflictClickCount === 2) {
      // 提示再点一次
      this.showHint = true;
      this.hintMessage = "再点1次开始防邻里冲突情景演示";
    }

    // 5秒后重置计数器
    clearTimeout(this.resetTimer);
    this.resetTimer = setTimeout(() => {
      this.antiConflictClickCount = 0;
      this.showHint = false;
    }, 5000);
  }

  // 处理离家守望模式标题点击
  handleHomeWatchClick() {
    this.homeWatchClickCount++;

    if (this.homeWatchClickCount >= 3) {
      this.homeWatchClickCount = 0;
      this.simulateHomeWatchScenario();
    } else if (this.homeWatchClickCount === 2) {
      // 提示再点一次
      this.showHint = true;
      this.hintMessage = "再点1次开始离家守望情景演示";
    }

    // 5秒后重置计数器
    clearTimeout(this.resetTimer);
    this.resetTimer = setTimeout(() => {
      this.homeWatchClickCount = 0;
      this.showHint = false;
    }, 5000);
  }

  // 定时器变量
  private demoTimer: number = 0;
  private endTimer: number = 0;
  private resetTimer: number = 0;
  @State showHint: boolean = false;
  @State hintMessage: string = '';

  // 清理定时器
  aboutToDisappear() {
    clearTimeout(this.demoTimer);
    clearTimeout(this.endTimer);
    clearTimeout(this.resetTimer);
  }

  build() {
    Column({ space: 20 }) {
      Text('智能场景模式')
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 30 })

      // 防邻里冲突模式
      Column({ space: 10 }) {
        Row({ space: 8 }) {
          // 模式标题 - 添加点击事件
          Column({ space: 5 }) {
            Text('🤫 防邻里冲突模式')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .onClick(() => this.handleAntiConflictClick())

            // 显示点击计数提示
            if (this.antiConflictClickCount > 0) {
              Text(`已点击 ${this.antiConflictClickCount}/3 次`)
                .fontSize(12)
                .fontColor('#2196F3')
            }
          }
          .layoutWeight(1)

          // 演示状态指示器
          if (this.showingAntiConflictDemo) {
            Row({ space: 5 }) {
              Progress({
                value: this.demoProgress * 20,
                total: 100,
                type: ProgressType.Ring
              })
                .width(20)
                .height(20)
              Text('监测中...')
                .fontSize(12)
                .fontColor('#2196F3')
            }
          }
        }
        .width('100%')

        Text('开启后仅在剧烈吠叫或高度焦虑时触发安抚，减少宠物在电梯或者户外对邻居的打扰')
          .fontSize(14)
          .fontColor('#666')
          .alignSelf(ItemAlign.Start)

        Toggle({ type: ToggleType.Switch, isOn: this.antiConflictMode })
          .onChange((isOn: boolean) => {
            this.antiConflictMode = isOn;
            promptAction.showToast({
              message: isOn ? "防邻里冲突模式已开启" : "防邻里冲突模式已关闭",
              duration: 1500
            });
          })
          .alignSelf(ItemAlign.Start)
          .margin({ left: 10 })
      }
      .width('90%')
      .padding(15)
      .backgroundColor('#F0F7FF')
      .borderRadius(16)

      // 离家守望模式
      Column({ space: 10 }) {
        Row({ space: 8 }) {
          // 模式标题 - 添加点击事件
          Column({ space: 5 }) {
            Text('🏠 离家守望模式')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)
              .onClick(() => this.handleHomeWatchClick())

            // 显示点击计数提示
          //   if (this.homeWatchClickCount > 0) {
          //     Text(`已点击 ${this.homeWatchClickCount}/3 次`)
          //       .fontSize(12)
          //       .fontColor('#2196F3')
          //   }
          }
          // .layoutWeight(1)

          // 演示状态指示器
          if (this.showingHomeWatchDemo) {
            Row({ space: 5 }) {
              Progress({
                value: this.demoProgress * 20,
                total: 100,
                type: ProgressType.Ring
              })
                .width(20)
                .height(20)
              // Text('演示中...')
              //   .fontSize(12)
              //   .fontColor('#2196F3')
            }
          }
        }
        .width('100%')

        Text('在主人离家时开启，检测到宠物异常吠叫或焦虑时，自动播放主人录音并推送提醒')
          .fontSize(14)
          .fontColor('#666')
          .alignSelf(ItemAlign.Start)

        Toggle({ type: ToggleType.Switch, isOn: this.homeWatchMode })
          .onChange((isOn: boolean) => {
            this.homeWatchMode = isOn;
            promptAction.showToast({
              message: isOn ? "离家守望模式已开启" : "离家守望模式已关闭",
              duration: 1500
            });
          })
          .alignSelf(ItemAlign.Start)
          .margin({ left: 10 })
      }
      .width('90%')
      .padding(15)
      .backgroundColor('#FFF5F5')
      .borderRadius(16)

      // 点击提示
      if (this.showHint) {
        Column({ space: 5 }) {
          Text()
            .fontSize(14)
            .fontColor('#2196F3')
            .textAlign(TextAlign.Center)
        }
        .width('90%')
        .padding(10)
        .backgroundColor('#E3F2FD')
        .borderRadius(10)
      }

      // 情景演示模块
      if (this.showingAntiConflictDemo || this.showingHomeWatchDemo) {
        Column({ space: 10 }) {
          // 演示标题
          Row({ space: 10 }) {
            Text('状况监测')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#2196F3')

            // 进度指示
            Text(`${this.demoProgress}/${this.demoSteps.length}`)
              .fontSize(12)
              .fontColor('#666')
              .backgroundColor('#E3F2FD')
              .padding({ left: 8, right: 8, top: 2, bottom: 2 })
              .borderRadius(10)
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)

          // 演示步骤区域
          Column({ space: 8 }) {
            ForEach(this.demoSteps, (step: string, index: number) => {
              // 已完成的步骤
              if (index < this.demoProgress) {
                Row({ space: 10 }) {
                  Text('✅')
                    .fontSize(16)
                  Text(step)
                    .fontSize(14)
                    .fontColor('#4CAF50')
                    .decoration({ type: TextDecorationType.LineThrough })
                }
                .width('100%')
                .padding(10)
                .backgroundColor('#E8F5E9')
                .borderRadius(8)
              }
              // 当前步骤
              else if (index === this.demoProgress) {
                Row({ space: 10 }) {
                  Text('▶️')
                    .fontSize(16)
                  Text(step)
                    .fontSize(15)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#2196F3')
                }
                .width('100%')
                .padding(12)
                .backgroundColor('#E3F2FD')
                .border({ width: 2, color: '#2196F3' })
                .borderRadius(8)
              }
              // 未开始的步骤
              else {
                Row({ space: 10 }) {
                  Text(`${index + 1}.`)
                    .fontSize(14)
                    .fontColor('#999')
                  Text(step)
                    .fontSize(14)
                    .fontColor('#999')
                }
                .width('100%')
                .padding(10)
                .backgroundColor('#F5F5F5')
                .borderRadius(8)
              }
            })
          }

          // 演示说明
          Text(this.currentDemoType === 'antiConflict'
            ? ''
            : '')
            .fontSize(12)
            .fontColor('#666')
            .lineHeight(18)
            .textAlign(TextAlign.Center)
            .margin({ top: 10 })
        }
        .width('90%')
        .padding(20)
        .backgroundColor(Color.White)
        .border({ width: 2, color: '#2196F3' })
        .borderRadius(16)
        .shadow({ radius: 10, color: '#40000000', offsetX: 0, offsetY: 2 })
      }

      // 返回按钮
      Button('返回主页面')
        .width('50%')
        .height(45)
        .backgroundColor('#78909C')
        .fontColor(Color.White)
        .onClick(() => router.back())
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F7F8FA')
  }
}