<template>
  <view class="common-health-card">
    <view class="card-header">
      <view class="title-row">
        <image class="card-icon" :src="icon"></image>
        <text class="card-title">{{ title }}</text>
      </view>
      <template v-if="hasData">
        <view class="value-row">
          <text class="value-text">{{ value }}</text>
          <text class="unit-text">{{ unit }}</text>
        </view>
      </template>
    </view>
    
    <template v-if="hasData">
      <view class="card-content">
        <view class="chart-area">
          <text class="chart-placeholder">图表区域</text>
        </view>
        <view class="status-row" v-if="range || status">
          <text class="range-text" v-if="range">范围：{{ range }}</text>
          <text class="status-text" v-if="status" :style="{ color: statusColor }">{{ status }}</text>
        </view>
        <view class="stats-row" v-if="stats && stats.length > 0">
          <view class="stat-item" v-for="(item, index) in stats" :key="index">
            <text class="stat-value">{{ item.value }}</text>
            <text class="stat-name">{{ item.name }}</text>
          </view>
        </view>
        <view class="analysis-section" v-if="analysis">
          <text class="analysis-title">{{ title }}分析</text>
          <text class="analysis-desc">{{ analysis }}</text>
        </view>
      </view>
    </template>
    
    <view v-else class="empty-state">
      <text class="empty-text">暂无数据</text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'CommonHealthCard',
  props: {
    title: {
      type: String,
      required: true
    },
    icon: {
      type: String,
      required: true
    },
    value: {
      type: [String, Number],
      default: ''
    },
    unit: {
      type: String,
      default: ''
    },
    range: {
      type: String,
      default: ''
    },
    status: {
      type: String,
      default: ''
    },
    statusColor: {
      type: String,
      default: '#A4A4A4'
    },
    stats: {
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
.common-health-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 30rpx;
  margin: 0 30rpx 30rpx;
}

.card-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.title-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
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

.value-row {
  display: flex;
  flex-direction: row;
  align-items: baseline;
  gap: 8rpx;
}

.value-text {
  font-size: 40rpx;
  color: #FBFBFB;
  font-weight: bold;
}

.unit-text {
  font-size: 24rpx;
  color: #A4A4A4;
}

.card-content {
  display: flex;
  flex-direction: column;
}

.chart-area {
  height: 120rpx;
  background-color: #0E1213;
  border-radius: 16rpx;
  border: 1rpx solid #5D5D5D;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20rpx;
}

.chart-placeholder {
  color: #5D5D5D;
  font-size: 24rpx;
}

.status-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20rpx;
}

.range-text {
  font-size: 24rpx;
  color: #A4A4A4;
}

.status-text {
  font-size: 24rpx;
  font-weight: bold;
}

.stats-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-bottom: 20rpx;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 16rpx;
  border: 1rpx solid #3C3C3C;
  width: calc(33.33% - 12rpx);
  box-sizing: border-box;
}

.stat-value {
  font-size: 28rpx;
  color: #FBFBFB;
  font-weight: bold;
  margin-bottom: 4rpx;
}

.stat-name {
  font-size: 22rpx;
  color: #A4A4A4;
}

.analysis-section {
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
  padding: 30rpx;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  border: 1rpx solid #3C3C3C;
}

.empty-text {
  color: #A4A4A4;
  font-size: 24rpx;
}
</style>
