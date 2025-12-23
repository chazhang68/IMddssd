<template>
  <view class="sleep-card">
    <view class="card-header">
      <image class="card-icon" src="/static/icons/sleep@2x.png"></image>
      <text class="card-title">睡眠</text>
    </view>

    <view>
      <view class="chart-area">
        <view class="chart-placeholder">
          <view class="chart-bar" v-for="(bar, idx) in chartBars" :key="idx"
                :style="{ height: bar.height, background: bar.color }"></view>
        </view>
      </view>
      <view class="time-axis">
        <text class="time-text">{{ hasData ? timeAxis.start : '入睡' }}</text>
        <text class="time-text">{{ hasData ? timeAxis.end : '醒来' }}</text>
      </view>

      <view class="stages-grid">
        <view class="stage-item" v-for="(item, index) in stagesDisplay" :key="index">
          <view class="stage-icon-box" :style="{ backgroundColor: item.bgColor }">
            <image class="stage-icon-placeholder" :src="item.icon"/>
          </view>
          <view class="stage-info">
            <text class="stage-name">{{ item.name }}</text>
            <text class="stage-val">{{ item.duration }}</text>
          </view>
        </view>
      </view>

      <view class="analysis-section">
        <text class="section-title">睡眠分析</text>
        <view class="analysis-card">
          <view class="analysis-row" v-for="(item, index) in analysisListDisplay" :key="'analysis-'+index"
                @click="handleAnalysisClick(item)">
            <view class="row-content">
              <text class="row-main">{{ item.title }}: {{ item.value }}</text>
              <text class="row-sub">{{ item.ref }}</text>
            </view>
            <text v-if="item.status" class="status-tag" :class="item.statusType">{{ item.status }}</text>
          </view>
          <view class="analysis-row sporadic-row" v-for="(item, index) in sporadicDisplay" :key="'sporadic-'+index" v-if="sporadicDisplay.length>1"
                @click="handleSporadicClick(item)">
            <view class="sporadic-left">
              <text class="sporadic-label">零星睡眠</text>
              <text class="sporadic-time">{{ item.time }}</text>
            </view>
            <text class="sporadic-duration">{{ item.duration }}</text>
          </view>
        </view>
      </view>

      <view class="advice-card" v-if="adviceDisplay.title || adviceDisplay.content || analysis">
        <text class="advice-title">{{ adviceDisplay.title || '睡眠分析' }}</text>
        <text class="advice-content" v-if="hasData">{{ adviceDisplay.content || analysis }}</text>
      </view>

    </view>
  </view>
</template>

<script>
export default {
  name: 'SleepCard',
  props: {
    stats: {
      type: Array,
      default: () => []
    },
    analysis: {
      type: String,
      default: ''
    },
    analysisList: {
      type: Array,
      default: () => []
    },
    sporadicSleep: {
      type: Array,
      default: () => []
    },
    advice: {
      type: Object,
      default: () => ({title: '', content: ''})
    },
    timeRange: {
      type: Object,
      default: () => null
    },
    hasData: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    chartBars() {
      if (!this.hasData) {
        return [
          {height: '0%', color: '#3C3C3C'},
          {height: '0%', color: '#3C3C3C'},
          {height: '0%', color: '#3C3C3C'},
          {height: '0%', color: '#3C3C3C'},
          {height: '0%', color: '#3C3C3C'},
          {height: '0%', color: '#3C3C3C'},
          {height: '0%', color: '#3C3C3C'},
          {height: '0%', color: '#3C3C3C'}
        ]
      }
      return [
        {height: '40%', color: '#6B66FA'},
        {height: '60%', color: '#3BCFD2'},
        {height: '30%', color: '#9F8BF8'},
        {height: '80%', color: '#FFDA3C'},
        {height: '50%', color: '#6B66FA'},
        {height: '70%', color: '#9F8BF8'},
        {height: '20%', color: '#3BCFD2'},
        {height: '90%', color: '#6B66FA'}
      ]
    },
    timeAxis() {
      if (this.timeRange && this.timeRange.start && this.timeRange.end) {
        return {start: this.timeRange.start, end: this.timeRange.end}
      }
      return this.hasData ? {start: '23:14', end: '05:18'} : {start: '00:00', end: '00:00'}
    },
    stagesDisplay() {
      const list = Array.isArray(this.stats) ? this.stats : []
      if (!this.hasData) {
        return [
          {name: '深睡', duration: '0时0分', icon: '/static/icons/sleep@2x(1).png', bgColor:'#4C4489'},
          {name: '浅睡', duration: '0时0分', icon: '/static/icons/light@2x.png', bgColor: '#9C93FF'},
          {name: '快速眼动', duration: '0时0分', icon: '/static/icons/eye@2x.png', bgColor: '#2CBBB6'},
          {name: '清醒', duration: '0时0分', icon: '/static/icons/sun-line@2x.png', bgColor: '#FFDA3C'}
        ]
      }
      return list.map(item => {
        const color = item.color || '#6B66FA'
        return {
          name: item.name || '',
          duration: item.value || '',
          color,
          bgColor: this.hexToAlpha(color, 0.15)
        }
      })
    },
    analysisListDisplay() {
      const list = Array.isArray(this.analysisList) ? this.analysisList : []
      if (!this.hasData) {
        return [
          {title: '睡眠时长', value: '0时0分', ref: '参考值: 6-10时', status: '', statusType: 'normal', url: ''},
          {title: '深睡比例', value: '0%', ref: '参考值: 20%-60%', status: '', statusType: 'normal', url: ''},
          {title: '浅睡比例', value: '0%', ref: '参考值: <55%', status: '', statusType: 'normal', url: ''},
          {title: '快速眼动比例', value: '0%', ref: '参考值: 10%-30%', status: '', statusType: 'normal', url: ''},
          {title: '清醒次数', value: '0', ref: '参考值: 0-2次', status: '', statusType: 'normal', url: ''}
        ]
      }
      return list
    },
    sporadicDisplay() {
      const list = Array.isArray(this.sporadicSleep) ? this.sporadicSleep : []
      if (!this.hasData) {
        return [{time: '00:00-00:00', duration: '0时0分'}]
      }
      return list
    },
    haveAnalysisRows() {
      return this.analysisListDisplay.length > 0 || this.sporadicDisplay.length > 0
    },
    adviceDisplay() {
      const adv = this.advice || {}
      return {title: adv.title || '', content: adv.content || ''}
    }
  },
  methods: {
    hexToAlpha(hex, alpha) {
      let h = hex.replace('#', '')
      if (h.length === 3) {
        h = h.split('').map(c => c + c).join('')
      }
      const r = parseInt(h.slice(0, 2), 16)
      const g = parseInt(h.slice(2, 4), 16)
      const b = parseInt(h.slice(4, 6), 16)
      return `rgba(${r}, ${g}, ${b}, ${alpha})`
    },
    handleAnalysisClick(item) {
      if (!this.hasData) return
      if (item && item.url && typeof uni !== 'undefined' && uni && typeof uni.navigateTo === 'function') {
        uni.navigateTo({url: item.url})
      }
    },
    handleSporadicClick(item) {
      if (!this.hasData) return
      if (item && typeof uni !== 'undefined' && uni && typeof uni.navigateTo === 'function') {
        const time = encodeURIComponent(item.time || '')
        const duration = encodeURIComponent(item.duration || '')
        uni.navigateTo({url: `/pages/sleep/detail?type=sporadic&time=${time}&duration=${duration}`})
      }
    }
  }
}
</script>

<style scoped>
.sleep-card {
  background-color: #1F1F1E;
  border-radius: 68rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.card-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 38rpx;
}

.card-icon {
  width: 48rpx;
  height: 48rpx;
}

.card-title {
  font-weight: 500;
  font-size: 32rpx;
  color: #FFDA3C;
}

.chart-area {
  height: 200rpx;
  background-color: #151515;
  border-radius: 12rpx;
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
  margin-bottom: 12rpx;
}

.time-text {
  font-size: 20rpx;
}

.stages-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16rpx;
  margin: 48rpx 0 34rpx 0;
}

.stage-item {
  background-color: #1f1f1e;
  border-radius: 38rpx;
  border: 2rpx solid #A4A4A4;
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
  width: 40rpx;
  height: 40rpx;
}

.stage-info {
  display: flex;
  flex-direction: column;
}

.stage-name {
  font-weight: bold;
  font-size: 14px;
  color: #FBFBFB;
}

.stage-val {
  font-weight: 400;
  font-size: 12px;
  color: #A4A4A4;
}

.analysis-section {
  margin-top: 10rpx;
}

.section-title {
  font-weight: 500;
  font-size: 32rpx;
  color: #FBFBFB;
}

.analysis-card {
  background-color: #1f1f1e;
  border-radius: 32rpx;
  overflow: hidden;
}

.analysis-row {
  padding: 32rpx 40rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
  border-radius: 38rpx;
  border: 1rpx solid #A4A4A4;
  margin-top: 16rpx;
}

.row-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.row-main {
  font-size: 28rpx;
  color: #fbfbfb;
  font-weight: 500;
}

.row-sub {
  font-size: 24rpx;
  color: #A4A4A4;
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

.advice-card {
  margin-top: 16rpx;
  background-color: #2F2E2D;
  border-radius: 40rpx;
  padding: 24rpx;
  border: 2rpx solid #3C3C3C;
}

.advice-title {
  font-size: 12px;
  color: #A4A4A4;
  margin-bottom: 12rpx;
}

.advice-content {
  font-size: 22rpx;
  color: rgba(255, 255, 255, 0.6);
  line-height: 1.6;
}
</style>
