<template>
  <view class="health-page">
    <scroll-view class="content" scroll-y>
      <!-- 最近更新时间 -->
      <view class="update-time">
        <text class="update-text">最近更新 {{ updateTime }}</text>
      </view>

      <!-- 环形比例图卡片 -->
<!--      <view class="ring-chart-card">
        <view class="ring-chart-wrapper">
          <qiun-data-charts
            type="ring"
            :opts="ringOpts"
            :chartData="ringChartData"
            :canvas2d="true"
            canvasId="ringChart"
          />
        </view>
        <view class="ring-legend">
          <view class="legend-item">
            <view class="legend-row">
              <view class="legend-dot" style="background: #FFDA3C"></view>
              <text class="legend-label">积极情绪比例</text>
            </view>
            <text class="legend-value">{{ healthData.positiveEmotion }}%</text>
          </view>
          <view class="legend-item">
            <view class="legend-row">
              <view class="legend-dot" style="background: #FB3A3A"></view>
              <text class="legend-label">疲劳</text>
            </view>
            <text class="legend-value">{{ healthData.fatigue }}</text>
          </view>
          <view class="legend-item">
            <view class="legend-row">
              <view class="legend-dot" style="background: #255FBE"></view>
              <text class="legend-label">压力</text>
            </view>
            <text class="legend-value">{{ healthData.stress }}</text>
          </view>
        </view>
      </view>
-->
      <!-- 身体电量卡片 -->
<!--      <view class="body-power-card">
        <view class="power-header">
          <view class="power-title-row">
            &lt;!&ndash; TODO: 电量图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder power-icon"></view>
            <text class="power-title">身体电量</text>
          </view>
          <view class="power-progress-wrapper">
            <view class="power-progress-bg">
              <view class="power-progress-fill" :style="{ width: healthData.bodyPower + '%' }"></view>
            </view>
          </view>
          <text class="power-value">{{ healthData.bodyPower }}%</text>
        </view>
        <view class="power-content">
          <text class="power-text">{{ healthData.healthAdvice }}</text>
        </view>
      </view>-->

      <!-- 健康指标网格 -->
      <view class="health-grid">
        <!-- 荷尔蒙 -->
<!--        <view class="health-card">
          <view class="card-header">
            &lt;!&ndash; TODO: 荷尔蒙图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">荷尔蒙</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value">{{ healthData.hormone }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="line"
              :opts="lineOpts"
              :chartData="hormoneChartData"
              :canvas2d="true"
              canvasId="hormoneChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>-->

        <!-- 心血管 -->
<!--        <view class="health-card">
          <view class="card-header">
            &lt;!&ndash; TODO: 心血管图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">心血管</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="line"
              :opts="lineOpts"
              :chartData="cardiovascularChartData"
              :canvas2d="true"
              canvasId="cardiovascularChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>-->

        <!-- 血压 -->
        <view class="health-card">
          <view class="card-header">
            <!-- TODO: 血压图标 - 手动添加 -->
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">血压</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value">{{ healthData.bloodPressure }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="line"
              :opts="lineOpts"
              :chartData="bloodPressureChartData"
              :canvas2d="true"
              canvasId="bloodPressureChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>

        <!-- 情绪 -->
<!--        <view class="health-card">
          <view class="card-header">
            &lt;!&ndash; TODO: 情绪图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">情绪</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
          </view>
          <view class="card-chart emotion-chart">
            <view class="emotion-grid">
              <view v-for="(row, rowIndex) in emotionGrid" :key="rowIndex" class="emotion-row">
                <view
                  v-for="(cell, cellIndex) in row"
                  :key="cellIndex"
                  class="emotion-cell"
                  :style="{ background: cell }"
                ></view>
              </view>
            </view>
          </view>
        </view>-->

        <!-- 睡眠 -->
        <view class="health-card">
          <view class="card-header">
            <!-- TODO: 睡眠图标 - 手动添加 -->
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">睡眠</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value small">{{ healthData.sleep }}</text>
          </view>
          <view class="card-chart sleep-chart">
            <view class="sleep-bar-container">
              <view class="sleep-bar" :style="{ height: '92%' }"></view>
              <view class="sleep-bar" :style="{ height: '92%' }"></view>
            </view>
          </view>
          <view class="card-time-axis">
            <text class="time-label">差</text>
            <text class="time-label">很好</text>
          </view>
        </view>

        <!-- 压力 -->
<!--        <view class="health-card">
          <view class="card-header">
            &lt;!&ndash; TODO: 压力图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">压力</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value">{{ healthData.stressValue }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="column"
              :opts="columnOpts"
              :chartData="stressChartData"
              :canvas2d="true"
              canvasId="stressChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>-->

        <!-- 焦虑 -->
<!--        <view class="health-card">
          <view class="card-header">
            &lt;!&ndash; TODO: 焦虑图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">焦虑</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value">{{ healthData.anxiety }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="column"
              :opts="columnOpts"
              :chartData="anxietyChartData"
              :canvas2d="true"
              canvasId="anxietyChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>-->

        <!-- 抑郁 -->
<!--        <view class="health-card">
          <view class="card-header">
            &lt;!&ndash; TODO: 抑郁图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">抑郁</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value">{{ healthData.depression }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="column"
              :opts="columnOpts"
              :chartData="depressionChartData"
              :canvas2d="true"
              canvasId="depressionChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>-->

        <!-- 疲劳 -->
<!--        <view class="health-card">
          <view class="card-header">
            &lt;!&ndash; TODO: 疲劳图标 - 手动添加 &ndash;&gt;
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">疲劳</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value">{{ healthData.fatigueValue }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="column"
              :opts="columnOpts"
              :chartData="fatigueChartData"
              :canvas2d="true"
              canvasId="fatigueChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>-->

        <!-- 心率 -->
        <view class="health-card">
          <view class="card-header">
            <!-- TODO: 心率图标 - 手动添加 -->
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">心率</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value small">{{ healthData.heartRate }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="line"
              :opts="lineOpts"
              :chartData="heartRateChartData"
              :canvas2d="true"
              canvasId="heartRateChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>

        <!-- 步数 -->
        <view class="health-card">
          <view class="card-header">
            <!-- TODO: 步数图标 - 手动添加 -->
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">步数</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value small">{{ healthData.steps }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="column"
              :opts="stepsColumnOpts"
              :chartData="stepsChartData"
              :canvas2d="true"
              canvasId="stepsChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>

        <!-- 体温 -->
        <view class="health-card">
          <view class="card-header">
            <!-- TODO: 体温图标 - 手动添加 -->
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">体温</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value small">{{ healthData.temperature }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="line"
              :opts="lineOpts"
              :chartData="temperatureChartData"
              :canvas2d="true"
              canvasId="temperatureChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>

        <!-- 血氧 -->
        <view class="health-card">
          <view class="card-header">
            <!-- TODO: 血氧图标 - 手动添加 -->
            <view class="icon-placeholder card-icon"></view>
            <view class="card-info">
              <text class="card-label">血氧</text>
              <text class="card-date">{{ healthData.date }}</text>
            </view>
            <text class="card-value small">{{ healthData.bloodOxygen }}</text>
          </view>
          <view class="card-chart">
            <qiun-data-charts
              type="line"
              :opts="lineOpts"
              :chartData="bloodOxygenChartData"
              :canvas2d="true"
              canvasId="bloodOxygenChart"
            />
          </view>
          <view class="card-time-axis">
            <text class="time-label">00:00</text>
            <text class="time-label">24:00</text>
          </view>
        </view>
      </view>

      <!-- 底部安全区域 -->
      <view class="bottom-safe-area"></view>
    </scroll-view>

  </view>
</template>

<script>
export default {
  data() {
    return {
      updateTime: '2025-10-28 10:09:21',
      healthData: {
        date: '10.28',
        positiveEmotion: 28.0,
        fatigue: 61,
        stress: 39,
        bodyPower: 34,
        healthAdvice: '次健康\n您现在处于次健康状态\n请自观是否有长期持续头晕现象、身体僵硬等问题，请自查是否长期熬夜，晚上有夜宵习惯，喜欢烧烤、油炸类、腌制类食物，建议通过专业人士进行食疗。',
        hormone: 42,
        bloodPressure: '110/71',
        sleep: '5h24m',
        stressValue: 39,
        anxiety: 22,
        depression: 39,
        fatigueValue: 69,
        heartRate: '78bpm',
        steps: '2342步',
        temperature: '36.22℃',
        bloodOxygen: '93.1%'
      },
      // 环形图配置
      ringOpts: {
        color: ['#FFDA3C', '#FB3A3A', '#255FBE'],
        padding: [0, 0, 0, 0],
        legend: {
          show: false
        },
        title: {
          name: '',
          fontSize: 12,
          color: '#FFDA3C'
        },
        subtitle: {
          name: '',
          fontSize: 10,
          color: '#A4A4A4'
        },
        extra: {
          ring: {
            ringWidth: 15,
            activeOpacity: 0.5,
            activeRadius: 5,
            offsetAngle: 0,
            labelWidth: 0,
            border: false,
            centerColor: '#1F1F1E'
          }
        }
      },
      ringChartData: {
        series: [
          { name: '积极情绪', data: 28 },
          { name: '疲劳', data: 61 },
          { name: '压力', data: 39 }
        ]
      },
      // 折线图配置
      lineOpts: {
        color: ['#FFDA3C'],
        padding: [5, 5, 5, 5],
        enableScroll: false,
        legend: {
          show: false
        },
        xAxis: {
          disabled: true,
          disableGrid: true
        },
        yAxis: {
          disabled: true,
          disableGrid: true
        },
        dataLabel: false,
        dataPointShape: false,
        extra: {
          line: {
            type: 'curve',
            width: 1,
            activeType: 'none'
          }
        }
      },
      // 柱状图配置
      columnOpts: {
        color: ['#1465DF', '#4EE8EA', '#F21717'],
        padding: [5, 5, 5, 5],
        enableScroll: false,
        legend: {
          show: false
        },
        xAxis: {
          disabled: true,
          disableGrid: true
        },
        yAxis: {
          disabled: true,
          disableGrid: true
        },
        dataLabel: false,
        extra: {
          column: {
            type: 'group',
            width: 4,
            activeBgOpacity: 0
          }
        }
      },
      // 步数柱状图配置
      stepsColumnOpts: {
        color: ['#FFDA3C'],
        padding: [5, 5, 5, 5],
        enableScroll: false,
        legend: {
          show: false
        },
        xAxis: {
          disabled: true,
          disableGrid: true
        },
        yAxis: {
          disabled: true,
          disableGrid: true
        },
        dataLabel: false,
        extra: {
          column: {
            type: 'group',
            width: 4,
            activeBgOpacity: 0
          }
        }
      },
      // 各指标图表数据
      hormoneChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8'],
        series: [{ name: '荷尔蒙', data: [30, 35, 42, 38, 45, 40, 42, 38] }]
      },
      cardiovascularChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8'],
        series: [{ name: '心血管', data: [40, 45, 50, 48, 55, 52, 50, 48] }]
      },
      bloodPressureChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8'],
        series: [{ name: '血压', data: [110, 112, 108, 115, 110, 108, 112, 110] }]
      },
      stressChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
        series: [{ name: '压力', data: [20, 30, 25, 35, 28, 32, 40, 35, 30, 25, 38, 39] }]
      },
      anxietyChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
        series: [{ name: '焦虑', data: [15, 20, 18, 25, 22, 20, 28, 25, 22, 18, 20, 22] }]
      },
      depressionChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
        series: [{ name: '抑郁', data: [25, 30, 28, 35, 32, 30, 38, 35, 32, 28, 36, 39] }]
      },
      fatigueChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
        series: [{ name: '疲劳', data: [50, 55, 58, 62, 65, 60, 68, 70, 65, 62, 66, 69] }]
      },
      heartRateChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8'],
        series: [{ name: '心率', data: [72, 75, 78, 76, 80, 78, 76, 78] }]
      },
      stepsChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20'],
        series: [{ name: '步数', data: [50, 100, 80, 200, 150, 120, 500, 800, 600, 400, 300, 250, 180, 150, 120, 100, 80, 60, 40, 30] }]
      },
      temperatureChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8'],
        series: [{ name: '体温', data: [36.1, 36.2, 36.3, 36.2, 36.4, 36.3, 36.2, 36.2] }]
      },
      bloodOxygenChartData: {
        categories: ['1', '2', '3', '4', '5', '6', '7', '8'],
        series: [{ name: '血氧', data: [93, 94, 93, 95, 94, 93, 94, 93] }]
      },
      // 情绪网格数据
      emotionGrid: [
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14']
      ]
    }
  },
  methods: {}
}
</script>

<style>
page {
  background-color: #0E1213;
}

.health-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #0E1213;
}

/* 图标占位符 */
.icon-placeholder {
  background-color: rgba(255, 255, 255, 0.3);
  border-radius: 8rpx;
}

.back-icon {
  width: 48rpx;
  height: 48rpx;
}

.setting-icon {
  width: 48rpx;
  height: 48rpx;
}

.power-icon {
  width: 48rpx;
  height: 48rpx;
  background-color: rgba(255, 218, 60, 0.3);
}

.card-icon {
  width: 48rpx;
  height: 48rpx;
  background-color: rgba(255, 218, 60, 0.3);
}

.tab-icon {
  width: 48rpx;
  height: 48rpx;
  margin-bottom: 8rpx;
}

/* 内容区域 */
.content {
  flex: 1;
}

/* 更新时间 */
.update-time {
  padding: 30rpx 30rpx 16rpx 30rpx;
}

.update-text {
  font-size: 24rpx;
  color: #A4A4A4;
}

/* 环形图卡片 */
.ring-chart-card {
  display: flex;
  flex-direction: row;
  align-items: center;
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 32rpx;
  gap: 48rpx;
  margin: 0 30rpx 0rpx 30rpx;
}

.ring-chart-wrapper {
  width: 224rpx;
  height: 224rpx;
}

.ring-legend {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.legend-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 16rpx 0;
}

.legend-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 8rpx;
}

.legend-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
}

.legend-label {
  font-size: 24rpx;
  color: #A4A4A4;
}

.legend-value {
  font-size: 24rpx;
  color: #FBFBFB;
}

/* 身体电量卡片 */
.body-power-card {
  background-color: #1F1F1E;
  border-radius: 64rpx;
  padding: 36rpx;
  margin: 16rpx 30rpx 16rpx 30rpx;
}

.power-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 48rpx;
  padding: 0 8rpx;
}

.power-title-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
}

.power-title {
  font-size: 28rpx;
  color: #FFDA3C;
}

.power-progress-wrapper {
  flex: 1;
}

.power-progress-bg {
  height: 12rpx;
  background-color: #856B1D;
  border-radius: 6rpx;
  overflow: hidden;
}

.power-progress-fill {
  height: 100%;
  background-color: #FFDA3C;
  border-radius: 6rpx;
}

.power-value {
  font-size: 28rpx;
  color: #FFDA3C;
}

.power-content {
  margin-top: 16rpx;
  padding: 38rpx;
  background-color: #2F2E2D;
  border-radius: 38rpx;
  border: 1rpx solid #3C3C3C;
}

.power-text {
  font-size: 24rpx;
  line-height: 1.6;
  color: #A4A4A4;
}

/* 健康指标网格 */
.health-grid {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 16rpx;
  margin: 16rpx 30rpx 30rpx 30rpx;
}

.health-card {
  width: calc(50% - 8rpx);
  background-color: #2F2E2D;
  border-radius: 61rpx;
  padding: 30rpx 35rpx;
  box-sizing: border-box;
}

.card-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 8rpx;
}

.card-info {
  flex: 1;
  display: flex;
  flex-direction: column;
}

.card-label {
  font-size: 19rpx;
  color: #FFDA3C;
}

.card-date {
  font-size: 19rpx;
  color: #FFDA3C;
}

.card-value {
  font-size: 31rpx;
  font-weight: bold;
  color: #FFDA3C;
}

.card-value.small {
  font-size: 27rpx;
}

.card-chart {
  height: 191rpx;
  margin-top: 16rpx;
  border-radius: 8rpx;
  border: 1rpx solid #5D5D5D;
  overflow: hidden;
}

.card-time-axis {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-top: 4rpx;
}

.time-label {
  font-size: 19rpx;
  color: #A4A4A4;
}

/* 情绪图表 */
.emotion-chart {
  background-color: #0E1213;
  padding: 8rpx;
  border: none;
}

.emotion-grid {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  height: 100%;
  justify-content: space-between;
}

.emotion-row {
  display: flex;
  flex-direction: row;
  gap: 8rpx;
  flex: 1;
}

.emotion-cell {
  flex: 1;
  border-radius: 4rpx;
}

/* 睡眠图表 */
.sleep-chart {
  background-color: #0E1213;
  display: flex;
  align-items: center;
  height: 191rpx;
  border: none;
}

.sleep-bar-container {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;   /* 底部对齐 */
  justify-content: center; /* 水平居中 */
}

.sleep-bar {
  width: 45rpx;            /* 固定宽度 */
  margin: 4rpx;
  border-radius: 8rpx;
  background: #4C4489;
}

/* 底部安全区域 */
.bottom-safe-area {
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
}

</style>
