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
        <image class="tool-icon" src="/static/images/community/img@2x.png" @click="chooseImage"/>
        <image class="tool-icon" src="/static/images/community/video@2x.png" @click="chooseVideo"/>
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
import {ref, onMounted, nextTick} from 'vue'
import Quill from 'quill'
import 'quill/dist/quill.snow.css'
import LinkDialog from "@/components/dialog/LinkDialog.vue";

const quillRef = ref<any>(null)
const linkDialogRef = ref(null) // 添加引用
const savedRange = ref<any>(null)

function goBack() {
  uni.navigateBack();
}

function onPost() {
  uni.showToast({
    title: 'Posted',
    icon: 'none'
  });
}

function chooseImage() {
  uni.chooseImage({
    count: 9,              // 可选张数
    sizeType: ['original', 'compressed'],
    sourceType: ['album'], // 只打开相册
    success(res: any) {
      console.log('选择的图片：', res.tempFilePaths)
      // res.tempFilePaths: string[]
      // TODO：上传 / 插入 Quill
      const url = res.tempFilePath
      insertResourceToEditor('image',  url)
    },
    fail(err: any) {
      console.error('选择图片失败', err)
    }
  })
}

function chooseVideo() {
  uni.chooseVideo({
    sourceType: ['album'], // 只打开相册
    compressed: true,
    maxDuration: 60,       // 秒
    success(res: any) {
      console.log('选择的视频：', res.tempFilePath)
      // res.tempFilePath: string
      // TODO：上传 / 插入 Quill
      const url = res.tempFilePath
      insertResourceToEditor('video',  url)
    },
    fail(err: any) {
      console.error('选择视频失败', err)
    }
  })
}

function insertResourceToEditor(type: string, url: string) {
  const quill = quillRef.value
  if (!quill) return

  const range = quill.getSelection(true)
  const index = range ? range.index : quill.getLength()

  quill.insertEmbed(index, type, url)
  quill.setSelection(index + 1, 0, 'silent')
}

function openLinkModal() {
  const quill = quillRef.value
  if (quill) {
    try {
      savedRange.value = quill.getSelection()
    } catch {
      savedRange.value = null
    }
  }
  linkDialogRef.value.open()
}

function confirmLink(text: string, url: string) {
  const quill = quillRef.value
  if (!quill) return
  const t = (text || '').trim()
  const u = (url || '').trim()
  if (!u) return
  const end = quill.getLength()
  const insertText = t || u
  const safe = (s: string) =>
      s.replace(/&/g, '&amp;')
          .replace(/</g, '&lt;')
          .replace(/>/g, '&gt;')
          .replace(/"/g, '&quot;')
          .replace(/'/g, '&#39;')
  const html = `<a href="${safe(u)}" rel="noopener noreferrer">${safe(insertText)}</a>`
  try {
    if (savedRange.value && typeof savedRange.value.index === 'number') {
      quill.setSelection(savedRange.value.index, 0, 'silent')
      quill.clipboard.dangerouslyPasteHTML(savedRange.value.index, html)
      quill.setSelection(savedRange.value.index + insertText.length, 0, 'silent')
    } else {
      quill.clipboard.dangerouslyPasteHTML(end, html)
      quill.setSelection(end + insertText.length, 0, 'silent')
    }
  } catch {
    try {
      quill.insertText(end, insertText)
      quill.formatText(end, insertText.length, {link: u})
      quill.setSelection(end + insertText.length, 0, 'silent')
    } catch {
    }
  }
}

onMounted(() => {
  const el = document.getElementById('quillEditor')
  if (!el) return

  const quill = new Quill(el, {
    theme: 'snow',
    placeholder: 'Share your brilliant ideas',
    modules: {
      toolbar: false,
      history: {delay: 1000, maxStack: 100, userOnly: false}
    }
  })

  quillRef.value = quill

  nextTick(() => {
    const end = quill.getLength()
    quill.setSelection(end, 0, 'silent')
  })
})

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
  min-height: 100%;
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
