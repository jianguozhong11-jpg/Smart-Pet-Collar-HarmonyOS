// 文件：entry/src/main/ets/pages/DeviceDiscovery.ets
import promptAction from '@ohos.promptAction';
import router from '@ohos.router';

// 定义明确的设备强类型
interface Device {
  id: string;
  name: string;
  type: string;
  status: '在线' | '可连接' | '离线' | '连接中' | '已连接';
  signal: number;
}
// 构想，不仅仅是可以链接手机，更可以链接搭载鸿蒙系统的其他设备，例如搭配喂食器去维持宠物健康状态，或者是可以链接手表更好地实时接收到宠物状态。
// 提取公共样式
@Styles function deviceCardStyle() {
  .padding(12)
  .backgroundColor('#FFFFFF')
  .borderRadius(12)
  .width('100%')
}

@Styles function sectionStyle() {
  .width('90%')
  .padding(15)
  .borderRadius(16)
}

@Styles function smallButtonStyle() {
  .width('60%')
  .height(30)
  // .fontSize(20)
  // .fontColor('#FFFFFF')
}

// 封装公共设备卡片组件
@Component
struct DeviceCard {
  @Prop device: Device;
  onConnect?: (device: Device) => void;
  onDisconnect?: (device: Device) => void;

  build() {
    Row({ space: 15 }) {
      // 设备图标
      Text(this.device.type)
        .fontSize(24)

      // 设备信息
      Column({ space: 3 }) {
        Text(this.device.name)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Row({ space: 8 }) {
          // 状态指示灯
          Circle()
            .width(6)
            .height(6)
            .fill(this.getStatusColor())
          // 状态文本
          Text(this.device.status)
            .fontSize(12)
            .fontColor(this.getStatusColor())
          // 信号强度
          Text(`信号: ${this.device.signal}%`)
            .fontSize(12)
            .fontColor('#666666')
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 操作按钮
      if (this.device.status === '已连接' && this.onDisconnect !== undefined) {
        Button('断开')
          .smallButtonStyle()
          .backgroundColor('#F44336')
          .onClick(() => {
            if (this.onDisconnect) {
              this.onDisconnect(this.device);
            }
          })
      } else if (this.device.status === '可连接' && this.onConnect !== undefined) {
        Button('连接')
          .smallButtonStyle()
          .backgroundColor('#4CAF50')
          .onClick(() => {
            if (this.onConnect) {
              this.onConnect(this.device);
            }
          })
      } else if (this.device.status === '连接中') {
        LoadingProgress()
          .width(30)
          .height(30)
          .color('#2196F3')
      } else {
        Button(this.device.status)
          .smallButtonStyle()
          .backgroundColor('#9E9E9E')
          .enabled(false)
      }
    }
    .deviceCardStyle()
  }

  // 封装状态颜色获取逻辑
  private getStatusColor(): string {
    switch (this.device.status) {
      case '在线':
      case '已连接':
        return '#4CAF50';
      case '可连接':
        return '#2196F3';
      case '连接中':
        return '#FF9800';
      case '离线':
      default:
        return '#9E9E9E';
    }
  }
}

@Entry
@Component
struct DeviceDiscovery {
  // 初始化带唯一 id 的设备列表
  @State availableDevices: Device[] = [
    { id: 'device-1', name: '智能项圈', type: '🐕', status: '已连接', signal: 85 },
    { id: 'device-2', name: '智慧屏', type: '📺', status: '已连接', signal: 90 },
    { id: 'device-3', name: '智能手表', type: '⌚', status: '可连接', signal: 70 },
    { id: 'device-4', name: '宠物摄像头', type: '📹', status: '离线', signal: 0 }
  ];

  // 已连接设备通过 computed 从 availableDevices 筛选
  @State connectedDevices: Device[] = [];

  // 搜索状态
  @State isSearching: boolean = false;
  @State searchProgress: number = 0;

  // 页面初始化时同步已连接设备
  aboutToAppear() {
    this.syncConnectedDevices();
  }

  build() {
    Column({ space: 20 }) {
      // 标题栏
      Column() {
        Text('鸿蒙设备发现与连接')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
        Text('超级终端 · 一键组网')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 5 })
      }
      .margin({ top: 30 })

      // 设备搜索区域
      Column({ space: 10 }) {
        Text('🔍 设备发现')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        Button('搜索附近设备')
          .width('100%')
          .height(50)
          .backgroundColor('#2196F3')
          .enabled(!this.isSearching)
          .onClick(() => this.startDeviceDiscovery())

        // 搜索进度条
        if (this.isSearching) {
          Column({ space: 5 }) {
            Progress({ value: this.searchProgress, total: 100, type: ProgressType.Linear })
              .width('100%')
              .color('#2196F3')
            Text(`搜索中... ${this.searchProgress}%`)
              .fontSize(12)
              .fontColor('#666666')
          }
        }
      }
      .sectionStyle()
      .backgroundColor('#F0F7FF')

      // 已连接设备区域
      Column({ space: 10 }) {
        Text('✅ 已连接设备')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        if (this.connectedDevices.length === 0) {
          Text('暂无已连接设备')
            .fontSize(14)
            .fontColor('#999999')
            .padding(20)
        } else {
          Column({ space: 8 }) {
            ForEach(this.connectedDevices, (device: Device) => {
              DeviceCard({
                device: device,
                onDisconnect: (d: Device) => {
                  this.disconnectDevice(d);
                }
              })
            }, (device: Device) => device.id)
          }
        }
      }
      .sectionStyle()
      .backgroundColor('#E8F5E9')

      // 可用设备区域
      Column({ space: 10 }) {
        Text('📱 可用设备')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)

        if (this.availableDevices.length === 0) {
          Text('未发现可用设备')
            .fontSize(14)
            .fontColor('#999999')
            .padding(20)
        } else {
          Column({ space: 8 }) {
            ForEach(this.availableDevices, (device: Device) => {
              DeviceCard({
                device: device,
                onConnect: (d: Device) => {
                  this.connectDevice(d);
                },
                onDisconnect: (d: Device) => {
                  this.disconnectDevice(d);
                }
              })
            }, (device: Device) => device.id)
          }
        }
      }
      .sectionStyle()
      .backgroundColor('#FFF3E0')

      // 返回按钮
      Button('返回主页面')
        .width('50%')
        .height(45)
        .backgroundColor('#78909C')
        .margin({ top: 10 })
        .onClick(() => router.back())
    }
    .width('100%')
    .height('100%')
    .padding(15)
    .backgroundColor('#F7F8FA')
  }

  // 同步已连接设备
  private syncConnectedDevices() {
    this.connectedDevices = this.availableDevices.filter(d => d.status === '已连接');
  }

  // 开始搜索设备
  private startDeviceDiscovery() {
    promptAction.showToast({
      message: "开始搜索附近的鸿蒙设备...",
      duration: 1500
    });

    this.isSearching = true;
    this.searchProgress = 0;

    const timer = setInterval(() => {
      this.searchProgress += 20;

      if (this.searchProgress >= 100) {
        clearInterval(timer);
        this.isSearching = false;

        // 浅拷贝原数组，保留已连接设备状态
        const newDevices = [...this.availableDevices];
        // 模拟发现新设备
        const newDeviceIds = ['device-5', 'device-6'];
        const newDeviceNames = ['智能音箱', '智能喂食器'];
        const newDeviceTypes = ['🔊', '🍖'];
        newDeviceIds.forEach((id, index) => {
          if (!newDevices.some(d => d.id === id)) {
            newDevices.push({
              id: id,
              name: newDeviceNames[index],
              type: newDeviceTypes[index],
              status: '可连接',
              signal: 60 + Math.floor(Math.random() * 30)
            });
          }
        });
        // 模拟离线设备上线
        newDevices.forEach(d => {
          if (d.status === '离线' && Math.random() > 0.5) {
            d.status = '可连接';
            d.signal = 50 + Math.floor(Math.random() * 40);
          }
        });

        this.availableDevices = newDevices;
        this.syncConnectedDevices();

        promptAction.showToast({
          message: `发现${newDevices.length}个可用设备`,
          duration: 2000
        });
      }
    }, 300);
  }

  // 连接设备
  private connectDevice(device: Device) {
    if (device.status !== '可连接') return;

    // 浅拷贝数组
    const newDevices = [...this.availableDevices];
    // 找到目标设备索引
    const targetIndex = newDevices.findIndex(d => d.id === device.id);
    if (targetIndex === -1) return;

    // 更新状态为连接中
    newDevices[targetIndex].status = '连接中';
    this.availableDevices = newDevices;
    this.syncConnectedDevices();

    promptAction.showToast({
      message: `正在连接${device.name}...`,
      duration: 1500
    });

    // 模拟连接成功
    setTimeout(() => {
      const finalDevices = [...this.availableDevices];
      finalDevices[targetIndex].status = '已连接';
      this.availableDevices = finalDevices;
      this.syncConnectedDevices();

      promptAction.showToast({
        message: `${device.name}连接成功！`,
        duration: 1500
      });
    }, 2000);
  }

  // 断开设备连接
  private disconnectDevice(device: Device) {
    if (device.status !== '已连接') return;

    promptAction.showToast({
      message: `正在断开${device.name}...`,
      duration: 1500
    });

    // 浅拷贝数组
    const newDevices = [...this.availableDevices];
    // 找到目标设备索引
    const targetIndex = newDevices.findIndex(d => d.id === device.id);
    if (targetIndex === -1) return;

    // 更新状态为可连接
    newDevices[targetIndex].status = '可连接';
    this.availableDevices = newDevices;
    this.syncConnectedDevices();

    setTimeout(() => {
      promptAction.showToast({
        message: `${device.name}已断开连接`,
        duration: 1500
      });
    }, 1000);
  }
}