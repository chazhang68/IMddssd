<script>
	export default {
		onLaunch: function() {
			console.log('App Launch')

      uni.setStorageSync('token', 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiIsImxvZ2luX3VzZXJfa2V5IjoiODU0NzA2MWYtNWNmNC00NzBiLTg3MjUtODk2NThlMjg5YTRmIn0.U8naM0vqsq2zS_x3Tg8jTg7_nhBZR5lD-3xdh4kRULSxN__U-ah9ijYqm9MV-BECIhcO7jo-80SoPebC84QEzw');
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>

<style>
	/*每个页面公共css */
</style>
