<template>
  <view class="common-health-card hc-card">
    <view class="card-header hc-header">
      <view class="title-row hc-title-row">
        <image class="card-icon hc-icon" :src="icon"></image>
        <text class="card-title hc-title">{{ title }}</text>
      </view>
      <template v-if="hasData">
        <view class="value-row hc-value">
          <text class="value-text hc-value-text">{{ value }}</text>
          <text class="unit-text hc-unit-text">{{ unit }}</text>
        </view>
      </template>
    </view>
    
    <view class="card-content">
      <view class="chart-area hc-chart">
        <view class="chart-grid hc-chart-grid"></view>
      </view>
      <view class="status-row" v-if="range">
        <text class="range-text">范围：{{ range }}</text>
      </view>
      <view class="stats-row hc-stats">
        <view class="stat-item hc-stat-item" v-for="(item, index) in statsDisplay" :key="index">
          <text class="stat-value hc-stat-value">{{ item.value }}</text>
          <text class="stat-name hc-stat-name">{{ item.name }}</text>
        </view>
      </view>
      <view class="analysis-pill hc-pill" :class="{ disabled: !hasData }">
        <text class="pill-text hc-pill-text" :style="{ color: statusColorDisplay }">{{ statusText }}</text>
      </view>
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
  },
  computed: {
    statsDisplay() {
      const arr = Array.isArray(this.stats) ? this.stats : []
      if (this.hasData && arr.length > 0) return arr
      return [
        { name: '平均值', value: '0' },
        { name: '最大值', value: '0' },
        { name: '最小值', value: '0' }
      ]
    },
    statusText() {
      if (this.hasData) {
        if (this.status) return `${this.title}${this.status}`
        if (this.analysis) return this.analysis
        return `${this.title}分析`
      }
      return this.analysis || `${this.title}分析`
    },
    statusColorDisplay() {
      return this.hasData ? (this.statusColor || '#FBFBFB') : '#A4A4A4'
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
  height: 200rpx;
  background-color: #0E1213;
  border-radius: 16rpx;
  border: 1rpx solid #5D5D5D;
  margin-bottom: 20rpx;
}

.chart-grid {
  width: 100%;
  height: 100%;
  background-image:
    linear-gradient(to bottom, rgba(255,255,255,0.08) 1rpx, transparent 1rpx),
    linear-gradient(to right, rgba(255,255,255,0.06) 1rpx, transparent 1rpx);
  background-size: 100% 40rpx, 60rpx 100%;
  border-radius: 16rpx;
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

.analysis-pill {
  background-color: #2F2E2D;
  border-radius: 40rpx;
  border: 1rpx solid #3C3C3C;
  padding: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.analysis-pill.disabled {
  opacity: 0.6;
}

.pill-text {
  font-size: 26rpx;
  font-weight: 600;
}

</style>
