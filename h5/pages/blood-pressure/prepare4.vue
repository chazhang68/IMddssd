<template>
  <view class="prepare-page">
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

    <scroll-view class="content" scroll-y>
      <view class="section">
        <text class="section-title">设备校准程序概览：</text>

        <view class="overview-list">
          <view v-for="(item, index) in noticeList" :key="index" class="overview-item">
            <view class="overview-icon">
              <image class="overview-icon-image" :src="item.image" mode="aspectFit" />
            </view>
            <text class="overview-text">{{ item.desc }}</text>
          </view>
        </view>
      </view>
      <view class="bottom-safe-area"></view>
    </scroll-view>

    <view class="footer">
      <view class="footer-safe-area"></view>
      <button class="primary-btn" @click="handleNextStep">下一页</button>
      <view class="footer-safe-area"></view>
    </view>
  </view>
</template>

<script setup lang="ts">
interface NoticeItem {
  image: string
  desc: string
}

const noticeList: NoticeItem[] = [
  {
    image: '/static/images/blood-pressure/img-B4@2x.png',
    desc: '切勿根据App读数改变药物或剂量。务必先咨询医师。'
  },
  {
    image: '/static/images/blood-pressure/img-B5@2x.png',
    desc: '测量前30分钟内避免摄入咖啡因、酒精、尼古丁，并避免运动。'
  },
  {
    image: '/static/images/blood-pressure/img-B6@2x.png',
    desc: '怀孕期间请勿使用。'
  },
]

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
    uniApi.navigateTo({ url: '/pages/blood-pressure/prepare5' })
    return
  }
  if (uniApi?.showToast) {
    uniApi.showToast({ title: '下一页', icon: 'none' })
  }
}
</script>


<style scoped lang="scss">
.prepare-page {
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
  font-size: 36rpx;
  font-weight: 600;
  color: #0e1213;
}

.section {
  padding: 28rpx 30rpx;
}

.section-title {
  display: block;
  font-size: 32rpx;
  font-weight: 600;
  color: #fbfbfb;
}

.overview-list {
  margin-top: 18rpx;
}

.overview-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  margin-top: 28rpx;
}

.overview-icon {
  width: 120rpx;
  height: 120rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.overview-icon-image {
  width: 120rpx;
  height: 120rpx;
}

.overview-text {
  flex: 1;
  padding-left: 22rpx;
  font-size: 27rpx;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.6);
}

.bottom-safe-area {
  height: 220rpx;
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
