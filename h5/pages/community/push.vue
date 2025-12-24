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

    <view class="editor-area">
      <view id="quillEditor" class="editor-box"></view>
    </view>

    <view class="bottom-toolbar">
      <view class="tool-icons">
        <image class="tool-icon" src="/static/images/community/img@2x.png"/>
        <image class="tool-icon" src="/static/images/community/video@2x.png"/>
        <image class="tool-icon" src="/static/images/community/Pair@2x.png" @click="openLinkModal"/>
      </view>
      <view class="post-btn" @click="onPost">
        <text class="post-text">Post</text>
      </view>
    </view>

    <LinkDialog ref="linkDialogRef" @confirm="confirmLink"></LinkDialog>
  </view>
</template>

<script setup lang="ts">
import {ref, onMounted} from 'vue'
import Quill from 'quill'
import 'quill/dist/quill.snow.css'
import LinkDialog from "@/components/dialog/LinkDialog.vue";

const quillRef = ref<any>(null)
const linkDialogRef = ref(null) // 添加引用

function goBack() {
  uni.navigateBack();
}

function onPost() {
  uni.showToast({
    title: 'Posted',
    icon: 'none'
  });
}

function openLinkModal() {
  linkDialogRef.value.open()
}

function confirmLink(text: string, url: string) {
  const quill = quillRef.value
  if (!quill) return
  const t = (text || '').trim()
  const u = (url || '').trim()
  if (!u) return
  const range = quill.getSelection(true)
  const index = range ? range.index : quill.getLength()
  quill.insertText(index, t || u, { link: u })
}

onMounted(() => {
  const el = document.getElementById('quillEditor')
  if (!el) return
  const quill = new Quill(el, {
    theme: 'snow',
    placeholder: 'Share your brilliant ideas',
    modules: {
      toolbar: false,
      history: { delay: 1000, maxStack: 100, userOnly: false }
    }
  })
  quillRef.value = quill
})
</script>


<style scoped lang="css">
@import "@/static/styles/header.css";

.push-page {
  min-height: 100vh;
  background: #0E1213;
}

.editor-area {
  padding: 24rpx 30rpx 180rpx 30rpx;
}

.editor-box {
  font-weight: 400;
  font-size: 14px;
  color: #FBFBFB;
  text-align: left;
  font-style: normal;
  text-transform: none;
}

/* 使用深度选择器 */
:deep(.ql-editor.ql-blank::before) {
  color: #A4A4A4;
}

:deep(.ql-container) {
  background-color: #0E1213;
  border: none;
}

:deep(.ql-editor) {
  min-height: 600rpx;
  color: #FBFBFB;
  padding: 0;
}

.bottom-toolbar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #1F1F1E;
  border-top-left-radius: 36rpx;
  border-top-right-radius: 36rpx;
  padding: 30rpx 30rpx calc(30rpx + env(safe-area-inset-bottom));
  display: flex;
  flex-direction: row;
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
