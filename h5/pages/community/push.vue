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
      <editor id="pushEditor" placeholder="Share your brilliant ideas" class="editor-box" @ready="onEditorReady"/>
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
import {ref} from 'vue'
import LinkDialog from "@/components/dialog/LinkDialog.vue";

const editorCtx = ref(null)
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
  if (!editorCtx.value) return

  // 1. 先插入一个自定义属性的 <a> 节点
  editorCtx.focus?.()
  editorCtx.insertText?.({ text })
  editorCtx.format?.('link', url)
}

function onEditorReady() {
  try {
    uni.createSelectorQuery()
        .select('#pushEditor')
        .context((res: any) => {
          editorCtx.value = res?.context || null
        })
        .exec()
  } catch {
    editorCtx.value = null
  }
}
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
