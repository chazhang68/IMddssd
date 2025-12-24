<template>
  <view class="hc-card">
    <view class="hc-header">
      <view class="hc-title-row">
        <image class="hc-icon" :src="icon"></image>
        <text class="hc-title">{{ title }}</text>
      </view>
      <view v-if="hasData" class="hc-value">
        <text class="hc-value-text">{{ value }}</text>
        <text class="hc-unit-text">{{ unit }}</text>
      </view>
    </view>
    <view class="hc-chart">
      <view class="hc-chart-grid"></view>
    </view>
    <view class="hc-stats">
      <view class="hc-stat-item" v-for="(item, index) in statsDisplay" :key="index">
        <text class="hc-stat-value">{{ item.value }}</text>
        <text class="hc-stat-name">{{ item.name }}</text>
      </view>
    </view>
    <view class="hc-pill" :class="{ disabled: !hasData }">
      <text class="hc-pill-text" :style="{ color: statusColorDisplay, fontSize:statusTextSize }">
        {{ statusText }}
      </text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'TemperatureCard',
  props: {
    title: { type: String, default: '体温分布' },
    icon: { type: String, default: '/static/icons/temperature@2x.png' },
    value: { type: [String, Number], default: '' },
    unit: { type: String, default: '°C' },
    range: { type: String, default: '' },
    status: { type: String, default: '' },
    statusColor: { type: String, default: '#A4A4A4' },
    stats: { type: Array, default: () => [] },
    analysis: { type: String, default: '' },
    hasData: { type: Boolean, default: false }
  },
  computed: {
    statsDisplay() {
      const arr = Array.isArray(this.stats) ? this.stats : []
      if (this.hasData && arr.length > 0) return arr
      return [
        { name: '最高体温 ℃', value: '0.0' },
        { name: '最低体温 ℃', value: '0.0' }
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
    },
    statusTextSize() {
      return this.hasData ? '14px' : '12px'
    }
  }
}
</script>

<style scoped>
@import "../static/styles/health-card.css";


.hc-stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  border-radius: 40rpx;
  padding: 16rpx;
  border: 2rpx solid #3C3C3C;
  width: calc(50% - 12rpx);
  box-sizing: border-box;
}
</style>