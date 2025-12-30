<template>
  <view class="push-page">
    <view class="header">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left" @click="goBack">
          <image class="back-icon" src="/static/icons/back.png"></image>
        </view>
        <text class="nav-title">add a new post</text>
        <view class="nav-right"></view>
      </view>
    </view>

    <!-- editor -->
    <scroll-view class="editor-area" scroll-y>
      <view
          v-for="(block, index) in blocks"
          :key="block.id"
          class="editor-box"
      >
        <!-- text -->
        <textarea
            v-if="block.type === 'text'"
            v-model="block.value"
            class="text-input"
            :placeholder="placeholder"
            maxlength="5000"
            auto-height
        />

        <!-- image -->
        <image
            v-if="block.type === 'image'"
            :src="block.url"
            class="image-block"
            mode="widthFix"
        />

        <!-- video -->
        <video
            v-if="block.type === 'video'"
            :src="block.url"
            class="video-block"
            controls
        />
      </view>
    </scroll-view>

    <!-- bottom toolbar -->
    <view class="bottom-toolbar">
      <view class="tool-icons">
        <image
            class="tool-icon"
            src="/static/images/community/img@2x.png"
            @click="chooseImage"
        />
        <image
            class="tool-icon"
            src="/static/images/community/video@2x.png"
            @click="chooseVideo"
        />
        <image
            class="tool-icon"
            src="/static/images/community/Pair@2x.png"
            @click="openLinkModal"
        />
      </view>
      <view class="post-btn" @click="onPost">
        <text class="post-text">Post</text>
      </view>
    </view>

    <LinkDialog ref="linkDialogRef" @confirm="confirmLink"></LinkDialog>
  </view>
</template>

<script setup lang="ts">
import LinkDialog from "@/components/dialog/LinkDialog.vue";
import { ref } from 'vue'
import { uploadFiles } from '@/api/common'
import {addSystemTweet, addUserTweet} from '@/api/tweet'

const linkDialogRef = ref(null)
const coverPicture = ref('')
const placeholder = ref('Share your brilliant ideas')
const blocks = ref<[]>([
  { id: genId(), type: 'text', value: '' }
])

function genId() {
  return Date.now() + Math.random().toString(16)
}

function goBack() {
  uni.navigateBack()
}

/* ========== Image ========== */
function chooseImage() {
  uni.chooseImage({
    count: 9,
    sourceType: ['album'],
    success: async (res) => {
      const urls = await upload(res.tempFilePaths)
      coverPicture.value = 'http://47.106.189.19/prod-api/profile/upload/2025/12/25/ScreenShot_2025-12-25_155800_898_20251225155847A004.png'
      insertBlock('image', coverPicture.value)
    }
  })
}

/* ========== Video ========== */
function chooseVideo() {
  uni.chooseVideo({
    sourceType: ['album'],
    success: async (res) => {
      const urls = await upload(res.tempFilePath)
      insertBlock('video', urls[0])
    }
  })
}

/* ========== Insert block ========== */
function insertBlock(type: 'image' | 'video', url: string) {
  blocks.value.push({
    id: genId(),
    type,
    url
  })

  // 插入一个新的文本块，保证继续输入
  blocks.value.push({
    id: genId(),
    type: 'text',
    value: ''
  })
}

/* ========== Post ========== */
function onPost() {
  const content = blocks.value.filter((b) => {
    if (b.type === 'text') return b.value
    return true
  })

  addUserTweet({
    title: 'wo fabu l ',
    tweetType: '1',
    mainImages: coverPicture.value,
    content: JSON.stringify(content),
    userId: uni.getStorageSync('userInfo').userId
  }).then(() => {
    uni.showToast({ title: 'Post successful' })
    setTimeout(() => {
      goBack()
    }, 1500)
  })

  // addSystemTweet({
  //   title: '系统公告',
  //   tweetType: 'system',
  //   content: JSON.stringify(content),
  //   userId: uni.getStorageSync('userInfo').userId
  // }).then(() => {
  //   uni.showToast({ title: 'Post successful' })
  //   goBack()
  // })
}

/* ========== Upload ========== */
async function upload(paths: any) {
  try {
    uni.showLoading({
      title: '上传中...'
    })

    const files = paths.map((path: string) => ({
      name: 'files',
      filePath: path,
      fileName: path.split('/').pop()
    }))

    const uploadRes = await uploadFiles(files)
    if (uploadRes.code === 200) {
      return uploadRes.urls
    }
  } catch (error) {
    uni.showToast({
      title: '上传失败',
      icon: 'error'
    })
  } finally {
    uni.hideLoading()
  }
}

function openLinkModal() {
  linkDialogRef.value.open()
}

function confirmLink(text: string, url: string) {

}

</script>


<style scoped lang="css">
@import "@/static/styles/header.css";

.push-page {
  height: 100vh;
  background: #0E1213;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.editor-area {
  flex: 1;
  padding: 24rpx 30rpx;
  overflow-y: auto;
}

.editor-box {
  font-weight: 400;
  font-size: 14px;
  color: #FBFBFB;
  text-align: left;
  font-style: normal;
  text-transform: none;
  width: 100%;
}

/* 文本块输入：铺满容器宽度，自动增高 */
.text-input {
  width: calc(100% - 30rpx);
  max-width: 100%;
  min-height: 40vh;
  display: block;
  box-sizing: border-box;
  background: transparent;
  border: none;
  outline: none;
  color: #FBFBFB;
  caret-color: #FFDA3C;
  padding: 0;
  margin: 0;
  line-height: 36rpx;
  white-space: pre-wrap;
  word-break: break-word;
  overflow-wrap: anywhere;
  resize: none; /* H5防止拖拽改变大小 */
}

/* 使用深度选择器 */
:deep(.ql-editor.ql-blank::before) {
  color: #A4A4A4;
  content: attr(data-placeholder);
  font-style: italic;
  left: 0 !important;
  right: 0 !important;
  pointer-events: none;
  position: absolute;
}

:deep(.ql-container) {
  background-color: #0E1213;
  border: none;
}

:deep(.ql-editor) {
  min-height: 100%;
  color: #FBFBFB;
  padding: 0;
  caret-color: #FFDA3C;
  overscroll-behavior: contain;
}

.bottom-toolbar {
  background-color: #1F1F1E;
  border-top-left-radius: 36rpx;
  border-top-right-radius: 36rpx;
  padding: 30rpx 30rpx calc(30rpx + env(safe-area-inset-bottom));
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.tool-icons {
  flex: 1;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.tool-icon {
  width: 48rpx;
  height: 48rpx;
}

.tool-icon:first-child {
  padding-left: 22rpx;
}

.tool-icon:last-child {
  padding-right: 40rpx;
}

.post-btn {
  background-color: #FFDA3C;
  border-radius: 60rpx;
  padding: 26rpx 130rpx;
}

.post-text {
  font-size: 28rpx;
  font-weight: 600;
  color: #0E1213;
}

</style>
