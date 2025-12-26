<template>
  <view class="detail-page">
    <view class="header">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left" @click="goBack">
          <image class="back-icon" src="/static/icons/back.png"></image>
        </view>
        <text class="nav-title">Post</text>
        <view class="nav-right"></view>
      </view>
    </view>
    <view class="content">
      <view v-if="tweet" class="post-card">
        <view class="post-header">
          <view class="post-left">
            <image
                class="post-type-icon"
                src="/static/images/community/message@2x.png"
            />
            <view class="author-box">
              <text class="post-author">{{ tweetAuthor }}</text>
              <text class="post-time">{{ tweetTime }}</text>
            </view>
          </view>
          <text
              class="post-action delete-action"
              v-if="canDeleteTweet"
              @click="onDeleteTweet"
          >Delete
          </text>
        </view>
        <view class="post-desc">
          <text class="post-text">{{ tweet.content }}</text>
        </view>
        <view class="post-image"></view>
      </view>

      <view class="post-footer">
        <view class="metric-btn likes">
          <image class="metric-icon" src="/static/images/community/like@2x.png"/>
          <text class="metric-value likes">{{ likesCount }}</text>
        </view>
        <view class="metric-btn comments">
          <image class="metric-icon" src="/static/images/community/chat@2x.png"/>
          <text class="metric-value">{{ topComments.length }}</text>
        </view>
        <view class="metric-btn views">
          <image class="metric-icon" src="/static/images/community/look@2x.png"/>
          <text class="metric-value">{{ viewsCount }}</text>
        </view>
        <view class="metric-btn share">
          <image class="metric-icon" src="/static/images/community/share@2x.png"/>
        </view>
      </view>

      <view class="comments-section">
        <view
            class="comment-module"
            v-for="c in topComments"
            :key="c.id"
        >
          <view class="comment-header">
            <view class="comment-left">
              <image class="avatar" src="/static/images/community/message@2x.png"/>
              <view class="author-box">
                <text class="comment-author">{{ getDisplayName(c) }}</text>
                <text class="comment-time">{{ c.createTime || '' }}</text>
              </view>
            </view>
            <view class="comment-actions">
              <view class="action-item">
                <image class="small-icon" src="/static/images/community/like@2x.png"/>
                <text class="action-value likes">0</text>
              </view>
              <view class="action-item">
                <image class="small-icon" src="/static/images/community/chat@2x.png"/>
                <text class="action-value">1</text>
              </view>
              <text
                  class="comment-action delete-action"
                  v-if="canDeleteComment(c)"
                  @click="onDeleteComment(c)"
              >Delete
              </text>
            </view>
          </view>

          <view class="comment-body">
            <text class="comment-text">{{ c.commentContent }}</text>
          </view>

          <view class="replies" v-if="replyMap[c.id || ''] && replyMap[c.id || ''].length">
            <view
                class="reply-row"
                v-for="r in getVisibleReplies(c)"
                :key="r.id"
            >
              <view class="reply-item">
                <text class="reply-author">@{{ getDisplayName(r) }}</text>
                <text class="reply-content"> {{ r.commentContent }}</text>
              </view>
              <view class="reply-actions">
                <view class="action-item">
                  <image class="small-icon" src="/static/images/community/like@2x.png"/>
                  <text class="action-value likes">0</text>
                </view>
                <view class="action-item">
                  <image class="small-icon" src="/static/images/community/chat@2x.png"/>
                  <text class="action-value">0</text>
                </view>
              </view>
            </view>
            <view
                class="toggle-replies"
                v-if="replyMap[c.id || ''].length > 2"
                @click="toggleReplies(c)"
            >
              <text v-if="!expandedMap[c.id || '']">Show all replies</text>
              <text v-else>Collapse all replies</text>
            </view>
          </view>

          <view class="load-replies" v-else @click="loadReplies(c)">
            <text>Show all replies</text>
          </view>
        </view>
      </view>

      <view class="bottom-safe-area"></view>
    </view>

    <!-- bottom toolbar -->
    <view class="toolbar-box">
      <textarea
          class="reply-input"
          v-model="replyText"
          placeholder="input your reply"
          placeholder-class="reply-placeholder"
          auto-height
      />
      <view class="bottom-toolbar">
        <view class="tool-icons">
          <image class="tool-icon" src="/static/images/community/img@2x.png" @click="chooseImage"/>
          <image class="tool-icon" src="/static/images/community/video@2x.png" @click="chooseVideo"/>
          <image class="tool-icon" src="/static/images/community/Pair@2x.png" @click="openLinkModal"/>
        </view>
        <view class="post-btn" @click="onPublishReply">
          <text class="post-text">Reply</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import {ref, computed} from 'vue'
import {onLoad} from "@dcloudio/uni-app";
import {getTweetDetail, deleteTweet} from '@/api/tweet'
import {listByPid, publishComment, deleteComment as apiDeleteComment} from '@/api/comment'
import type {Tweet, Comment, SysUser} from '@/api/types'

const tweetId = ref<string>('')
const tweet = ref<Tweet | null>(null)
const topComments = ref<Comment[]>([])
const replyMap = ref<Record<string, Comment[]>>({})
const expandedMap = ref<Record<string, boolean>>({})
const replyText = ref<string>('')

const userInfo = ref<SysUser | null>(null)

onLoad((options: any) => {
  try {
    const cache = typeof uni !== 'undefined' ? (uni.getStorageSync('userInfo') || null) : null
    if (cache) userInfo.value = cache as SysUser
  } catch {
  }
  tweetId.value = String(options?.id || '1')
  if (tweetId.value) {
    loadTweet()
    loadTopComments()
  }
})

const tweetAuthor = computed(() => {
  const t = tweet.value
  if (!t) return ''
  return t.createBy || (t.userId ? `用户${t.userId}` : '')
})

const tweetTime = computed(() => {
  const t = tweet.value
  if (!t) return ''
  return t.publishTime || t.createTime || ''
})

const likesCount = computed(() => {
  return '0'
})
const viewsCount = computed(() => {
  return '0'
})

const canDeleteTweet = computed(() => {
  const t = tweet.value
  const u = userInfo.value
  if (!t || !u) return false
  return String(t.userId || '') === String(u.userId || '')
})

function getDisplayName(c: Comment) {
  return c.createBy || (c.userId ? `用户${c.userId}` : '')
}

async function loadTweet() {
  try {
    const res = await getTweetDetail({id: tweetId.value})
    if (res.code === 200) {
      tweet.value = (res.data || null) as Tweet
    }
  } catch {
  }
}

async function loadTopComments() {
  try {
    const res = await listByPid({tweetId: tweetId.value, pid: '0'})
    if (res.code === 200) {
      topComments.value = (res.data || []) as Comment[]
      const tasks = topComments.value
          .map(c => String(c.id || ''))
          .filter(pid => !!pid)
          .map(pid => listByPid({tweetId: tweetId.value, pid}))
      if (tasks.length) {
        try {
          const results = await Promise.all(tasks)
          results.forEach((r, idx) => {
            const pid = String(topComments.value[idx]?.id || '')
            if (!pid) return
            replyMap.value[pid] = (r.code === 200 ? ((r.data || []) as Comment[]) : [])
            expandedMap.value[pid] = false
          })
        } catch {
        }
      }
    }
  } catch {
  }
}

async function loadReplies(parent: Comment) {
  const pid = String(parent.id || '')
  if (!pid) return
  try {
    const res = await listByPid({tweetId: tweetId.value, pid})
    if (res.code === 200) {
      replyMap.value[pid] = (res.data || []) as Comment[]
      expandedMap.value[pid] = false
    }
  } catch {
  }
}

function getVisibleReplies(parent: Comment) {
  const pid = String(parent.id || '')
  const list = replyMap.value[pid] || []
  const expanded = !!expandedMap.value[pid]
  if (!expanded && list.length > 2) return list.slice(0, 2)
  return list
}

function toggleReplies(parent: Comment) {
  const pid = String(parent.id || '')
  expandedMap.value[pid] = !expandedMap.value[pid]
}

function canDeleteComment(c: Comment) {
  const u = userInfo.value
  if (!u) return false
  return String(c.userId || '') === String(u.userId || '')
}

async function onDeleteTweet() {
  if (!tweet.value?.id) return
  try {
    const confirm = await new Promise<boolean>((resolve) => {
      uni.showModal({
        title: '确认删除',
        content: '确定删除这条推文？',
        success: (res: any) => resolve(!!res.confirm),
        fail: () => resolve(false)
      })
    })
    if (!confirm) return
    const res = await deleteTweet({id: String(tweet.value.id)})
    if ((res as any)?.code === 200) {
      uni.showToast({title: '删除成功', icon: 'success'})
      goBack()
      return
    }
    uni.showToast({title: '删除失败', icon: 'error'})
  } catch {
    uni.showToast({title: '删除失败', icon: 'error'})
  }
}

async function onDeleteComment(c: Comment) {
  if (!c.id) return
  try {
    const confirm = await new Promise<boolean>((resolve) => {
      uni.showModal({
        title: '确认删除',
        content: '确定删除这条评论？',
        success: (res: any) => resolve(!!res.confirm),
        fail: () => resolve(false)
      })
    })
    if (!confirm) return
    const res = await apiDeleteComment({id: String(c.id)})
    if ((res as any)?.code === 200) {
      topComments.value = topComments.value.filter(item => String(item.id || '') !== String(c.id || ''))
      Object.keys(replyMap.value).forEach(k => {
        replyMap.value[k] = (replyMap.value[k] || []).filter(item => String(item.id || '') !== String(c.id || ''))
      })
      uni.showToast({title: '删除成功', icon: 'success'})
      return
    }
    uni.showToast({title: '删除失败', icon: 'error'})
  } catch {
    uni.showToast({title: '删除失败', icon: 'error'})
  }
}

async function onPublishReply() {
  const content = replyText.value.trim()
  if (!content) {
    uni.showToast({title: '请输入内容', icon: 'none'})
    return
  }
  try {
    const body: Comment = {
      tweetId: tweetId.value,
      pid: '0',
      commentContent: content,
      userId: String(userInfo.value?.userId || '')
    }
    const res = await publishComment(body)
    if (res.code === 200 && res.data) {
      topComments.value.unshift(res.data as Comment)
      replyText.value = ''
      uni.showToast({title: '已发布', icon: 'success'})
    } else {
      uni.showToast({title: res.msg || '发布失败', icon: 'error'})
    }
  } catch {
    uni.showToast({title: '发布失败', icon: 'error'})
  }
}

function goBack() {
  const uniApi = (globalThis as any).uni
  if (uniApi?.navigateBack) {
    uniApi.navigateBack()
    return
  }
  if (typeof history !== 'undefined' && (history as any).length > 1) {
    history.back()
  }
}
</script>


<style scoped lang="scss">
@import "@/static/styles/header.css";

page {
  background-color: #0E1213;
}

.detail-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
}

.content {
  flex: 1;
  padding-bottom: 30rpx;
}

.post-card {
  padding: 30rpx;
}

.post-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16rpx;
}

.post-left {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.post-type-icon {
  width: 68rpx;
  height: 68rpx;
  border-radius: 50%;
  border: 2rpx solid #323232;
}

.author-box {
  display: flex;
  flex-direction: column;
}

.post-author {
  font-weight: bold;
  font-size: 28rpx;
  color: #FBFBFB;
  line-height: 28rpx;
}

.post-time {
  padding-top: 8rpx;
  font-size: 24rpx;
  color: #A4A4A4;
  line-height: 24rpx;
}

.post-action {
  font-weight: bold;
  font-size: 28rpx;
  color: #FBFBFB;
  line-height: 28rpx;
}

.delete-action {
  color: #FF6B6B;
}

.post-desc {
  margin-bottom: 16rpx;
}

.post-text {
  font-weight: 400;
  font-size: 14px;
  color: #FBFBFB;
}

.post-image {
  height: 280rpx;
  border-radius: 24rpx;
  background-color: #FFDA3C;
  margin: 16rpx 0 30rpx 0;
}

.post-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 20rpx 30rpx;
  border-top: 2rpx solid #2F2E2D;
  border-bottom: 2rpx solid #2F2E2D;
}

.metric-btn {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.metric-icon {
  width: 40rpx;
  height: 40rpx;
}

.metric-value {
  font-size: 26rpx;
  color: #FBFBFB;
}

.metric-value.likes {
  color: #FF6B6B;
}

.comments-section {
  display: flex;
  flex-direction: column;
}

.comment-module {
  padding: 30rpx;
  border-bottom: 2rpx solid #2F2E2D;
}

.comment-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.comment-left {
  display: flex;
  align-items: center;
  gap: 12rpx;
}

.comment-actions {
  display: flex;
  align-items: center;
  gap: 18rpx;
}

.action-item {
  display: flex;
  align-items: center;
  gap: 8rpx;
}

.small-icon {
  width: 40rpx;
  height: 40rpx;
}

.action-value {
  font-size: 26rpx;
  color: #A4A4A4;
}

.action-value.likes {
  color: #FF6B6B;
}

.avatar {
  width: 36rpx;
  height: 36rpx;
  border-radius: 50%;
  background-color: #7351D5;
}

.comment-author {
  font-weight: bold;
  font-size: 28rpx;
  color: #FBFBFB;
}

.comment-time {
  padding-top: 4rpx;
  font-size: 24rpx;
  color: #A4A4A4;
}

.comment-action {
  font-size: 28rpx;
}

.comment-body {
  margin-top: 12rpx;
}

.comment-text {
  font-size: 28rpx;
  color: #FBFBFB;
}

.replies {
  margin-top: 16rpx;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.reply-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.reply-item {
  display: flex;
  flex-direction: row;
  align-items: baseline;
  flex: 1;
}

.reply-actions {
  display: flex;
  align-items: center;
  gap: 16rpx;
}

.reply-author {
  font-size: 28rpx;
  color: #FFDA3C;
}

.reply-content {
  font-size: 28rpx;
  color: #A4A4A4;
}

.toggle-replies, .load-replies {
  display: flex;
  justify-content: center;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #255FBE;
}

.bottom-safe-area {
  height: 120rpx;
}


.reply-input {
  width: 92%;
  padding: 20rpx 24rpx;
  max-height: 184rpx;
  border-radius: 40rpx;
  color: #FFDA3C;
  margin-bottom: 20rpx;
  font-size: 28rpx;
  border: 2rpx solid #FFDA3C;
  overflow-y: auto;
}

.reply-placeholder {
  color: #FFDA3C;
}

.toolbar-box {
  background-color: #1F1F1E;
  border-top-left-radius: 36rpx;
  border-top-right-radius: 36rpx;
  padding: 30rpx 30rpx calc(30rpx + env(safe-area-inset-bottom));
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.bottom-toolbar {
  background-color: #1F1F1E;
  border-top-left-radius: 36rpx;
  border-top-right-radius: 36rpx;
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
  padding: 20rpx 120rpx;

  .post-text {
    font-size: 28rpx;
    font-weight: 600;
    color: #0E1213;
  }
}


</style>
