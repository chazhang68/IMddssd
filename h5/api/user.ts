/**
 * 模块：用户个人信息管理
 * 说明：封装头像上传与个人信息更新相关接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse } from './types'
/**
 * 上传用户头像
 * @param files 待上传的图片文件
 * @param formData 额外表单字段（可选）
 * @returns 统一返回结构，成功时返回包含 imgUrl 的对象
 */
export function uploadAvatar(files: Array<{ name?: string; filePath: string; fileName?: string }>, formData?: Record<string, any>) { return http.upload<ApiResponse<Record<string, Record<string, unknown>>>>(`/user/profile/avatar`, files, formData) }
/**
 * 更新个人信息
 * @param body 请求体，包含用户昵称、性别、邮箱等信息
 * @returns 统一返回结构
 */
export function updateProfile(body?: any) { return http.put<ApiResponse<Record<string, Record<string, unknown>>>>(`/user/profile/updateInfo`, body) }


export function getUserInfo() { return http.get<ApiResponse<Record<string, Record<string, unknown>>>>(`/getUserInfo`, undefined) }
