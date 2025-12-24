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
      <view class="hc-stat-item1" v-for="(item, index) in statsDisplay" :key="index">
        <view class="hc-stat-value">{{ item.value }}</view>
        <view style="display: flex;justify-content: space-between;align-items: center">
          <view class="hc-stat-name">{{ item.name }}</view>
          <view class="hc-stat-unit">{{ item.unit }}</view>
        </view>
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
  name: 'StepsCard',
  props: {
    title: {type: String, default: '步数'},
    icon: {type: String, default: '/static/icons/step@2x.png'},
    value: {type: [String, Number], default: ''},
    unit: {type: String, default: '步'},
    range: {type: String, default: ''},
    status: {type: String, default: ''},
    statusColor: {type: String, default: '#A4A4A4'},
    stats: {type: Array, default: () => []},
    analysis: {type: String, default: ''},
    hasData: {type: Boolean, default: false}
  },
  computed: {
    statsDisplay() {
      const arr = Array.isArray(this.stats) ? this.stats : []
      if (this.hasData && arr.length > 0) return arr
      return [
        {name: '步数', value: '0', unit: '步'},
        {name: '距离', value: '0.00', unit: '公里'},
        {name: '热量', value: '0', unit: '千卡'}
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

.hc-stat-item1 {
  display: flex;
  flex-direction: column;
  border-radius: 40rpx;
  padding: 16px;
  border: 2rpx solid #3C3C3C;
  width: calc(33.33% - 12rpx);
  box-sizing: border-box;
}

.hc-stat-value {
  display: flex;
  justify-content: end;
  font-weight: bold;
  font-size: 16px;
  color: #FFDA3C;
}

.hc-stat-name {
  font-weight: bold;
  font-size: 14px;
  color: #FBFBFB;
}

.hc-stat-unit {
  font-weight: 400;
  font-size: 12px;
  color: #A4A4A4;
}


</style>