/**
 * 模块：关注关系接口
 * 说明：封装关注、取消关注与我的关注列表相关接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse, Follow } from './types'
/**
 * 查看我的关注列表
 * @param params 参数对象
 * @param params.userId 用户ID（必填）
 * @returns 统一返回结构，数据为 Follow 数组
 */
export function myFollows(params: { userId: string }) { return http.get<ApiResponse<Follow[]>>(`/communityuser/follow/mine`, { userId: params.userId }) }
/**
 * 新增关注关系
 * @param params 参数对象
 * @param params.userId 用户ID（必填）
 * @param params.followUserId 被关注用户ID（必填）
 * @returns 统一返回结构，数据为空对象或状态信息
 */
export function addFollow(params: { userId: string; followUserId: string }) { return http.post<ApiResponse<unknown>>(`/communityuser/follow/relation`, undefined) }
/**
 * 取消关注关系
 * @param params 参数对象
 * @param params.userId 用户ID（必填）
 * @param params.followUserId 被取消关注用户ID（必填）
 * @returns 统一返回结构，数据为空对象或状态信息
 */
export function cancelFollow(params: { userId: string; followUserId: string }) { return http.delete<ApiResponse<unknown>>(`/communityuser/follow/relation`, undefined) }
