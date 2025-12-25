/**
 * 模块：推文点赞接口
 * 说明：封装推文点赞/取消点赞操作接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse } from './types'
/**
 * 推文点赞/取消点赞操作
 * @param params 参数对象
 * @param params.tweetId 推文ID（必填）
 * @param params.userId 用户ID（必填）
 * @returns 统一返回结构，数据为空对象或状态信息
 */
export function likeTweet(params: { tweetId: string; userId: string }) { return http.post<ApiResponse<unknown>>(`/communityuser/tweetlike/action`, undefined) }
