<template>
  <view class="sleep-page">
    <view class="header-section">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left" @click="handleBack">
          <image class="nav-icon" src="/static/images/blood-pressure/right@2x.png" style="transform: rotate(180deg);" mode="aspectFit" />
        </view>
        <text class="nav-title">睡眠</text>
        <view class="nav-right"></view>
      </view>
    </view>

    <view class="date-switcher">
      <view class="date-arrow" @click="changeDate(-1)">
        <text class="arrow-text">‹</text>
      </view>
      <text class="date-text">{{ currentDate }}</text>
      <view class="date-arrow" @click="changeDate(1)">
        <text class="arrow-text">›</text>
      </view>
    </view>

    <view class="content">
      <!-- 睡眠图表卡片 -->
      <view class="chart-card">
        <view class="card-header">
          <image class="card-icon" src="/static/images/blood-pressure/img-B1@2x.png" mode="aspectFit" /> <!-- 占位图标 -->
          <text class="card-title">睡眠</text>
        </view>
        <view class="chart-area">
          <!-- 柱状图占位 -->
          <view class="chart-placeholder">
             <view class="chart-bar" style="height: 40%; background: #6B66FA;"></view>
             <view class="chart-bar" style="height: 60%; background: #3BCFD2;"></view>
             <view class="chart-bar" style="height: 30%; background: #9F8BF8;"></view>
             <view class="chart-bar" style="height: 80%; background: #FFDA3C;"></view>
             <view class="chart-bar" style="height: 50%; background: #6B66FA;"></view>
             <view class="chart-bar" style="height: 70%; background: #9F8BF8;"></view>
             <view class="chart-bar" style="height: 20%; background: #3BCFD2;"></view>
             <view class="chart-bar" style="height: 90%; background: #6B66FA;"></view>
          </view>
        </view>
        <view class="time-axis">
          <text>23:14</text>
          <text>05:18</text>
        </view>
      </view>

      <!-- 睡眠阶段网格 -->
      <view class="stages-grid">
        <view class="stage-item" v-for="(item, index) in sleepStages" :key="index">
          <view class="stage-icon-box" :style="{ backgroundColor: item.bgColor }">
            <!-- 简单的图标占位 -->
            <view class="stage-icon-placeholder" :style="{ borderColor: item.color }"></view>
          </view>
          <view class="stage-info">
            <text class="stage-name">{{ item.name }}</text>
            <text class="stage-val">{{ item.duration }}</text>
          </view>
        </view>
      </view>

      <!-- 睡眠分析 -->
      <view class="analysis-section">
        <text class="section-title">睡眠分析</text>
        
        <view class="analysis-card">
          <!-- 列表项 -->
          <view 
            class="analysis-row" 
            v-for="(item, index) in analysisList" 
            :key="'analysis-'+index"
            @click="handleAnalysisClick(item)"
          >
            <view class="row-content">
              <text class="row-main">{{ item.title }}: {{ item.value }}</text>
              <text class="row-sub">{{ item.ref }}</text>
            </view>
            <text class="status-tag" :class="item.statusType">{{ item.status }}</text>
          </view>

          <!-- 零星睡眠 -->
          <view 
            class="analysis-row sporadic-row" 
            v-for="(item, index) in sporadicSleep" 
            :key="'sporadic-'+index"
            @click="handleSporadicClick(item)"
          >
             <view class="sporadic-left">
               <text class="sporadic-label">零星睡眠</text>
               <text class="sporadic-time">{{ item.time }}</text>
             </view>
             <text class="sporadic-duration">{{ item.duration }}</text>
          </view>
        </view>
      </view>

      <!-- 睡眠建议 -->
      <view class="advice-card">
        <text class="advice-title">{{ advice.title }}</text>
        <text class="advice-content">{{ advice.content }}</text>
      </view>

      <view class="bottom-safe-area"></view>
    </view>
  </view>
</template>

<script setup lang="ts">
const currentDate = '10月28日'

interface SleepStage {
  name: string
  duration: string
  color: string
  bgColor: string
}

interface AnalysisItem {
  title: string
  value: string
  ref: string
  status: string
  statusType: 'normal' | 'low' | 'high'
  url?: string
}

const sleepStages: SleepStage[] = [
  { name: '深睡', duration: '1时45分', color: '#6B66FA', bgColor: 'rgba(107, 102, 250, 0.15)' },
  { name: '浅睡', duration: '2时5分', color: '#9F8BF8', bgColor: 'rgba(159, 139, 248, 0.15)' },
  { name: '快速眼动', duration: '1时10分', color: '#3BCFD2', bgColor: 'rgba(59, 207, 210, 0.15)' },
  { name: '清醒', duration: '1时0分', color: '#FFDA3C', bgColor: 'rgba(255, 218, 60, 0.15)' }
]

const analysisList: AnalysisItem[] = [
  { title: '睡眠时长', value: '5时35分', ref: '参考值: 6-10时', status: '偏低', statusType: 'low', url: '/pages/sleep/detail?type=duration' },
  { title: '深睡比例', value: '42%', ref: '参考值: 20%-60%', status: '正常', statusType: 'normal', url: '/pages/sleep/detail?type=deep' },
  { title: '浅睡比例', value: '43%', ref: '参考值: <55%', status: '正常', statusType: 'normal', url: '/pages/sleep/detail?type=light' },
  { title: '快速眼动比例', value: '15%', ref: '参考值: 10%-30%', status: '正常', statusType: 'normal', url: '/pages/sleep/detail?type=rem' },
  { title: '清醒次数', value: '5', ref: '参考值: 0-2次', status: '偏高', statusType: 'high', url: '/pages/sleep/detail?type=awake' },
]

const sporadicSleep = [
  { time: '12:32-12:42', duration: '0时10分' },
  { time: '12:42-13:12', duration: '0时30分' }
]

const advice = {
  title: '睡眠质量较差',
  content: '深睡时长不足：入睡时间过晚尝试规律作息，为睡眠创造安静、黑暗的环境。坚持一些睡眠前放松练习，能有效帮助加深睡眠。'
}

const uniApi = (globalThis as unknown as { uni?: any }).uni

const handleBack = (): void => {
  if (uniApi?.navigateBack) {
    uniApi.navigateBack()
    return
  }
  if (typeof history !== 'undefined' && history.length > 1) {
    history.back()
  }
}

const changeDate = (diff: number) => {
  console.log('change date', diff)
}

const handleAnalysisClick = (item: AnalysisItem) => {
  if (item.url && uniApi?.navigateTo) {
    uniApi.navigateTo({ url: item.url })
  }
}

const handleSporadicClick = (item: any) => {
  if (uniApi?.navigateTo) {
    uniApi.navigateTo({
      url: `/pages/sleep/detail?type=sporadic&time=${item.time}&duration=${item.duration}`
    })
  }
}
</script>

<style scoped lang="scss">
.sleep-page {
  min-height: 100vh;
  background-color: #0e1213;
  display: flex;
  flex-direction: column;
}

.header-section {
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

.nav-left, .nav-right {
  width: 80rpx;
  display: flex;
  align-items: center;
}

.nav-icon {
  width: 44rpx;
  height: 44rpx;
}

.nav-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #0e1213;
}

.date-switcher {
  margin: 30rpx 30rpx 0;
  height: 80rpx;
  background-color: #FFDA3C;
  border-radius: 40rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 0 20rpx;
  border: 1rpx solid rgba(0,0,0,0.1);
}

.date-arrow {
  width: 60rpx;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.arrow-text {
  font-size: 40rpx;
  color: #0e1213;
  font-weight: 300;
  margin-top: -6rpx;
}

.date-text {
  font-size: 26rpx;
  color: #0e1213;
}

.content {
  flex: 1;
  border-radius: 60rpx;
  background: #1f1f1e;
  margin: 15rpx 30rpx;
  padding: 34rpx;
}

/* 图表卡片 */
.chart-card {
  background-color: #1f1f1e;
  border-radius: 32rpx;
}

.card-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-bottom: 30rpx;
}

.card-icon {
  width: 32rpx;
  height: 32rpx;
  margin-right: 12rpx;
  opacity: 0.8;
}

.card-title {
  font-size: 28rpx;
  color: #FFDA3C;
  font-weight: 600;
}

.chart-area {
  height: 200rpx;
  background-color: #151515;
  border-radius: 8rpx;
  margin-bottom: 12rpx;
  overflow: hidden;
  position: relative;
}

.chart-placeholder {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: space-around;
  height: 100%;
  padding: 0 10rpx;
}

.chart-bar {
  width: 10%;
  border-top-left-radius: 4rpx;
  border-top-right-radius: 4rpx;
}

.time-axis {
  display: flex;
  justify-content: space-between;
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.4);
}

/* 阶段网格 */
.stages-grid {
  margin-top: 24rpx;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20rpx;
}

.stage-item {
  background-color: #1f1f1e;
  border-radius: 38rpx;
  border: 1rpx solid #A4A4A4;
  padding: 24rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
}

.stage-icon-box {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 20rpx;
}

.stage-icon-placeholder {
  width: 32rpx;
  height: 32rpx;
  border: 4rpx solid;
  border-radius: 50%;
}

.stage-info {
  display: flex;
  flex-direction: column;
}

.stage-name {
  font-size: 26rpx;
  color: #fbfbfb;
  font-weight: 600;
}

.stage-val {
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 4rpx;
}

/* 分析部分 */
.analysis-section {
  margin-top: 30rpx;
}

.section-title {
  font-size: 31rpx;
  color: #FBFBFB;
  margin-bottom: 20rpx;
  display: block;
}

.analysis-card {
  background-color: #1f1f1e;
  border-radius: 32rpx;
  overflow: hidden;
}

.analysis-row {
  padding: 30rpx 24rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
  border-radius: 38rpx;
  border: 1rpx solid #A4A4A4;
  margin-bottom: 16rpx;
}

.row-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.row-main {
  font-size: 27rpx;
  color: #fbfbfb;
  font-weight: 500;
}

.row-sub {
  font-size: 23rpx;
  color: #A4A4A4;
  margin-top: 4rpx;
}

.status-tag {
  font-size: 27rpx;
  font-weight: 600;
}

.status-tag.low, .status-tag.high {
  color: #FF5B5B;
}

.status-tag.normal {
  color: #4A90E2;
}

/* 零星睡眠行 */
.sporadic-row {
  justify-content: space-between;
}

.sporadic-left {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.sporadic-label {
  font-size: 27rpx;
  color: #fbfbfb;
  margin-right: 20rpx;
}

.sporadic-time {
  font-size: 27rpx;
  color: #fbfbfb;
}

.sporadic-duration {
  font-size: 27rpx;
  color: #fbfbfb;
}

/* 建议卡片 */
.advice-card {
  background-color: #2F2E2D;
  border-radius: 38rpx;
  padding: 30rpx;
}

.advice-title {
  font-size: 27rpx;
  color: #fbfbfb;
  font-weight: bold;
  margin-bottom: 12rpx;
  display: block;
}

.advice-content {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.6);
  line-height: 1.6;
}

</style>
