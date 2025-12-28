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

      <!-- 文章点赞区 -->
      <view class="post-footer" v-if="tweet">
        <view class="metric-btn likes" @click="handleLike(tweet.id)">
          <image class="metric-icon"
                 :src="tweet.userLiked ? '/static/images/community/like@2x.png' : '/static/images/community/nolike@2x.png'"/>
          <text class="metric-value" :class="tweet.userLiked?'likes' :''">{{ tweet.likeCount }}</text>
        </view>
        <view class="metric-btn comments">
          <image class="metric-icon" src="/static/images/community/chat@2x.png"/>
          <text class="metric-value">{{ tweet.commentCount }}</text>
        </view>
        <view class="metric-btn views">
          <image class="metric-icon" src="/static/images/community/look@2x.png"/>
          <text class="metric-value">{{ tweet.viewCount }}</text>
        </view>
        <view class="metric-btn share">
          <image class="metric-icon" src="/static/images/community/share@2x.png"/>
        </view>
      </view>

      <!-- 评论列表 -->
      <view class="comments-section">
        <view class="comment-module" v-for="c in topComments" :key="c.id">
          <view class="comment-header">
            <view class="comment-left">
              <image class="avatar" src="/static/images/community/message@2x.png"/>
              <view class="author-box">
                <text class="comment-author">{{ getDisplayName(c) }}</text>
                <text class="comment-time">{{ c.createTime || '' }}</text>
              </view>
            </view>
            <view class="comment-actions" v-if="!canDeleteComment(c)">
              <view class="action-item">
                <image class="small-icon"
                       :src="isCommentLikedByMe(c) ? '/static/images/community/like@2x.png' : '/static/images/community/nolike@2x.png'"/>
                <text class="action-value likes">0</text>
              </view>
              <view class="action-item">
                <image class="small-icon" src="/static/images/community/chat@2x.png"/>
                <text class="action-value">1</text>
              </view>
            </view>
            <text class="comment-action delete-action" v-else @click="onDeleteComment(c)">Delete</text>
          </view>

          <view class="comment-body">
            <text class="comment-text" :class="{ clamp: !isCommentExpanded(c) }">{{ c.commentContent }}</text>
          </view>
          <view class="show-more" v-if="shouldShowMore(c)" @click="toggleCommentContent(c)">
            <text>{{ isCommentExpanded(c) ? 'Show less' : 'Show more' }}</text>
          </view>

          <view class="replies">
            <view class="reply-row" v-for="r in getVisibleReplies(c)" :key="r.id">
              <view class="reply-item">
                <text class="reply-author">@{{ getDisplayName(r) }}</text>
                <text class="reply-content" :class="{ clamp: !isReplyExpanded(r) }"> {{ r.commentContent }}</text>
              </view>
              <view class="reply-actions">
                <view class="action-item">
                  <image class="small-icon"
                         :src="isCommentLikedByMe(r) ? '/static/images/community/like@2x.png' : '/static/images/community/nolike@2x.png'"/>
                  <text class="action-value likes">0</text>
                </view>
                <view class="action-item">
                  <image class="small-icon" src="/static/images/community/chat@2x.png"/>
                  <text class="action-value">0</text>
                </view>
              </view>
            </view>
            <view class="show-more" v-if="shouldShowMore(r)" @click="toggleReplyContent(r)">
              <text>{{ isReplyExpanded(r) ? 'Show less' : 'Show more' }}</text>
            </view>
            <view class="toggle-replies" v-if="replyMap[c.id || ''].length > 2" @click="toggleReplies(c)">
              <text v-if="!expandedMap[c.id || '']">Show all replies</text>
              <text v-else>Collapse all replies</text>
            </view>
          </view>
        </view>
      </view>
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
import {getTweetDetail, deleteTweet, getTweetDetailWithStats} from '@/api/tweet'
import {listByPid, publishComment, deleteComment as apiDeleteComment} from '@/api/comment'
import type {Tweet, Comment, SysUser} from '@/api/types'
import {recordTweetView} from "@/api/tweetview";
import {likeTweet} from "@/api/tweetlike";

const tweetId = ref<string>('')
const tweet = ref<Tweet | null>(null)
const tweetStats = ref<Record<string, any> | null>(null)
const topComments = ref<Comment[]>([])
const replyMap = ref<Record<string, Comment[]>>({})
const expandedMap = ref<Record<string, boolean>>({})
const contentExpandedMap = ref<Record<string, boolean>>({})
const replyExpandedMap = ref<Record<string, boolean>>({})
const replyText = ref<string>('')

const userInfo = ref<SysUser | null>(null)

onLoad((options: any) => {
  userInfo.value = uni.getStorageSync('userInfo') as SysUser
  tweetId.value = String(options?.tweetId)
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

function isCommentLikedByMe(c: Comment) {
  const p = (c.params || {}) as Record<string, any>
  const candidates = ['liked', 'likedByMe', 'likeStatus']
  for (const k of candidates) {
    const v = p[k]
    if (typeof v === 'boolean') return v
    if (typeof v === 'string') return v === 'true' || v === '1' || v.toLowerCase() === 'yes'
    if (typeof v === 'number') return v > 0
  }
  return false
}

const canDeleteTweet = computed(() => {
  const t = tweet.value
  const u = userInfo.value
  if (!t || !u) return false
  return String(t.userId || '') === String(u.userId || '')
})

function getDisplayName(c: Comment) {
  return c.createBy || (c.userId ? `用户${c.userId}` : '')
}

async function viewTweet() {
  const res = await  recordTweetView({
    tweetId: tweetId.value,
    userId: userInfo.value?.userId
  })
  if (res.code === 200) {
    tweet.value.viewCount += 1
  }
}

async function loadTweet() {
  try {
    const res = await getTweetDetail({id: tweetId.value})
    if (res.code === 200) {
      tweet.value = (res.data || null) as Tweet
      await viewTweet()
    }
    const uid = String(userInfo.value?.userId || '')
    if (tweetId.value) {
      // const statsRes = await getTweetDetailWithStats({id: tweetId.value, userId: uid})
      // if (statsRes.code === 200) {
      //   tweetStats.value = (statsRes.data || null) as Record<string, any>
      // }
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

function shouldShowMore(c: Comment) {
  if (!c || !c.commentContent) return false
  const text = String(c.commentContent || '')
  return text.length > 60
}


function isCommentExpanded(c: Comment) {
  const id = String(c.id || '')
  return !!contentExpandedMap.value[id]
}

function toggleCommentContent(c: Comment) {
  const id = String(c.id || '')
  contentExpandedMap.value[id] = !contentExpandedMap.value[id]
}

function isReplyExpanded(c: Comment) {
  const id = String(c.id || '')
  return !!replyExpandedMap.value[id]
}

function toggleReplyContent(c: Comment) {
  const id = String(c.id || '')
  replyExpandedMap.value[id] = !replyExpandedMap.value[id]
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

async function handleLike(id: string | number) {
  try {
    const res = await likeTweet({
      tweetId: Number(id),
      userId: Number(userInfo?.userId || 0)
    })
    if (res.code === 200) {
      const liked = !!tweet.value.userLiked
      const count = Number(tweet.value.likeCount || 0)
      const nextLiked = !liked
      const nextCount = nextLiked ? count + 1 : Math.max(0, count - 1)
      return { ...tweet.value, userLiked: nextLiked, likeCount: nextCount }
    }
  } catch (e) {
    console.log(e)
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
  overflow: auto;
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
  width: 66rpx;
  height: 66rpx;
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
  color: #FB3A3A;
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
}

.post-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 24rpx 32rpx;
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
  font-size: 32rpx;
  color: #A4A4A4;
}

.metric-value.likes {
  color: #FB3A3A;
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
  gap: 60rpx;
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
  font-size: 28rpx;
  color: #A4A4A4;
}

.action-value.likes {
  color: #FB3A3A;
}

.avatar {
  width: 66rpx;
  height: 66rpx;
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
  line-height: 36rpx;
  white-space: normal;
  word-break: break-word;
  overflow-wrap: anywhere;
}

.comment-text.clamp {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  text-overflow: ellipsis;
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
  line-height: 36rpx;
  white-space: normal;
  word-break: break-word;
  overflow-wrap: anywhere;
}

.reply-content.clamp {
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
  text-overflow: ellipsis;
}

.show-more {
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #255FBE;
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
