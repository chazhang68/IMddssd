<template>
  <view class="hc-card">
    <view class="hc-header">
      <view class="hc-title-row">
        <image class="hc-icon" :src="icon"></image>
        <text class="hc-title">{{ title }}</text>
      </view>
      <view v-if="hasData" class="hc-value">
        <text class="hc-value-text">{{ value }}</text>
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
    <view class="hc-distribution">
      <view class="hc-donut"></view>
      <view class="hc-dist-list">
        <view class="hc-dist-item" v-for="(d, i) in distributionDisplay" :key="i">
          <view class="hc-dist-dot" :style="{ background: d.color }"></view>
          <text class="hc-dist-name">{{ d.name }}</text>
          <text class="hc-dist-percent">{{ d.percent }}</text>
        </view>
      </view>
    </view>
    <view class="hc-pill" :class="{ disabled: !hasData }">
      <text class="hc-pill-text" :style="{ color: statusColorDisplay }">{{ statusText }}</text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'AnxietyCard',
  props: {
    title: { type: String, default: '焦虑' },
    icon: { type: String, default: '/static/icons/anxiety@2x.png' },
    value: { type: [String, Number], default: '' },
    distribution: { type: Array, default: () => [] },
    analysis: { type: String, default: '' },
    status: { type: String, default: '' },
    statusColor: { type: String, default: '#A4A4A4' },
    stats: { type: Array, default: () => [] },
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
    distributionDisplay() {
      const arr = Array.isArray(this.distribution) ? this.distribution : []
      if (this.hasData && arr.length > 0) return arr
      return [
        { name: '正常（0--29）', percent: '0%', color: '#255FBE' },
        { name: '轻度（30--59）', percent: '0%', color: '#34EDDD' },
        { name: '中度（60--79）', percent: '0%', color: '#FF3333' },
        { name: '重度（80--100）', percent: '0%', color: '#F26C0C' }
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

<style>
@import "../static/styles/health-card.css";
</style>