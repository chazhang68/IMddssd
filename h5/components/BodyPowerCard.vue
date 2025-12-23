<template>
  <view class="body-power-card">
    <view class="power-header">
      <view class="power-title-row">
        <image class="power-icon" src="/static/icons/power.png"></image>
        <text class="power-title">身体电量</text>
      </view>
      <view class="power-progress-wrapper"></view>
      <text class="power-value" v-if="hasData && bodyPower !== null">{{ bodyPower }}%</text>
      <text class="power-value" v-else>--</text>
    </view>
    <view class="power-content">
      <text class="power-text" v-if="hasData && healthAdvice">{{ healthAdvice }}</text>
      <text class="power-text empty-text" v-else>暂无数据</text>
    </view>
  </view>
</template>

<script>
export default {
  name: 'BodyPowerCard',
  props: {
    bodyPower: {
      type: [Number, String],
      default: null
    },
    healthAdvice: {
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
.body-power-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.power-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 48rpx;
  padding: 0 8rpx;
}

.power-title-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
}

.power-icon {
  width: 48rpx;
  height: 48rpx;
  background-color: rgba(255, 218, 60, 0.3);
  border-radius: 8rpx;
}

.power-title {
  font-size: 28rpx;
  color: #FFDA3C;
}

.power-progress-wrapper {
  flex: 1;
}

.power-value {
  font-size: 28rpx;
  color: #FFDA3C;
}

.power-content {
  margin-top: 16rpx;
  padding: 32rpx;
  background-color: #2F2E2D;
  border-radius: 40rpx;
  border: 1rpx solid #3C3C3C;
}

.power-text {
  font-size: 26rpx;
  color: #A4A4A4;
  line-height: 1.5;
}

.empty-text {
  text-align: center;
  display: block;
}
</style>
