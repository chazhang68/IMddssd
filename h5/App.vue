<script>
import {getUserInfo, login} from "@/api/wx";

export default {
  onLaunch: async function() {
    console.log('App Launch')
    try {
      const loginRes = await login({
        username: 'admin',
        password: 'admin123'
      })

      await uni.setStorageSync('token', loginRes.token)
      const userInfoRes = await getUserInfo()
      if (userInfoRes.code === 200) {
        await uni.setStorageSync('userInfo', userInfoRes.data)
      }
    } catch (error) {
      console.error('App Launch error:', error)
    }
  },
  onShow: function () {
    console.log('App Show')
  },
  onHide: function () {
    console.log('App Hide')
  }
}
</script>

<style>
/*每个页面公共css */
</style>
