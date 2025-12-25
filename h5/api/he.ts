/**
 * 模块：综合测量
 * 说明：封装综合测量数据的新增与查询接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse } from './types'
/**
 * 新增综合测量数据
 * @param body 请求体，包含综合测量数据
 * @returns 统一返回结构，数据为键值对象
 */
export function addMeasurement(body?: any) { return http.post<ApiResponse<Record<string, Record<string, unknown>>>>(`/deviceuser/measurement`, body) }
/**
 * 综合测量数据列表查询
 * @param params 筛选参数对象（可选各项）
 * @returns 统一返回结构，数据为键值对象集合或分页结构
 */
export function listMeasurements(params: { activityLevel?: string; bloodOxygen?: string; createBy?: string; createTime?: string; delFlag?: string; deviceId?: string; heartRate?: string; hour_of_day?: string; hrv?: string; id?: string; measureTime?: string; params?: Record<string, unknown>; perfusionRate?: number; remark?: string; reservedField?: string; rrArray?: string; rrIntervalCount?: string; searchValue?: string; sleepType?: string; stepCount?: string; stressIndex?: string; temperature?: number; updateBy?: string; updateTime?: string; userId?: string }) { return http.get<ApiResponse<Record<string, Record<string, unknown>>>>(`/deviceuser/measurement/list`, { activityLevel: params.activityLevel, bloodOxygen: params.bloodOxygen, createBy: params.createBy, createTime: params.createTime, delFlag: params.delFlag, deviceId: params.deviceId, heartRate: params.heartRate, hour_of_day: params.hour_of_day, hrv: params.hrv, id: params.id, measureTime: params.measureTime, params: params.params, perfusionRate: params.perfusionRate, remark: params.remark, reservedField: params.reservedField, rrArray: params.rrArray, rrIntervalCount: params.rrIntervalCount, searchValue: params.searchValue, sleepType: params.sleepType, stepCount: params.stepCount, stressIndex: params.stressIndex, temperature: params.temperature, updateBy: params.updateBy, updateTime: params.updateTime, userId: params.userId }) }
