/**
 * 模块：用户鉴权API
 * 说明：封装用户登录、手机验证码登录、微信登录与用户信息获取接口
 * 安全：自动注入 Authorization Bearer 令牌
 * 基地址：来自运行时环境或本地存储配置
 */
import { http } from '../utils/network/request'
import type { ApiResponse } from './types'
/**
 * 获取当前用户信息
 * @returns 统一返回结构，数据为用户信息对象
 */
export function getUserInfo() { return http.get<ApiResponse<Record<string, Record<string, unknown>>>>(`/getUserInfo`, undefined) }
/**
 * 手机号登录
 * @param body 请求体，包含登录令牌等信息
 * @returns 统一返回结构，数据为登录结果对象
 */
export function phoneLogin(body?: any) { return http.post<ApiResponse<Record<string, Record<string, unknown>>>>(`/phoneLogin`, body) }
/**
 * 手机号验证码校验
 * @param body 请求体，包含手机号与验证码令牌
 * @returns 统一返回结构，数据为校验结果对象
 */
export function phoneVerify(body?: any) { return http.post<ApiResponse<Record<string, Record<string, unknown>>>>(`/phoneVerify`, body) }
/**
 * 用户名密码登录
 * @param body 请求体，包含用户名、密码、验证码等信息
 * @returns 统一返回结构，数据为登录结果对象
 */
export function login(body?: any) { return http.post<ApiResponse<Record<string, Record<string, unknown>>>>(`/userLogin`, body) }
/**
 * 微信登录
 * @param body 请求体，包含微信登录码
 * @returns 统一返回结构，数据为登录结果对象
 */
export function wxLogin(body?: any) { return http.post<ApiResponse<Record<string, Record<string, unknown>>>>(`/wxLogin`, body) }
