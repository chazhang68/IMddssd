/**
 * 模块：推文管理接口
 * 说明：封装推文详情、最新推文与新增推文相关接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse, Tweet } from './types'
/**
 * 推文详情（含统计）
 * @param params 参数对象
 * @param params.id 推文ID（必填）
 * @param params.userId 用户ID（可选，用于统计视角）
 * @returns 统一返回结构，数据为键值对象（含统计信息）
 */
export function getTweetDetailWithStats(params: { id: string; userId?: string }) { return http.get<ApiResponse<Record<string, unknown>>>(`/communityuser/tweet/detail/full/${params.id}`, { userId: params.userId }) }
/**
 * 推文详情
 * @param params 参数对象
 * @param params.id 推文ID（必填）
 * @returns 统一返回结构，数据为 Tweet
 */
export function getTweetDetail(params: { id: string }) { return http.get<ApiResponse<Tweet>>(`/communityuser/tweet/detail/${params.id}`, undefined) }
/**
 * 最新推文列表
 * @param params 参数对象
 * @param params.userId 用户ID（必填）
 * @param params.size 列表大小（可选）
 * @returns 统一返回结构，数据为键值对象（包含列表/分页）
 */
export function getLatestTweets(params: { userId: string; size?: number }) { return http.get<ApiResponse<Record<string, unknown>>>(`/communityuser/tweet/latest`, { userId: params.userId, size: params.size }) }
/**
 * 新增系统推文
 * @param body 请求体，包含推文内容
 * @returns 统一返回结构，数据为新增的 Tweet
 */
export function addSystemTweet(body?: any) { return http.post<ApiResponse<Tweet>>(`/communityuser/tweet/system/add`, body) }
/**
 * 新增用户推文
 * @param body 请求体，包含推文内容
 * @returns 统一返回结构，数据为新增的 Tweet
 */
export function addUserTweet(body?: any) { return http.post<ApiResponse<Tweet>>(`/communityuser/tweet/user/add`, body) }
