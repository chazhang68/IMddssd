<template>
  <view class="hormone-card hc-card">
    <view class="card-header hc-header">
      <image class="card-icon hc-icon" src="/static/icons/hormone.png"></image>
      <text class="card-title hc-title">荷尔蒙</text>
    </view>
    
    <template v-if="hasData">
      <view class="hormone-chart hc-chart">
        <view class="chart-y-axis">
          <text class="axis-label">100</text>
          <text class="axis-label">80</text>
          <text class="axis-label">60</text>
          <text class="axis-label">40</text>
          <text class="axis-label">20</text>
          <text class="axis-label">0</text>
        </view>
        <view class="chart-content">
          <!-- TODO: 添加荷尔蒙图表 -->
          <view class="hc-chart-grid"></view>
        </view>
      </view>
      <view class="chart-x-axis">
        <text class="axis-label">00:00</text>
        <text class="axis-label">06:00</text>
        <text class="axis-label">12:00</text>
        <text class="axis-label">18:00</text>
        <text class="axis-label">24:00</text>
      </view>
      <view class="hormone-analysis" v-if="analysis">
        <text class="analysis-title">荷尔蒙分析</text>
        <text class="analysis-desc">{{ analysis }}</text>
      </view>
    </template>
    
    <view v-else class="empty-state hc-pill disabled">
      <text class="pill-text hc-pill-text">荷尔蒙分析</text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'HormoneCard',
  props: {
    analysis: {
      type: String,
      default: ''
    },
    // 后续可扩展 chartData
    hasData: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style scoped>
.hormone-card {
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

.hormone-chart {
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

.hormone-analysis {
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
