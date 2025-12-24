<template>
  <view v-if="visible" class="modal-mask" @click="onMask">
    <view class="link-modal" @click.stop>
      <view style="padding: 40rpx 30rpx 96rpx 30rpx">
        <text class="modal-title">Insert Link</text>
        <input
            class="modal-input"
            v-model="text"
            placeholder="Please enter link text"
            placeholder-class="modal-placeholder"
        />
        <input
            class="modal-input"
            v-model="url"
            placeholder="Please enter link address"
            placeholder-class="modal-placeholder"
        />
      </view>
      <view class="modal-actions">
        <view class="modal-action btn-cancel" @click="close">
          <text>Cancel</text>
        </view>
        <view class="modal-action btn-confirm" @click="confirm">
          <text>Confirm</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import {ref, defineEmits, defineExpose} from 'vue'

const emit = defineEmits(['confirm'])
const visible = ref(false)
const text = ref('')
const url = ref('')

function open() {
  visible.value = true
}

function close() {
  visible.value = false
}

function onMask() {
  close()
}

function isValid(u: string) {
  try {
    const p = new URL(u)
    return p.protocol === 'http:' || p.protocol === 'https:'
  } catch {
    return false
  }
}

function confirm() {
  const t = text.value.trim()
  const u = url.value.trim()
  if (!u || !isValid(u)) {
    uni.showToast({title: '请输入有效链接', icon: 'none'})
    return
  }
  emit('confirm', t, u)
  text.value = ''
  url.value = ''
  close()
}

defineExpose({open, close})
</script>

<style scoped>
.modal-mask {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 999;
}

.link-modal {
  width: 620rpx;
  background-color: #1F1F1E;
  border-radius: 30rpx;
  box-shadow: 0 12rpx 32rpx rgba(0, 0, 0, 0.35);
}

.modal-title {
  display: block;
  text-align: center;
  font-size: 30rpx;
  color: #FBFBFB;
  margin-bottom: 24rpx;
}

.modal-input {
  height: 76rpx;
  background-color: #232323;
  border: 2rpx solid #3A3A3A;
  border-radius: 16rpx;
  padding: 0 24rpx;
  color: #FBFBFB;
  font-size: 28rpx;
  margin-bottom: 16rpx;
}

.modal-placeholder {
  font-size: 14px;
  color: rgba(235, 235, 245, 0.6);
}

.modal-actions {
  margin-top: 10rpx;
  border-top: 1rpx solid #3A3A3A;
  display: flex;
  flex-direction: row;
}

.modal-action {
  flex: 1;
  height: 96rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-action + .modal-action {
  border-left: 1rpx solid #3A3A3A;
}

.btn-cancel {
  font-size: 16px;
  color: rgba(235, 235, 245, 0.6);
}

.btn-confirm {
  font-size: 16px;
  color: #FFDA3C;
}
</style>
