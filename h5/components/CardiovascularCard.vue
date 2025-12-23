<template>
  <view class="cardiovascular-card hc-card">
    <view class="card-header hc-header">
      <image class="card-icon hc-icon" src="/static/icons/cardiovascular.png"></image>
      <text class="card-title hc-title">心血管</text>
    </view>
    
    <template v-if="hasData">
      <view class="cardiovascular-chart hc-chart">
        <view class="chart-y-axis">
          <text class="axis-label">100</text>
          <text class="axis-label">80</text>
          <text class="axis-label">60</text>
          <text class="axis-label">40</text>
          <text class="axis-label">20</text>
          <text class="axis-label">0</text>
        </view>
        <view class="chart-content">
          <!-- TODO: 添加心血管图表 -->
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
      
      <view class="cardiovascular-details">
        <view class="detail-header">
          <text class="detail-name">项目名称</text>
          <text class="detail-result">结果</text>
          <text class="detail-risk">风险</text>
          <text class="detail-range">正常范围</text>
        </view>
        <view class="detail-item" v-for="(item, index) in details" :key="index">
          <view class="item-name">
            <view class="item-dot" style="background: #856B1D"></view>
            <text>{{ item.name }}</text>
          </view>
          <text class="item-result">{{ item.result }}</text>
          <text class="item-risk" :style="{ color: item.riskColor }">{{ item.risk }}</text>
          <text class="item-range">{{ item.range }}</text>
        </view>
      </view>
      
      <view class="cardiovascular-analysis" v-if="analysis">
        <text class="analysis-title">心血管分析</text>
        <text class="analysis-desc">{{ analysis }}</text>
      </view>
    </template>
    
    <view v-else class="empty-state hc-pill disabled">
      <text class="pill-text hc-pill-text">心血管分析</text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'CardiovascularCard',
  props: {
    details: {
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


<style>
@import "../static/styles/health-card.css";
</style>