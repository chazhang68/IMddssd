/**
 * 模块：评论查看接口
 * 说明：封装评论查看行为记录相关 API 方法
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse } from './types'
/**
 * 记录评论查看行为
 * @param params 参数对象
 * @param params.commentId 评论ID（必填）
 * @param params.userId 用户ID（必填）
 * @returns 统一返回结构，数据为空对象或状态信息
 */
export function recordCommentView(params: { commentId: string; userId: string }) { return http.post<ApiResponse<unknown>>(`/communityuser/commentview/record`, undefined) }
