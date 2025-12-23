<template>
  <view class="emotion-card">
    <view class="card-header">
      <image class="card-icon" src="/static/icons/emotion.png"></image>
      <text class="card-title">当日情绪</text>
    </view>
    
    <template v-if="hasData">
      <view class="emotion-grid">
        <view v-for="(row, rowIndex) in grid" :key="rowIndex" class="emotion-row">
          <view
            v-for="(cell, cellIndex) in row"
            :key="cellIndex"
            class="emotion-cell"
            :style="{ background: cell }"
          ></view>
        </view>
      </view>
      <view class="emotion-details">
        <view class="emotion-state" v-if="state">
          <text class="state-title">{{ state.title }}</text>
          <text class="state-desc">{{ state.desc }}</text>
        </view>
        <view class="emotion-analysis" v-if="analysis && analysis.length > 0">
          <text class="analysis-title">情绪详情</text>
          <view class="emotion-list">
            <view class="emotion-item" v-for="(item, index) in analysis" :key="index">
              <view class="emotion-color" :style="{ background: item.color }"></view>
              <text class="emotion-name">{{ item.name }}</text>
              <text class="emotion-percent">{{ item.percent }}</text>
            </view>
          </view>
        </view>
        <view class="emotion-therapy" v-if="therapy">
          <text class="therapy-title">{{ therapy.title }}</text>
          <text class="therapy-desc">{{ therapy.desc }}</text>
        </view>
      </view>
    </template>
    
    <view v-else class="empty-state">
      <text class="empty-text">暂无情绪数据</text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'EmotionCard',
  props: {
    grid: {
      type: Array,
      default: () => []
    },
    state: {
      type: Object,
      default: () => null
    },
    analysis: {
      type: Array,
      default: () => []
    },
    therapy: {
      type: Object,
      default: () => null
    },
    hasData: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style scoped>
.emotion-card {
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

.emotion-grid {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  height: 120rpx;
  justify-content: space-between;
  margin-bottom: 30rpx;
  background-color: #0E1213;
  border-radius: 20rpx;
  padding: 8rpx;
  border: 1rpx solid #5D5D5D;
}

.emotion-row {
  display: flex;
  flex-direction: row;
  gap: 8rpx;
  flex: 1;
}

.emotion-cell {
  flex: 1;
  border-radius: 4rpx;
}

.emotion-details {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.emotion-state,
.emotion-analysis,
.emotion-therapy {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

.state-title,
.analysis-title,
.therapy-title {
  font-size: 28rpx;
  color: #FBFBFB;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.state-desc,
.analysis-desc,
.therapy-desc {
  font-size: 24rpx;
  line-height: 1.6;
  color: #A4A4A4;
}

.emotion-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.emotion-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.emotion-color {
  width: 24rpx;
  height: 24rpx;
  border-radius: 50%;
}

.emotion-name,
.emotion-percent {
  font-size: 24rpx;
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
</style>
