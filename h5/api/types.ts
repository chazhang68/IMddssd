/**
 * 类型定义模块
 * 说明：统一定义 API 响应结构与各业务实体的 TypeScript 类型
 * 来源：由 OpenAPI 文档自动生成（h5/接口文档.json）
 */
/**
 * 统一返回结构
 * @template T 数据类型
 */
export type ApiResponse<T> = { code: number; msg: string; data?: T }
/**
 * 分页返回结构
 * @template T 列表元素类型
 */
export type PagedResponse<T> = { code: number; msg: string; data?: { total?: number; pageNum?: number; pageSize?: number; list?: T[] } }

/**
 * 实体：评论
 * 说明：社区评论数据实体
 */
export interface Comment {
  commentContent?: string;
  createBy?: string;
  createTime?: string;
  delFlag?: string;
  hour_of_day?: string;
  id?: string;
  params?: Record<string, unknown>;
  pid?: string;
  remark?: string;
  tweetId?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 实体：设备
 * 说明：设备信息实体
 */
export interface Device {
  createBy?: string;
  createTime?: string;
  deviceLinkJson?: string;
  deviceName?: string;
  deviceNo: string;
  deviceType?: string;
  hardwareVersion?: string;
  hour_of_day?: string;
  id?: string;
  params?: Record<string, unknown>;
  remark?: string;
  softwareVersion?: string;
  status?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 实体：关注关系
 * 说明：用户之间关注关系实体
 */
export interface Follow {
  createBy?: string;
  createTime?: string;
  followUserId?: string;
  hour_of_day?: string;
  params?: Record<string, unknown>;
  remark?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 实体：综合测量
 * 说明：综合测量数据实体（心率、血氧、体温等）
 */
export interface HeMeasurement {
  activityLevel?: string;
  bloodOxygen?: string;
  createBy?: string;
  createTime?: string;
  delFlag?: string;
  deviceId?: string;
  heartRate?: string;
  hour_of_day?: string;
  hrv?: string;
  id?: string;
  measureTime?: string;
  params?: Record<string, unknown>;
  perfusionRate?: number;
  remark?: string;
  reservedField?: string;
  rrArray?: string;
  rrIntervalCount?: string;
  sleepType?: string;
  stepCount?: string;
  stressIndex?: string;
  temperature?: number;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 实体：心率
 * 说明：心率测量记录实体
 */
export interface Heartrate {
  createBy?: string;
  createTime?: string;
  deviceId?: string;
  heartRateValue?: string;
  hour_of_day?: string;
  id?: string;
  measureTime?: string;
  params?: Record<string, unknown>;
  remark?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 请求体：登录
 * 说明：用户登录请求体
 */
export interface LoginBody {
  code?: string;
  password?: string;
  username?: string;
  uuid?: string;
}

/**
 * 实体：血氧
 * 说明：血氧测量记录实体
 */
export interface Oxygen {
  createBy?: string;
  createTime?: string;
  deviceId?: string;
  hour_of_day?: string;
  id?: string;
  measureTime?: string;
  oxygenValue?: string;
  params?: Record<string, unknown>;
  remark?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 请求体：手机号登录
 * 说明：包含第三方或短信登录令牌
 */
export interface PhoneLoginBody {
  exID?: string;
  loginToken?: string;
}

/**
 * 请求体：手机号验证码校验
 * 说明：包含手机号与验证码/令牌
 */
export interface PhoneVerifyBody {
  exID?: string;
  phone?: string;
  token?: string;
}

/**
 * 实体：血压
 * 说明：血压测量记录实体
 */
export interface Pressure {
  createBy?: string;
  createTime?: string;
  deviceId?: string;
  diastolicPressure?: string;
  hour_of_day?: string;
  id?: string;
  measureTime?: string;
  params?: Record<string, unknown>;
  pulse?: string;
  remark?: string;
  systolicPressure?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 实体：睡眠
 * 说明：睡眠测量记录实体
 */
export interface Sleep {
  createBy?: string;
  createTime?: string;
  deviceId?: string;
  hour_of_day?: string;
  id?: string;
  measureTime?: string;
  params?: Record<string, unknown>;
  remark?: string;
  sleepType?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 实体：步数
 * 说明：步数统计记录实体
 */
export interface Step {
  calories?: string;
  createBy?: string;
  createTime?: string;
  deviceId?: string;
  distance?: string;
  hour_of_day?: string;
  id?: string;
  measureTime?: string;
  params?: Record<string, unknown>;
  remark?: string;
  stepCount?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

/**
 * 实体：部门
 * 说明：系统部门组织实体
 */
export interface SysDept {
  ancestors?: string;
  children?: SysDept[];
  createBy?: string;
  createTime?: string;
  delFlag?: string;
  deptId?: string;
  deptName: string;
  email?: string;
  hour_of_day?: string;
  leader?: string;
  orderNum: number;
  params?: Record<string, unknown>;
  parentId?: string;
  parentName?: string;
  phone?: string;
  remark?: string;
  status?: string;
  updateBy?: string;
  updateTime?: string;
}

/**
 * 实体：角色
 * 说明：系统角色实体
 */
export interface SysRole {
  createBy?: string;
  createTime?: string;
  dataScope?: string;
  delFlag?: string;
  deptCheckStrictly?: boolean;
  deptIds?: string[];
  flag?: boolean;
  hour_of_day?: string;
  menuCheckStrictly?: boolean;
  menuIds?: string[];
  params?: Record<string, unknown>;
  permissions?: string[];
  remark?: string;
  roleId?: string;
  roleKey: string;
  roleName: string;
  roleSort: number;
  status?: string;
  updateBy?: string;
  updateTime?: string;
}

export interface SysUser {
  avatar?: string;
  birthBirthday?: string;
  createBy?: string;
  createTime?: string;
  delFlag?: string;
  dept?: SysDept;
  deptId?: string;
  email?: string;
  emotionalState?: string;
  hour_of_day?: string;
  loginDate?: string;
  loginIp?: string;
  nickName?: string;
  openId?: string;
  params?: Record<string, unknown>;
  password?: string;
  phonenumber?: string;
  postIds?: string[];
  pwdUpdateDate?: string;
  remark?: string;
  roleId?: string;
  roleIds?: string[];
  roles?: SysRole[];
  sex?: string;
  signature?: string;
  status?: string;
  unionId?: string;
  updateBy?: string;
  updateTime?: string;
  userHeight?: string;
  userId?: string;
  userName: string;
  userWeight?: string;
}

export interface TableDataInfo {
  code?: number;
  msg?: string;
  rows?: Record<string, unknown>[];
  total?: string;
}

export interface Temperature {
  createBy?: string;
  createTime?: string;
  deviceId?: string;
  hour_of_day?: string;
  id?: string;
  measureTime?: string;
  params?: Record<string, unknown>;
  remark?: string;
  temperatureValue?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

export interface Tweet {
  content?: string;
  createBy?: string;
  createTime?: string;
  delFlag?: string;
  hour_of_day?: string;
  id?: string;
  params?: Record<string, unknown>;
  publishStatus?: string;
  publishTime?: string;
  remark?: string;
  title?: string;
  tweetType?: string;
  updateBy?: string;
  updateTime?: string;
  userId?: string;
}

export interface WxLoginBody {
  code?: string;
  encryptedData?: string;
  encryptedIv?: string;
}
