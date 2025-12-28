/**
 * 模块：设备管理
 * 说明：封装设备新增、列表与详情等接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse, TableDataInfo } from './types'
/**
 * 新增设备
 * @param body 请求体，包含设备信息
 * @returns 统一返回结构，数据为键值对象
 */
export function addDevice(body?: any) { return http.post<ApiResponse<Record<string, Record<string, unknown>>>>(`/deviceuser/device`, body) }
/**
 * 设备列表查询
 * @returns 统一返回结构，数据为表格分页信息
 */
export function listDevices() { return http.get<ApiResponse<TableDataInfo>>(`/deviceuser/device/list`, undefined) }
/**
 * 获取设备详情
 * @param params 参数对象
 * @param params.id 设备ID（必填）
 * @returns 统一返回结构，数据为设备详情（键值对象）
 */
export function getDeviceInfo(params: { id: string }) { return http.get<ApiResponse<Record<string, Record<string, unknown>>>>(`/deviceuser/device/${params.id}`, undefined) }
