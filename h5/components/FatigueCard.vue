<template>
  <view class="fatigue-card">
    <view class="card-header">
      <image class="card-icon" src="/static/icons/fatigue.png"></image>
      <text class="card-title">疲劳</text>
    </view>
    
    <template v-if="hasData">
      <view class="fatigue-chart">
        <view class="chart-y-axis">
          <text class="axis-label">100</text>
          <text class="axis-label">80</text>
          <text class="axis-label">60</text>
          <text class="axis-label">40</text>
          <text class="axis-label">20</text>
          <text class="axis-label">0</text>
        </view>
        <view class="chart-content">
          <!-- TODO: 添加疲劳图表 -->
          <text class="chart-placeholder">图表区域</text>
        </view>
      </view>
      <view class="chart-x-axis">
        <text class="axis-label">00:00</text>
        <text class="axis-label">06:00</text>
        <text class="axis-label">12:00</text>
        <text class="axis-label">18:00</text>
        <text class="axis-label">24:00</text>
      </view>
      
      <view class="fatigue-stats">
        <view class="stat-item" v-for="(item, index) in stats" :key="index">
          <text class="stat-value">{{ item.value }}</text>
          <text class="stat-name">{{ item.name }}</text>
        </view>
      </view>
      
      <view class="fatigue-distribution">
        <view class="distribution-item" v-for="(item, index) in distribution" :key="index">
          <view class="item-dot" :style="{ background: item.color }"></view>
          <text class="item-name">{{ item.name }}</text>
          <text class="item-percent">{{ item.percent }}</text>
        </view>
      </view>
      
      <view class="fatigue-analysis" v-if="analysis">
        <text class="analysis-title">疲劳分析</text>
        <text class="analysis-desc">{{ analysis }}</text>
      </view>
    </template>
    
    <view v-else class="empty-state">
      <text class="empty-text">暂无疲劳数据</text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'FatigueCard',
  props: {
    stats: {
      type: Array,
      default: () => []
    },
    distribution: {
      type: Array,
      default: () => []
    },
    analysis: {
      type: String,
      default: ''
    },
    hasData: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style scoped>
.fatigue-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.card-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 30rpx;
}

.card-icon {
  width: 48rpx;
  height: 48rpx;
  background-color: rgba(255, 218, 60, 0.3);
  border-radius: 8rpx;
}

.card-title {
  font-size: 32rpx;
  color: #FFDA3C;
  font-weight: bold;
}

.fatigue-chart {
  display: flex;
  flex-direction: row;
  height: 200rpx;
  margin-bottom: 20rpx;
}

.chart-y-axis {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  width: 60rpx;
  padding-right: 10rpx;
}

.chart-content {
  flex: 1;
  background-color: #0E1213;
  border-radius: 20rpx;
  border: 1rpx solid #5D5D5D;
  display: flex;
  align-items: center;
  justify-content: center;
}

.axis-label {
  font-size: 20rpx;
  color: #A4A4A4;
}

.chart-x-axis {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-bottom: 30rpx;
}

.fatigue-stats {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-bottom: 30rpx;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
  width: calc(33.33% - 14rpx);
  box-sizing: border-box;
}

.stat-name {
  font-size: 24rpx;
  color: #A4A4A4;
}

.stat-value {
  font-size: 28rpx;
  color: #FBFBFB;
  font-weight: bold;
  margin-bottom: 8rpx;
}

.fatigue-distribution {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.distribution-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  width: calc(50% - 10rpx);
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
  box-sizing: border-box;
}

.item-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  margin-right: 10rpx;
}

.item-name,
.item-percent {
  font-size: 24rpx;
  color: #A4A4A4;
  flex: 1;
}

.fatigue-analysis {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

.analysis-title {
  font-size: 28rpx;
  color: #FBFBFB;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.analysis-desc {
  font-size: 24rpx;
  line-height: 1.6;
  color: #A4A4A4;
}

.empty-state {
  padding: 40rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  border: 1rpx solid #3C3C3C;
}

.empty-text {
  color: #A4A4A4;
  font-size: 28rpx;
}

.chart-placeholder {
  color: #5D5D5D;
  font-size: 24rpx;
}
</style>
