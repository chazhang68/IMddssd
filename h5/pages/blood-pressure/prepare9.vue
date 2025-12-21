<template>
  <view class="checkout-page">
    <view class="header">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left" @click="handleBack">
          <text class="nav-back">‹</text>
        </view>
        <text class="nav-title">开始校准</text>
        <view class="nav-right"></view>
      </view>
    </view>

    <scroll-view class="content" scroll-y>
      <view class="section">
        <text class="section-title">血压校准注意</text>
        <text class="section-subtitle">请连接好设备，完成第一、第二次校准</text>

        <view class="notice-list">
          <view v-for="(item, index) in noticeList" :key="index" class="notice-item">
            <text class="notice-index">{{ Number(index) + 1 }}.</text>
            <text class="notice-text">{{ item }}</text>
          </view>
        </view>
      </view>

      <view class="guide-card">
        <view class="guide-grid">
          <view class="guide-item">
            <view class="guide-box">
              <image src="/static/images/img-wearing.png"/>
            </view>
            <text class="guide-caption">佩戴示意</text>
          </view>
          <view class="guide-item">
            <view class="guide-box">
              <image src="/static/images/img-sitting.png"/>
            </view>
            <text class="guide-caption">佩戴姿势</text>
          </view>
        </view>
      </view>

      <view style="padding: 0 30rpx">
        <text class="subsection-title">佩戴示意：</text>
        <view class="sub-list">
          <view v-for="(item, index) in wearGuideList" :key="index" class="sub-item">
            <text class="sub-text">（{{ Number(index) + 1 }}）{{ item }}</text>
          </view>
        </view>

        <text class="subsection-title">佩戴姿势：</text>
        <view class="sub-list">
          <view v-for="(item, index) in postureGuideList" :key="index" class="sub-item">
            <text class="sub-text">（{{ Number(index) + 1 }}）{{ item }}</text>
          </view>
        </view>
      </view>

      <view class="bottom-safe-area"></view>
    </scroll-view>

    <view class="footer">
      <view class="footer-safe-area"></view>
      <button class="primary-btn" @click="handleStart">开始建立</button>
      <view class="footer-safe-area"></view>
    </view>
  </view>
</template>

<script setup lang="ts">
const noticeList: string[] = [
  '校准开始前请准备好传统血压计(气泵式血压计) 做为校准对象',
  '高血压患者请分别在吃药前及服用降压药后一小时分别进行两轮校准',
  '正常校准连续做两次校准即可',
  '校准过程坐姿：请双脚着地，端座在椅子上佩戴设备。同时双手手背向上，连同手臂一同平放在桌子上',
  '建议设备从月部进行一次校准',
  '校准过程中传统血压计测量应和设备佩戴在不同手臂上',
  '校准时输入的三压数据由第三方压计(气泵式血压计) 同时测量得到'
]

const wearGuideList: string[] = [
  '选择合适的手指恰紧佩戴（设备需和皮肤完全贴合）建议佩戴于指优先为大拇指其次为食指',
  '佩戴时请将设备识别标识灯放置在指腹方向',
  '测量时适当弯曲手指贴紧设备，避免环境光影响'
]

const postureGuideList: string[] = [
  '双脚着地，端坐在椅子上',
  '将佩戴设备的那只手手背朝上，连同手臂平放在桌上（则示意图）'
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

const handleStart = (): void => {
  if (uniApi?.showToast) {
    uniApi.showToast({ title: '开始建立', icon: 'none' })
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
  font-size: 36rpx;
  font-weight: 600;
  color: #0e1213;
}

.content {
  height: calc(100vh - 88rpx - var(--status-bar-height, 44px));
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

.section-subtitle {
  display: block;
  margin-top: 12rpx;
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.6);
}

.notice-list {
  margin-top: 18rpx;
}

.notice-item {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  margin-top: 10rpx;
}

.notice-index {
  width: 36rpx;
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.6);
}

.notice-text {
  flex: 1;
  font-size: 24rpx;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.6);
}

.divider {
  margin: 0 30rpx;
  border-top: 1rpx dashed rgba(255, 255, 255, 0.2);
}

.guide-card {
  padding: 0 30rpx;
}

.guide-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20rpx;
}

.guide-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.guide-box {
  width: 100%;
  height: 280rpx;
  border: 2rpx dashed rgba(255, 255, 255, 0.25);
  border-radius: 16rpx;
}

.guide-caption {
  margin-top: 16rpx;
  font-size: 24rpx;
  color: rgba(255, 255, 255, 0.6);
}

.subsection-title {
  display: block;
  margin-top: 18rpx;
  font-size: 28rpx;
  font-weight: 600;
  color: #fbfbfb;
}

.sub-list {
  margin-top: 10rpx;
}

.sub-item {
  margin-top: 10rpx;
}

.sub-text {
  font-size: 24rpx;
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
  border-radius: 48rpx;
  background-color: #ffda3c;
  color: #0e1213;
  font-size: 32rpx;
  font-weight: 600;
  border: none;
}

image{
  width: 100%;
  height: 100%;
}
</style>
