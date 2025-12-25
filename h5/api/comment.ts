/**
 * 模块：评论接口
 * 说明：封装社区评论相关 API 方法，含列表与发布
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse, Comment } from './types'
/**
 * 根据父级ID查看评论列表
 * @param params 参数对象
 * @param params.tweetId 推文ID（必填）
 * @param params.pid 父级评论ID，顶级为0（可选）
 * @returns 统一返回结构，数据为 Comment 数组
 */
export function listByPid(params: { tweetId: string; pid?: string }) { return http.get<ApiResponse<Comment[]>>(`/communityuser/comment/listByPid`, { tweetId: params.tweetId, pid: params.pid }) }
/**
 * 发布评论
 * @param body 请求体，包含评论内容等信息
 * @returns 统一返回结构，数据为新增的 Comment
 */
export function publishComment(body?: any) { return http.post<ApiResponse<Comment>>(`/communityuser/comment/publish`, body) }
