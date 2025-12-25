/**
 * 模块：文件上传
 * 说明：封装单文件与多文件上传的通用接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse } from './types'
/**
 * 通用单文件上传
 * @param files 待上传文件数组（至少一个）
 * @param formData 额外表单字段（可选）
 * @returns 统一返回结构，数据为键值对象
 */
export function uploadFile(files: Array<{ name?: string; filePath: string; fileName?: string }>, formData?: Record<string, any>) { return http.upload<ApiResponse<Record<string, Record<string, unknown>>>>(`/common/upload`, files, formData) }
/**
 * 通用多文件上传
 * @param files 待上传文件数组
 * @param formData 额外表单字段（可选）
 * @returns 统一返回结构，数据为键值对象
 */
export function uploadFiles(files: Array<{ name?: string; filePath: string; fileName?: string }>, formData?: Record<string, any>) { return http.upload<ApiResponse<Record<string, Record<string, unknown>>>>(`/common/uploads`, files, formData) }
