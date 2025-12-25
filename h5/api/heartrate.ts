/**
 * 模块：心率记录管理
 * 说明：封装心率记录的新增与按日查询接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse, Heartrate } from './types'
/**
 * 新增心率记录
 * @param body 请求体，包含心率记录数据
 * @returns 统一返回结构
 */
export function addHeartrate(body?: any) { return http.post<ApiResponse<unknown>>(`/deviceuser/heartrate`, body) }
/**
 * 查询心率记录（日）
 * @param params 参数对象
 * @param params.deviceId 设备ID（必填）
 * @param params.date 指定日期（必填，格式如 YYYY-MM-DD）
 * @returns 统一返回结构，数据为 Heartrate 数组
 */
export function getDailyHeartrate(params: { deviceId: string; date: string }) { return http.get<ApiResponse<Heartrate[]>>(`/deviceuser/heartrate/daily`, { deviceId: params.deviceId, date: params.date }) }
