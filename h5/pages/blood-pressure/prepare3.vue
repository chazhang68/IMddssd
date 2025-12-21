<template>
  <view class="checkout-page">
    <view class="header">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left" @click="handleBack">
          <text class="nav-back">‹</text>
        </view>
        <text class="nav-title">前期准备</text>
        <view class="nav-right"></view>
      </view>
    </view>

    <view class="image-container">
      <image src="/static/images/blood-pressure/img-C1@2x.png" class="centered-image"/>
      <view class="description">为确保更准确的测量，请使用上臂式臂带血压计校准。</view>
    </view>

    <view class="footer">
      <view class="footer-safe-area"></view>
      <button class="primary-btn" @click="handleNextStep">下一页</button>
      <view class="footer-safe-area"></view>
    </view>
  </view>
</template>

<script setup lang="ts">
const uniApi = (globalThis as unknown as { uni?: any }).uni

const handleBack = (): void => {
  if (uniApi?.navigateBack) {
    uniApi.navigateBack()
    return
  }
  if (typeof history !== 'undefined' && history.length > 1) {
    history.back()
  }
}

const handleNextStep = (): void => {
  if (uniApi?.navigateTo) {
    uniApi.navigateTo({ url: '/pages/blood-pressure/prepare4' })
    return
  }
  if (uniApi?.showToast) {
    uniApi.showToast({ title: '下一页', icon: 'none' })
  }
}
</script>

<style scoped lang="scss">
.checkout-page {
  min-height: 100vh;
  background-color: #0e1213;
}

.header {
  background-color: #ffda3c;
}

.status-bar {
  height: var(--status-bar-height, 44px);
}

.nav-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 30rpx;
}

.nav-left,
.nav-right {
  width: 120rpx;
  display: flex;
  align-items: center;
}

.nav-right {
  justify-content: flex-end;
}

.nav-back {
  font-size: 44rpx;
  line-height: 1;
  color: #0e1213;
}

.nav-title {
  font-size: 34rpx;
  font-weight: 600;
  color: #0e1213;
}

.image-container {
  //display: flex;
  //flex-direction: column;
  //justify-content: center;
  //align-items: center;
  padding: 30rpx;
  //box-sizing: border-box;
}

.centered-image {
  width: 100%;
  height: 500rpx;
}

.description {
  padding-top: 30rpx;
  color: #A4A4A4;
  font-size: 27rpx;
}

.footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  padding: 16rpx 30rpx;
  background: linear-gradient(180deg, rgba(14, 18, 19, 0) 0%, rgba(14, 18, 19, 0.9) 24%, rgba(14, 18, 19, 1) 100%);
}

.footer-safe-area {
  height: env(safe-area-inset-bottom);
}

.primary-btn {
  width: 100%;
  height: 96rpx;
  line-height: 96rpx;
  border-radius: 38rpx;
  background-color: #ffda3c;
  color: #0e1213;
  font-size: 26rpx;
  font-weight: 500;
  border: none;
}
</style>
