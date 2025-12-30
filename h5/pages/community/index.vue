<template>
  <view class="community-page">
    <view class="header">
      <view class="search-bar">
        <image class="search-icon" src="/static/images/community/search@2x.png"/>
        <input class="search-input" placeholder="Search..." placeholder-class="search-placeholder" v-model="title"
               @input="debouncedFetchPosts"/>
      </view>
      <!-- 点击按钮 -->
      <view class="tabs-row">
        <view class="tabs-left">
          <view class="tab-item" :class="{ active: tweetType === 0 }" @click="switchTab(0)">
            <image class="action-icon" src="/static/images/community/Recommend@2x.png"/>
            <text class="tab-text" :class="{ active: tweetType === 0 }">Discover</text>
          </view>
          <view class="tab-item" :class="{ active: tweetType === 1 }" @click="switchTab(1)">
            <image class="action-icon" src="/static/images/community/follow@2x.png"/>
            <text class="tab-text" :class="{ active: tweetType === 1 }">Following</text>
          </view>
        </view>

        <view class="action-icons">
          <view class="action-btn" @click="toPage('push')">
            <image class="action-icon" src="/static/images/community/add@2x.png"/>
          </view>
          <view class="action-btn badge-wrap">
            <image class="action-icon" src="/static/images/community/message@2x.png"/>
            <view class="badge">
              <text>2</text>
            </view>
          </view>
        </view>
      </view>
    </view>
    <!-- 推文列表 -->
    <view class="content">
      <view class="post-card" v-for="post in posts" :key="post.id"
            @click.prevent="toPage('detail', { tweetId: post.id }); ">
        <view class="post-header">
          <view class="post-left">
            <image class="post-type-icon" :src="domain+post.userAvatar" />
            <view class="author-box">
              <text class="post-author">{{ post.userNickName }}</text>
              <text class="post-time">{{ post.createTime }}</text>
            </view>
          </view>
          <text class="post-action">{{ post.action }}</text>
        </view>
        <view class="post-desc">
          <text class="post-text">{{ post.content }}</text>
        </view>
        <image class="post-image" :src="post.mainImages" v-if="post.mainImages"/>
        <view class="post-footer">
          <view class="metric-btn" @click.stop="handleLike(post.id)">
            <image class="metric-icon"
                   :src="post.userLiked?'/static/images/community/like@2x.png':'/static/images/community/nolike@2x.png'"/>
            <text class="metric-value">{{ post.likeCount }}</text>
          </view>
          <view class="metric-btn" @click.stop="toPage('detail', { tweetId: post.id })">
            <image class="metric-icon" src="/static/images/community/chat@2x.png"/>
            <text class="metric-value">{{ post.commentCount }}</text>
          </view>
          <view class="metric-btn">
            <image class="metric-icon" src="/static/images/community/look@2x.png"/>
            <text class="metric-value">{{ post.viewCount }}</text>
          </view>
          <view class="metric-btn">
            <image class="metric-icon" src="/static/images/community/share@2x.png"/>
          </view>
        </view>
      </view>

      <view class="bottom-safe-area"></view>

    </view>
  </view>
</template>

<script setup lang="ts">
import {ref, computed} from 'vue'
import {onShow, onPullDownRefresh, onReachBottom} from "@dcloudio/uni-app";
import {getLatestTweets} from "@/api/tweet";
import {likeTweet} from "@/api/tweetlike";
import {debounce} from "@/utils/debounce";

const domain = 'http://47.106.189.19/prod-api';
const posts = ref<any[]>([]);
const tweetType = ref<number>(0);
const pageNo = ref<number>(1);
const pageSize = ref<number>(10);
const total = ref<number>(0);
const loading = ref<boolean>(false);
const title = ref<string>('');
const userInfo = uni.getStorageSync('userInfo');

const requestParams = computed(() => ({
  pageNo: pageNo.value,
  pageSize: pageSize.value,
  tweetType: tweetType.value,
  title: title.value
}));

onShow(() => {
  fetchPosts();
})


const switchTab = async (type: number) => {
  if (tweetType.value !== type) {
    tweetType.value = type;
    pageNo.value = 1;
    await fetchPosts(true);
  }
};

const fetchPosts = async (refresh = false) => {
  try {
    loading.value = true;
    const res = await getLatestTweets(requestParams.value);
    const data: any = res.data || {};
    const list: any[] = data.latestTweets || [];
    total.value = Number(data.total || 0);
    pageSize.value = Number(data.size || pageSize.value);
    const currentPage = Number(data.page || pageNo.value);
    if (refresh) {
      posts.value = list;
    } else {
      if (currentPage <= 1) {
        posts.value = list;
      } else {
        posts.value = posts.value.concat(list);
      }
    }
    pageNo.value = currentPage;
  } catch (err) {
    console.log(err);
  } finally {
    loading.value = false;
  }
};

// 创建防抖版本的搜索函数，延迟1秒执行
const debouncedFetchPosts = debounce(fetchPosts, 1000, true)

onPullDownRefresh(async () => {
  pageNo.value = 1;
  await fetchPosts(true);
  uni.stopPullDownRefresh();
});

onReachBottom(async () => {
  const loaded = posts.value.length;
  const hasMore = loaded < total.value;
  if (loading.value || !hasMore) return;
  pageNo.value = pageNo.value + 1;
  await fetchPosts(false);
});

function toPage(page: string, params?: Record<string, any>) {
  const queryParams = params ?
      '?' + Object.keys(params)
          .map(key => `${key}=${encodeURIComponent(params[key])}`)
          .join('&') : '';

  uni.navigateTo({
    url: `/pages/community/${page}${queryParams}`
  });
}

async function handleLike(id: string | number) {
  try {
    const res = await likeTweet({
      tweetId: Number(id),
      userId: Number(userInfo?.userId || 0)
    })
    if (res.code === 200) {
      posts.value = posts.value.map((item: any) => {
        if (!item) return item
        if (String(item.id) === String(id)) {
          const liked = !!item.userLiked
          const count = Number(item.likeCount || 0)
          const nextLiked = !liked
          const nextCount = nextLiked ? count + 1 : Math.max(0, count - 1)
          return {...item, userLiked: nextLiked, likeCount: nextCount}
        }
        return item
      })
    }
  } catch (e) {
    console.log(e)
  }
}
</script>

<style>
page {
  background: #0E1213;
}

.community-page {
  display: flex;
  flex-direction: column;
  background-color: #0E1213;
}

.header {
  padding: 24rpx 30rpx 12rpx 30rpx;
}

.search-bar {
  position: relative;
  height: 72rpx;
  border: 1rpx solid #FFDA3C;
  border-radius: 72rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 0 24rpx 0 72rpx;
  margin-bottom: 28rpx;
}

.search-icon {
  position: absolute;
  left: 24rpx;
  width: 40rpx;
  height: 40rpx;
}

.search-input {
  flex: 1;
  font-size: 26rpx;
  color: #FBFBFB;
}

.search-placeholder {
  color: #FFDA3C;
}

/* 修改父容器，确保不换行，且溢出时隐藏或处理 */
.tabs-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: flex-start; /* 靠左对齐 */
  gap: 14rpx; /* 左侧组与右侧组间距 7px */
  width: 100%; /* 确保占满容器 */
  //overflow: hidden; /* 防止撑破父容器 */
}

/* 左侧 Tabs 组 */
.tabs-left {
  display: flex;
  flex-direction: row;
  gap: 16rpx; /* 内部元素间距 8px */
  flex: 1; /* 【关键】让左侧尝试占满剩余空间，但在空间不足时会触发内部压缩逻辑 */
  min-width: 0; /* 【关键】允许 Flex 子项压缩至内容宽度以下，防止溢出 */
  overflow-x: scroll; /* 如果实在放不下，允许横向滚动 (可选，不需要可去掉) */
  /* 隐藏滚动条 (针对 Chrome/Safari/Webkit) */
  scrollbar-width: none;
  -webkit-overflow-scrolling: touch;
}

/* 修改 Tab Item：大幅减小内边距 */
.tab-item {
  display: flex;
  align-items: center;
  justify-content: center;
  /* 【关键修改】原 44rpx 改为 20rpx-24rpx，节省空间 */
  padding: 26rpx 30rpx;
  border-radius: 40rpx;
  line-height: 28rpx;
  background: #2F2E2D;
  color: #A4A4A4;
  flex-shrink: 0; /* 防止 Tab 自身被压缩变形 */
  white-space: nowrap; /* 确保文字不换行 */
}

/* 右侧图标组：保持不变，但防止被压缩 */
.action-icons {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx; /* 内部元素间距 8px */
  flex-shrink: 0; /* 【关键】禁止右侧图标被压缩，保证它们始终完整显示 */
}

.tab-item.active {
  background-color: #FFDA3C;
}

.tab-text {
  padding-left: 16rpx;
  font-size: 28rpx;
  font-weight: 500;
}

.tab-text.active {
  color: #0E1213;
  font-weight: 500;
}

.action-btn {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background-color: #2F2E2D;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
}

.action-icon {
  width: 40rpx;
  height: 40rpx;
}

.badge {
  position: absolute;
  top: -4rpx;
  right: -10rpx;
  background-color: #FB3A3A;
  color: #FBFBFB;
  font-size: 20rpx;
  min-width: 28rpx;
  height: 28rpx;
  border-radius: 14rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 6rpx;
}

.content {
  flex: 1;
}

.post-card {
  background-color: #1F1F1E;
  border-radius: 61rpx;
  margin: 16rpx 30rpx;
  padding: 36rpx;
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

.avatar {
  width: 28rpx;
  height: 28rpx;
  border-radius: 50%;
  background-color: #7351D5;
}

.author-box {
  display: flex;
  flex-direction: column;
  justify-items: center;
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

.post-desc {
  margin-bottom: 16rpx;
}

.post-text {
  font-weight: 400;
  font-size: 28rpx;
  color: #A4A4A4;
  line-height: 36rpx;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 4;
  overflow: hidden;
  text-overflow: ellipsis;
  text-align: left;
  font-style: normal;
  text-transform: none;
}

.post-image {
  width: 100%;
  height: 280rpx;
  border-radius: 24rpx;
}

.post-image.light {
  background-color: #FBFBFB;
}

.post-footer {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  margin-top: 20rpx;
}

.metric-btn {
  flex: 1;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  margin-right: 16rpx;
}

.metric-btn:last-child {
  margin-right: 0;
}

.metric-icon {
  width: 40rpx;
  height: 40rpx;
}

.metric-value {
  font-size: 16px;
  color: #A4A4A4;
  line-height: 16px;
}

/*.bottom-safe-area {
  height: 120rpx;
}*/
</style>
