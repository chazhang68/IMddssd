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
  name: 'BloodOxygenCard',
  props: {
    title: { type: String, default: '血氧' },
    icon: { type: String, default: '/static/icons/SpO₂@2x.png' },
    value: { type: [String, Number], default: '' },
    unit: { type: String, default: '%' },
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
    },
    statusTextSize() {
      return this.hasData ? '14px' : '12px'
    }
  }
}
</script>

<style>
@import "../static/styles/health-card.css";
</style>