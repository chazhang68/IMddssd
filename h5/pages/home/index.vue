<template>
  <view class="health-page">
    <!-- 顶部标题栏 -->
    <view class="header">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left">
          <!-- 返回图标 -->
          <image class="back-icon" src="/static/icons/back.png"></image>
        </view>
        <text class="nav-title">智能戒指</text>
        <view class="nav-right">
          <!-- 设置图标 -->
          <image class="setting-icon" src="/static/icons/setting.png"></image>
        </view>
      </view>
    </view>

    <!-- 周日历选择器 -->
    <view class="calendar">
      <view class="calendar-item" v-for="(day, index) in weekDays" :key="index" @click="selectDate(index)">
        <text class="calendar-day" :class="{ active: day.selected }">{{ day.name }}</text>
        <text class="calendar-date" :class="{ active: day.selected }">{{ day.date }}</text>
        <view class="calendar-indicator" :class="{ active: day.selected }"></view>
      </view>
    </view>

    <!-- 快捷入口 -->
    <view class="quick-access">
      <view class="quick-item">
        <text class="quick-text">亲友圈</text>
      </view>
      <view class="quick-item">
        <text class="quick-text">亲密空间</text>
      </view>
      <view class="quick-item">
        <text class="quick-text">微体检</text>
      </view>
    </view>

    <!-- 身体电量卡片 -->
    <!--    <BodyPowerCard
          :bodyPower="bodyPowerData.value"
          :healthAdvice="bodyPowerData.advice"
          :hasData="hasData"
        />

        &lt;!&ndash; 当日情绪卡片 &ndash;&gt;
        <EmotionCard
          :grid="emotionData.grid"
          :state="emotionData.state"
          :analysis="emotionData.analysis"
          :therapy="emotionData.therapy"
          :hasData="hasData"
        />

        &lt;!&ndash; 荷尔蒙卡片 &ndash;&gt;
        <HormoneCard
          :analysis="hormoneData.analysis"
          :hasData="hasData"
        />-->

    <!-- 睡眠卡片 -->
    <SleepCard
        :stats="sleepData.stats"
        :analysis="sleepData.analysis"
        :hasData="hasData"
    />

    <!-- 血压卡片 -->
    <BloodPressureCard
        :stats="bloodPressureData.stats"
        :distribution="bloodPressureData.distribution"
        :analysis="bloodPressureData.analysis"
        :hasData="hasData"
    />

    <!-- 心率卡片 -->
    <HeartRateCard
        :value="otherHealthData.heartRate.value"
        unit="bpm"
        :status="otherHealthData.heartRate.status"
        :statusColor="otherHealthData.heartRate.statusColor"
        :stats="otherHealthData.heartRate.stats"
        :analysis="otherHealthData.heartRate.analysis"
        :hasData="hasData"
    />

    <!-- 血氧卡片 -->
    <BloodOxygenCard
        :value="otherHealthData.bloodOxygen.value"
        unit="%"
        :status="otherHealthData.bloodOxygen.status"
        :statusColor="otherHealthData.bloodOxygen.statusColor"
        :analysis="otherHealthData.bloodOxygen.analysis"
        :hasData="hasData"
    />

    <!-- 步数卡片 -->
    <StepsCard
        :value="otherHealthData.steps.value"
        unit="步"
        :status="otherHealthData.steps.status"
        :statusColor="otherHealthData.steps.statusColor"
        :analysis="otherHealthData.steps.analysis"
        :hasData="hasData"
    />

    <!-- 体温分布卡片 -->
    <TemperatureCard
        :value="otherHealthData.temperature.value"
        unit="°C"
        :status="otherHealthData.temperature.status"
        :statusColor="otherHealthData.temperature.statusColor"
        :analysis="otherHealthData.temperature.analysis"
        :hasData="hasData"
    />

<!--    &lt;!&ndash; 抑郁卡片 &ndash;&gt;-->
<!--    <DepressionCard-->
<!--        :value="otherHealthData.depression.value"-->
<!--        :status="otherHealthData.depression.status"-->
<!--        :statusColor="otherHealthData.depression.statusColor"-->
<!--        :analysis="otherHealthData.depression.analysis"-->
<!--        :hasData="hasData"-->
<!--    />-->

<!--    &lt;!&ndash; 压力卡片 &ndash;&gt;-->
<!--    <StressCard-->
<!--        :value="otherHealthData.stress.value"-->
<!--        :status="otherHealthData.stress.status"-->
<!--        :statusColor="otherHealthData.stress.statusColor"-->
<!--        :analysis="otherHealthData.stress.analysis"-->
<!--        :hasData="hasData"-->
<!--    />-->

<!--    &lt;!&ndash; 焦虑卡片 &ndash;&gt;-->
<!--    <AnxietyCard-->
<!--        :value="otherHealthData.anxiety.value"-->
<!--        :status="otherHealthData.anxiety.status"-->
<!--        :statusColor="otherHealthData.anxiety.statusColor"-->
<!--        :analysis="otherHealthData.anxiety.analysis"-->
<!--        :hasData="hasData"-->
<!--    />-->

    <!-- 底部安全区域 -->
    <view class="bottom-safe-area"></view>

    <!-- 底部TabBar -->
    <view class="tab-bar">
      <view class="tab-item active">
        <!-- 首页图标 -->
        <image class="tab-icon" src="/static/icons/home.png"></image>
        <text class="tab-label active">首页</text>
      </view>
      <view class="tab-item">
        <!-- 健康图标 -->
        <image class="tab-icon" src="/static/icons/health.png"></image>
        <text class="tab-label">健康</text>
      </view>
    </view>
  </view>
</template>

<script>
import BodyPowerCard from '@/components/BodyPowerCard.vue'
import EmotionCard from '@/components/EmotionCard.vue'
import HormoneCard from '@/components/HormoneCard.vue'
import SleepCard from '@/components/SleepCard.vue'
import CardiovascularCard from '@/components/CardiovascularCard.vue'
import BloodPressureCard from '@/components/BloodPressureCard.vue'
import FatigueCard from '@/components/FatigueCard.vue'
import HeartRateCard from '@/components/HeartRateCard.vue'
import BloodOxygenCard from '@/components/BloodOxygenCard.vue'
import StepsCard from '@/components/StepsCard.vue'
import TemperatureCard from '@/components/TemperatureCard.vue'
import StressCard from '@/components/StressCard.vue'
import AnxietyCard from '@/components/AnxietyCard.vue'
import DepressionCard from '@/components/DepressionCard.vue'

export default {
  components: {
    BodyPowerCard,
    EmotionCard,
    HormoneCard,
    SleepCard,
    CardiovascularCard,
    BloodPressureCard,
    FatigueCard,
    HeartRateCard,
    BloodOxygenCard,
    StepsCard,
    TemperatureCard,
    StressCard,
    AnxietyCard,
    DepressionCard
  },
  data() {
    return {
      hasData: false,
      weekDays: [
        {name: '周日', date: '26', selected: false},
        {name: '周一', date: '27', selected: false},
        {name: '周二', date: '28', selected: true},
        {name: '周三', date: '29', selected: false},
        {name: '周四', date: '30', selected: false},
        {name: '周五', date: '31', selected: false},
        {name: '周六', date: '1', selected: false}
      ],
      bodyPowerData: {
        value: 48,
        advice: '次健康\n您现在处于次健康状态\n请自观是否有长期持续头晕现象、身体僵硬等问题，请自查是否长期熬夜，晚上有夜宵习惯，喜欢烧烤、油炸类、腌制类食物，建议通过专业人士进行食疗。'
      },
      emotionData: {
        grid: [
          ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
          ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
          ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
          ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
          ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14']
        ],
        state: {title: '心情状态', desc: '内心感到平静祥和，是一种和谐安宁的状态'},
        analysis: [
          {name: '平静', percent: '50%', color: '#70B03D'},
          {name: '愉悦', percent: '0%', color: '#FFDF0F'},
          {name: '悲伤', percent: '0%', color: '#FF3333'},
          {name: '恐惧', percent: '13%', color: '#F26C0C'},
          {name: '愤怒', percent: '13%', color: '#722A14'},
          {name: '惊奇', percent: '0%', color: '#34EDDD'},
          {name: '厌恶', percent: '25%', color: '#7351D5'}
        ],
        therapy: {
          title: '情绪疗愈',
          desc: '积极平和态：是一种积极情绪下的平和状态，表示在第四象限的情绪点数的占比最多。第四象限情绪点越多且位置越靠右表示越积极，位置越靠下表示越平和，这是一种相对较好的状态，表示您在该段时间内比较安静、平和，安静、平和的状态比较适合学习。'
        }
      },
      hormoneData: {
        analysis: '内心独白：想在你身上做，春天对樱桃树做的事。'
      },
      sleepData: {
        stats: [
          {name: '深睡', value: '1时45分', color: '#4C4489'},
          {name: '浅睡', value: '2时5分', color: '#70B03D'},
          {name: '快速眼动', value: '1时10分', color: '#FFDF0F'},
          {name: '清醒', value: '1时0分', color: '#FFDA3C'}
        ],
        analysis: '深睡时长不足：入睡时间过晚尝试规律作息，为睡眠创造安静、黑暗的环境。坚持一些睡前放松练习，能有效帮助加深睡眠。'
      },
      cardiovascularData: {
        details: [
          {name: '血液粘稠度', result: '27', risk: '正常', riskColor: '#255FBE', range: '0--39'},
          {name: '血管硬化度', result: '33', risk: '正常', riskColor: '#255FBE', range: '0--39'},
          {name: '房颤', result: '22', risk: '正常', riskColor: '#255FBE', range: '0--49'},
          {name: '心律不齐', result: '51', risk: '轻度', riskColor: '#FB3A3A', range: '0--49'},
          {name: '心肌缺血', result: '60', risk: '中度', riskColor: '#FB3A3A', range: '0--29'},
          {name: '心衰', result: '8', risk: '正常', riskColor: '#255FBE', range: '0--29'}
        ],
        analysis: '血液粘稠度正常：血液流动性良好，能为身体各组织器官正常运输氧气和营养物质，能维持身体正常生理功能。'
      },
      bloodPressureData: {
        stats: [
          {name: '最高血压', unit: 'mmHg', value: '110'},
          {name: '最低血压', unit: 'mmHg', value: '71'}
        ],
        distribution: [
          {name: '正常', percent: '100%', color: '#70B03D'},
          {name: '正常高值', percent: '0%', color: '#FFDF0F'},
          {name: '低血压', percent: '0%', color: '#FF3333'},
          {name: '高血压', percent: '0%', color: '#F26C0C'}
        ],
        analysis: '收缩压正常：收缩压正常'
      },
      fatigueData: {
        stats: [
          {name: '平均值', value: '61'},
          {name: '最大值', value: '72'},
          {name: '最小值', value: '50'}
        ],
        distribution: [
          {name: '正常（0--29）', percent: '0%', color: '#70B03D'},
          {name: '轻度（30--59）', percent: '38%', color: '#FFDF0F'},
          {name: '中度（60--79)', percent: '62%', color: '#FF3333'},
          {name: '重度（80--100)', percent: '0%', color: '#F26C0C'}
        ],
        analysis: '疲劳分析'
      },
      otherHealthData: {
        heartRate: {
          value: 78,
          range: '60-100',
          status: '正常',
          statusColor: '#255FBE',
          stats: [
            {name: '平均值', value: '78'},
            {name: '最大值', value: '85'},
            {name: '最小值', value: '65'}
          ],
          analysis: '心率分析'
        },
        bloodOxygen: {
          value: 98,
          range: '95-100',
          status: '正常',
          statusColor: '#255FBE',
          analysis: '血氧分析'
        },
        depression: {
          value: 12,
          range: '0-10',
          status: '轻度',
          statusColor: '#FB3A3A',
          analysis: '抑郁分析'
        },
        stress: {
          value: 45,
          range: '0-40',
          status: '轻度',
          statusColor: '#FB3A3A',
          analysis: '压力分析'
        },
        anxiety: {
          value: 30,
          range: '0-30',
          status: '正常',
          statusColor: '#255FBE',
          analysis: '焦虑分析'
        },
        steps: {
          value: 8000,
          range: '6000-10000',
          status: '达标',
          statusColor: '#255FBE',
          analysis: '步数分析'
        },
        temperature: {
          value: 36.5,
          range: '36-37',
          status: '正常',
          statusColor: '#255FBE',
          analysis: '体温分布分析'
        }
      }
    }
  },
  methods: {
    selectDate(index) {
      this.weekDays.forEach(day => {
        day.selected = false;
      });
      this.weekDays[index].selected = true;
    }
  }
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

/* 顶部导航栏 */
.header {
  background-color: #FFDA3C;
}

.status-bar {
  height: var(--status-bar-height, 44px);
}

.nav-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  height: 88rpx;
  padding: 0 30rpx;
}

.nav-left,
.nav-right {
  width: 120rpx;
  display: flex;
  align-items: center;
}

.nav-right {
  justify-content: flex-end;
}

.nav-title {
  font-size: 36rpx;
  font-weight: 500;
  color: #0E1213;
}

/* 图标 */
.back-icon,
.setting-icon,
.tab-icon {
  width: 48rpx;
  height: 48rpx;
}

.tab-icon {
  margin-bottom: 8rpx;
}

/* 周日历选择器 */
.calendar {
  display: flex;
  flex-direction: row;
  background-color: #FFDA3C;
  border-radius: 0 0 32rpx 32rpx;
  padding: 20rpx 0;
  margin-bottom: 20rpx;
}

.calendar-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  position: relative;
}

.calendar-day {
  font-size: 30rpx;
  color: #856B1D;
  margin-bottom: 8rpx;
}

.calendar-date {
  font-size: 30rpx;
  color: #856B1D;
  margin-bottom: 8rpx;
}

.calendar-indicator {
  width: 50rpx;
  height: 16rpx;
  background-color: transparent;
  border-radius: 8rpx;
}

.calendar-day.active,
.calendar-date.active {
  color: #255FBE;
  font-weight: bold;
}

.calendar-indicator.active {
  background-color: #255FBE;
}

/* 快捷入口 */
.quick-access {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 30rpx;
  gap: 20rpx;
}

.quick-item {
  flex: 1;
  background-color: #FFDA3C;
  border-radius: 42rpx;
  padding: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quick-text {
  font-weight: 500;
  font-size: 28rpx;
  color: #0E1213;
}

/* 底部安全区域 */
.bottom-safe-area {
  height: 120rpx;
}

/* 底部TabBar */
.tab-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  display: flex;
  flex-direction: row;
  background-color: #2F2E2D;
  border-radius: 32rpx 32rpx 0 0;
  padding: 20rpx 0;
  padding-bottom: calc(20rpx + env(safe-area-inset-bottom));
  box-shadow: 0 -8rpx 8rpx rgba(0, 0, 0, 0.08);
}

.tab-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.tab-label {
  font-size: 24rpx;
  color: #A4A4A4;
}

.tab-label.active {
  color: #FFDA3C;
}
</style>
