<template>
  <view class="health-page">
    <!-- 顶部标题栏 -->
    <view class="header">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left">
          <!-- 返回图标 -->
          <image class="back-icon" src="/static/icons/back.png"></image>
        </view>
        <text class="nav-title">智能戒指</text>
        <view class="nav-right">
          <!-- 设置图标 -->
          <image class="setting-icon" src="/static/icons/setting.png"></image>
        </view>
      </view>
    </view>
    
    <!-- H5适配说明：
      1. 在H5环境下，可以通过条件编译实现特定功能
      2. 可以使用window.addEventListener('resize', ...)监听窗口大小变化
      3. 可以通过navigator.userAgent判断浏览器类型
    -->

    <!-- 周日历选择器 -->
    <view class="calendar">
      <view class="calendar-item" v-for="(day, index) in weekDays" :key="index" @click="selectDate(index)">
        <text class="calendar-day" :class="{ active: day.selected }">{{ day.name }}</text>
        <text class="calendar-date" :class="{ active: day.selected }">{{ day.date }}</text>
        <view class="calendar-indicator" :class="{ active: day.selected }"></view>
      </view>
    </view>

    <!-- 快捷入口 -->
    <view class="quick-access">
      <view class="quick-item">
        <text class="quick-text">功能1</text>
      </view>
      <view class="quick-item">
        <text class="quick-text">功能2</text>
      </view>
      <view class="quick-item">
        <text class="quick-text">功能3</text>
      </view>
    </view>

    <!-- 主要内容区域 -->
    <view class="main-content">
      <!-- 待实现的内容 -->
    </view>

    <!-- 其他健康指标卡片 -->
    <view class="other-cards">
      <!-- 待实现的健康指标卡片 -->
    </view>

    <!-- 底部安全区域 -->
    <view class="bottom-safe-area"></view>

    <!-- 底部TabBar -->
    <view class="tab-bar">
      <view class="tab-item active" @click="switchTab('home')">
        <!-- 首页图标 -->
        <image class="tab-icon" src="/static/icons/home.png"></image>
        <text class="tab-label active">首页</text>
      </view>
      <view class="tab-item" @click="switchTab('health')">
        <!-- 健康图标 -->
        <image class="tab-icon" src="/static/icons/health.png"></image>
        <text class="tab-label">健康</text>
      </view>
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      weekDays: [
        { name: '周日', date: '01', selected: false },
        { name: '周一', date: '02', selected: false },
        { name: '周二', date: '03', selected: false },
        { name: '周三', date: '04', selected: true },
        { name: '周四', date: '05', selected: false },
        { name: '周五', date: '06', selected: false },
        { name: '周六', date: '07', selected: false }
      ]
    }
  },
  methods: {
    selectDate(index) {
      // 重置所有日期的选中状态
      this.weekDays.forEach(day => {
        day.selected = false;
      });
      // 设置当前选中日期
      this.weekDays[index].selected = true;
    },
    // H5适配方法
    // #ifdef H5
    onResize() {
      // H5环境下窗口大小变化时的处理逻辑
      console.log('Window resized');
    },
    // #endif
    // TabBar切换方法
    switchTab(tabName) {
      if (tabName === 'home') {
        // 切换到首页
        console.log('Switching to home tab');
        // 跳转到首页
        uni.switchTab({ url: '/pages/index/index' });
      } else if (tabName === 'health') {
        // 切换到健康页面
        console.log('Switching to health tab');
        // 根据实际情况跳转到对应的健康页面
        // 这里假设跳转到with-data页面，实际项目中可以根据需要调整
        uni.switchTab({ url: '/pages/with-data/index' });
      }
    }
  },
  mounted() {
    // H5适配：监听页面大小变化
    // #ifdef H5
    window.addEventListener('resize', this.onResize);
    // #endif
  },
  beforeDestroy() {
    // H5适配：移除事件监听器
    // #ifdef H5
    window.removeEventListener('resize', this.onResize);
    // #endif
  }
}
</script>

<style>
page {
  background-color: #0E1213;
}

.health-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #0E1213;
  
  /* H5适配：在H5环境下可能需要调整最小高度以适应浏览器窗口 */
  // #ifdef H5
  min-height: calc(100vh - var(--window-top));
  // #endif
}

/* 顶部导航栏 */
.header {
  background-color: #FFDA3C;
}

.status-bar {
  height: var(--status-bar-height, 44px);
}

.nav-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 30rpx;
}

.nav-left,
.nav-right {
  width: 120rpx;
  display: flex;
  align-items: center;
}

.nav-right {
  justify-content: flex-end;
}

.nav-title {
  font-size: 36rpx;
  font-weight: 500;
  color: #0E1213;
}

/* 图标 */
.back-icon,
.setting-icon,
.card-icon,
.tab-icon {
  width: 48rpx;
  height: 48rpx;
}

.card-icon {
  background-color: rgba(255, 218, 60, 0.3);
  border-radius: 8rpx;
}

.tab-icon {
  margin-bottom: 8rpx;
}

/* 周日历选择器 */
.calendar {
  display: flex;
  flex-direction: row;
  background-color: #FFDA3C;
  border-radius: 0 0 32rpx 32rpx;
  padding: 20rpx 0;
  margin: 0 30rpx;
}

.calendar-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
}

.calendar-day {
  font-size: 24rpx;
  color: #A4A4A4;
  margin-bottom: 8rpx;
}

.calendar-date {
  font-size: 24rpx;
  color: #A4A4A4;
  margin-bottom: 8rpx;
}

.calendar-indicator {
  width: 48rpx;
  height: 4rpx;
  background-color: transparent;
  border-radius: 2rpx;
}

.calendar-day.active,
.calendar-date.active {
  color: #255FBE;
  font-weight: bold;
}

.calendar-indicator.active {
  background-color: #255FBE;
}

/* 主要内容区域 */
.main-content {
  flex: 1;
  margin: 0 30rpx 30rpx;
}

/* 其他健康指标卡片 */
.other-cards {
  margin: 0 30rpx;
}

/* 快捷入口 */
.quick-access {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 30rpx;
  gap: 20rpx;
  margin: 0 30rpx 30rpx;
}

.quick-item {
  flex: 1;
  background-color: #1F1F1E;
  border-radius: 20rpx;
  padding: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quick-text {
  font-size: 28rpx;
  color: #FBFBFB;
}

/* 顶部导航栏 */
.header {
  background-color: #FFDA3C;
}

.status-bar {
  height: var(--status-bar-height, 44px);
}

.nav-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 30rpx;
}

.nav-left,
.nav-right {
  width: 120rpx;
  display: flex;
  align-items: center;
}

.nav-right {
  justify-content: flex-end;
}

.nav-title {
  font-size: 36rpx;
  font-weight: 500;
  color: #0E1213;
}

/* 图标 */
.back-icon,
.setting-icon,
.tab-icon {
  width: 48rpx;
  height: 48rpx;
}

.tab-icon {
  margin-bottom: 8rpx;
}

/* 底部安全区域 */
.bottom-safe-area {
  height: 200rpx;
  
  /* H5适配：在H5环境下可能需要调整底部安全区域的高度 */
  // #ifdef H5
  height: calc(200rpx + env(safe-area-inset-bottom, 0px));
  // #endif
}

/* 底部TabBar */
.tab-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  flex-direction: row;
  background-color: #2F2E2D;
  border-radius: 32rpx 32rpx 0 0;
  padding: 20rpx 0;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  box-shadow: 0 -8rpx 8rpx rgba(0, 0, 0, 0.08);
  
  /* H5适配：在H5环境下可能需要调整定位 */
  // #ifdef H5
  position: sticky;
  // #endif
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.tab-label {
  font-size: 24rpx;
  color: #A4A4A4;
}

.tab-label.active {
  color: #FFDA3C;
}
</style>