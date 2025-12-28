declare const uni: any
declare const process: any

type HttpMethod = 'GET' | 'POST' | 'PUT' | 'DELETE'

export interface RequestOptions {
    headers?: Record<string, string>
    timeout?: number
    baseURL?: string
}

const DEFAULT_BASE_URL = 'http://47.106.189.19/prod-api/'

let runtimeBaseURL: string | null = null

export function setBaseURL(url: string) {
    if (url) runtimeBaseURL = url
}

export function getBaseURL() {
    const viteEnv =
        typeof import.meta !== 'undefined' &&
        (import.meta as any).env &&
        (import.meta as any).env.VITE_API_BASE
            ? (import.meta as any).env.VITE_API_BASE
            : ''
    const vueEnv = typeof process !== 'undefined' && process.env
        ? process.env.VUE_APP_BASE_API || ''
        : ''
    const storageBase =
        typeof uni !== 'undefined' ? (uni.getStorageSync('baseURL') || '') : ''
    return (runtimeBaseURL || viteEnv || vueEnv || storageBase || DEFAULT_BASE_URL).toString()
}

function buildURL(path: string): string {
    const base = getBaseURL()
    if (/^https?:\/\//i.test(path)) return path
    return base.replace(/\/+$/g, '') + '/' + path.replace(/^\/+/g, '')
}

function serializeQuery(params?: Record<string, any>): string {
    if (!params) return ''
    const esc = encodeURIComponent
    const pairs: string[] = []
    Object.keys(params).forEach((k) => {
        const v = params[k]
        if (v === undefined || v === null) return
        if (Array.isArray(v)) {
            v.forEach((it) => pairs.push(`${esc(k)}=${esc(String(it))}`))
        } else {
            pairs.push(`${esc(k)}=${esc(String(v))}`)
        }
    })
    return pairs.length ? `?${pairs.join('&')}` : ''
}

function getAuthHeader(): Record<string, string> {
    try {
        const token =
            typeof uni !== 'undefined' ? (uni.getStorageSync('token') || '') : ''
        return token ? {Authorization: `Bearer ${token}`} : {}
    } catch {
        return {}
    }
}

async function coreRequest<T>(
    method: HttpMethod,
    url: string,
    params?: Record<string, any>,
    data?: any,
    options?: RequestOptions
): Promise<T> {
    const fullURL =
        buildURL(url) + (method === 'GET' ? serializeQuery(params) : '')
    const headers = {...(options?.headers || {}), ...getAuthHeader()}
    const timeout = options?.timeout ?? 10000

    return new Promise<T>((resolve, reject) => {
        uni.request({
            url: fullURL,
            method,
            data: method === 'GET' ? undefined : data,
            header: headers,
            timeout,
            success: (res: any) => {
                const status = res.statusCode || 0
                const body = res.data as any
                if (status >= 200 && status < 300) {

                    if (body.code === 401) {
                        uni.showToast({
                            title: '请先登录',
                            icon: 'error',
                        })
                    } else if (body.code === 500) {
                        const message = body.msg || '请求失败'
                        uni.showToast({
                            title: message,
                            icon: 'error',
                            duration: 2500,
                        })
                    }
                    resolve(body as T)
                } else {
                    const message = body.msg || '请求失败'
                    // 尝试显示错误提示
                    try {
                        uni.showToast({
                            title: message,
                            icon: 'error',
                        })
                    } catch (showToastError) {
                        console.error('Failed to show toast:', showToastError)
                    }
                    reject({status, data: body})
                }
            },
            fail: (err: any) => reject(err),
        })
    })
}

function coreUpload<T>(
    url: string,
    files: Array<{ name?: string; filePath: string; fileName?: string }>,
    formData?: Record<string, any>,
    params?: Record<string, any>,
    options?: RequestOptions
): Promise<T> {
    const fullURL = buildURL(url) + serializeQuery(params)
    const headers = {...(options?.headers || {}), ...getAuthHeader()}

    return new Promise<T>((resolve, reject) => {
        const opt: any = {
            url: fullURL,
            header: headers,
            formData,
            success: (res: any) => {
                try {
                    const data = res.data ? JSON.parse(res.data) : {}
                    resolve(data as T)
                } catch {
                    resolve((res.data as unknown) as T)
                }
            },
            fail: reject,
        }
        if (files && files.length > 1) {
            opt.files = files.map(f => ({
                name: f.name || 'files',
                filePath: f.filePath,
                fileName: f.fileName
            }))
        } else if (files && files.length === 1) {
            const f = files[0]
            opt.filePath = f.filePath
            opt.name = f.name || 'files'
            if (f.fileName) opt.fileName = f.fileName
        } else {
            reject(new Error('No files to upload'))
            return
        }
        uni.uploadFile(opt)
    })
}

export const http = {
    get: <T>(
        url: string,
        params?: Record<string, any>,
        options?: RequestOptions
    ) => coreRequest<T>('GET', url, params, undefined, options),
    post: <T>(url: string, data?: any, options?: RequestOptions) =>
        coreRequest<T>('POST', url, undefined, data, options),
    put: <T>(url: string, data?: any, options?: RequestOptions) =>
        coreRequest<T>('PUT', url, undefined, data, options),
    delete: <T>(url: string, data?: any, options?: RequestOptions) =>
        coreRequest<T>('DELETE', url, undefined, data, options),
    upload: <T>(
        url: string,
        files: Array<{ name?: string; filePath: string; fileName?: string }>,
        formData?: Record<string, any>,
        params?: Record<string, any>,
        options?: RequestOptions
    ) => coreUpload<T>(url, files, formData, params, options),
}
