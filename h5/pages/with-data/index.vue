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
    <view class="body-power-card">
      <view class="power-header">
        <view class="power-title-row">
          <!-- 电量图标 -->
          <image class="power-icon" src="/static/icons/power.png"></image>
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
    </view>

    <!-- 当日情绪卡片 -->
    <view class="emotion-card">
      <view class="card-header">
        <!-- 情绪图标 -->
        <image class="card-icon" src="/static/icons/emotion.png"></image>
        <text class="card-title">当日情绪</text>
      </view>
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
      <view class="emotion-details">
        <view class="emotion-state">
          <text class="state-title">心情状态</text>
          <text class="state-desc">内心感到平静祥和，是一种和谐安宁的状态</text>
        </view>
        <view class="emotion-analysis">
          <text class="analysis-title">情绪详情</text>
          <view class="emotion-list">
            <view class="emotion-item">
              <view class="emotion-color" style="background: #70B03D"></view>
              <text class="emotion-name">平静</text>
              <text class="emotion-percent">50%</text>
            </view>
            <view class="emotion-item">
              <view class="emotion-color" style="background: #FFDF0F"></view>
              <text class="emotion-name">愉悦</text>
              <text class="emotion-percent">0%</text>
            </view>
            <view class="emotion-item">
              <view class="emotion-color" style="background: #FF3333"></view>
              <text class="emotion-name">悲伤</text>
              <text class="emotion-percent">0%</text>
            </view>
            <view class="emotion-item">
              <view class="emotion-color" style="background: #F26C0C"></view>
              <text class="emotion-name">恐惧</text>
              <text class="emotion-percent">13%</text>
            </view>
            <view class="emotion-item">
              <view class="emotion-color" style="background: #722A14"></view>
              <text class="emotion-name">愤怒</text>
              <text class="emotion-percent">13%</text>
            </view>
            <view class="emotion-item">
              <view class="emotion-color" style="background: #34EDDD"></view>
              <text class="emotion-name">惊奇</text>
              <text class="emotion-percent">0%</text>
            </view>
            <view class="emotion-item">
              <view class="emotion-color" style="background: #7351D5"></view>
              <text class="emotion-name">厌恶</text>
              <text class="emotion-percent">25%</text>
            </view>
          </view>
        </view>
        <view class="emotion-therapy">
          <text class="therapy-title">情绪疗愈</text>
          <text class="therapy-desc">积极平和态：是一种积极情绪下的平和状态，表示在第四象限的情绪点数的占比最多。第四象限情绪点越多且位置越靠右表示越积极，位置越靠下表示越平和，这是一种相对较好的状态，表示您在该段时间内比较安静、平和，安静、平和的状态比较适合学习。</text>
        </view>
      </view>
    </view>

    <!-- 荷尔蒙卡片 -->
    <view class="hormone-card">
      <view class="card-header">
        <!-- 荷尔蒙图标 -->
        <image class="card-icon" src="/static/icons/hormone.png"></image>
        <text class="card-title">荷尔蒙</text>
      </view>
      <view class="hormone-chart">
        <view class="chart-y-axis">
          <text class="axis-label">100</text>
          <text class="axis-label">80</text>
          <text class="axis-label">60</text>
          <text class="axis-label">40</text>
          <text class="axis-label">20</text>
          <text class="axis-label">0</text>
        </view>
        <view class="chart-content">
          <!-- TODO: 添加荷尔蒙图表 -->
        </view>
      </view>
      <view class="chart-x-axis">
        <text class="axis-label">00:00</text>
        <text class="axis-label">06:00</text>
        <text class="axis-label">12:00</text>
        <text class="axis-label">18:00</text>
        <text class="axis-label">24:00</text>
      </view>
      <view class="hormone-analysis">
        <text class="analysis-title">荷尔蒙分析</text>
        <text class="analysis-desc">内心独白：想在你身上做，春天对樱桃树做的事。</text>
      </view>
    </view>

    <!-- 睡眠卡片 -->
    <view class="sleep-card">
      <view class="card-header">
        <!-- 睡眠图标 -->
        <image class="card-icon" src="/static/icons/sleep.png"></image>
        <text class="card-title">睡眠</text>
      </view>
      <view class="sleep-chart">
        <!-- TODO: 添加睡眠图表 -->
      </view>
      <view class="sleep-stats">
        <view class="stat-item">
          <view class="stat-icon" style="background: #4C4489"></view>
          <view class="stat-info">
            <text class="stat-name">深睡</text>
            <text class="stat-value">1时45分</text>
          </view>
        </view>
        <view class="stat-item">
          <view class="stat-icon" style="background: #70B03D"></view>
          <view class="stat-info">
            <text class="stat-name">浅睡</text>
            <text class="stat-value">2时5分</text>
          </view>
        </view>
        <view class="stat-item">
          <view class="stat-icon" style="background: #FFDF0F"></view>
          <view class="stat-info">
            <text class="stat-name">快速眼动</text>
            <text class="stat-value">1时10分</text>
          </view>
        </view>
        <view class="stat-item">
          <view class="stat-icon" style="background: #FFDA3C"></view>
          <view class="stat-info">
            <text class="stat-name">清醒</text>
            <text class="stat-value">1时0分</text>
          </view>
        </view>
      </view>
      <view class="sleep-analysis">
        <text class="analysis-title">睡眠分析</text>
        <text class="analysis-desc">深睡时长不足：入睡时间过晚尝试规律作息，为睡眠创造安静、黑暗的环境。坚持一些睡前放松练习，能有效帮助加深睡眠。</text>
      </view>
    </view>

    <!-- 心血管卡片 -->
    <view class="cardiovascular-card">
      <view class="card-header">
        <!-- 心血管图标 -->
        <image class="card-icon" src="/static/icons/cardiovascular.png"></image>
        <text class="card-title">心血管</text>
      </view>
      <view class="cardiovascular-chart">
        <view class="chart-y-axis">
          <text class="axis-label">100</text>
          <text class="axis-label">80</text>
          <text class="axis-label">60</text>
          <text class="axis-label">40</text>
          <text class="axis-label">20</text>
          <text class="axis-label">0</text>
        </view>
        <view class="chart-content">
          <!-- TODO: 添加心血管图表 -->
        </view>
      </view>
      <view class="chart-x-axis">
        <text class="axis-label">00:00</text>
        <text class="axis-label">06:00</text>
        <text class="axis-label">12:00</text>
        <text class="axis-label">18:00</text>
        <text class="axis-label">24:00</text>
      </view>
      <view class="cardiovascular-details">
        <view class="detail-header">
          <text class="detail-name">项目名称</text>
          <text class="detail-result">结果</text>
          <text class="detail-risk">风险</text>
          <text class="detail-range">正常范围</text>
        </view>
        <view class="detail-item">
          <view class="item-name">
            <view class="item-dot" style="background: #856B1D"></view>
            <text>血液粘稠度</text>
          </view>
          <text class="item-result">27</text>
          <text class="item-risk" style="color: #255FBE">正常</text>
          <text class="item-range">0--39</text>
        </view>
        <view class="detail-item">
          <view class="item-name">
            <view class="item-dot" style="background: #856B1D"></view>
            <text>血管硬化度</text>
          </view>
          <text class="item-result">33</text>
          <text class="item-risk" style="color: #255FBE">正常</text>
          <text class="item-range">0--39</text>
        </view>
        <view class="detail-item">
          <view class="item-name">
            <view class="item-dot" style="background: #856B1D"></view>
            <text>房颤</text>
          </view>
          <text class="item-result">22</text>
          <text class="item-risk" style="color: #255FBE">正常</text>
          <text class="item-range">0--49</text>
        </view>
        <view class="detail-item">
          <view class="item-name">
            <view class="item-dot" style="background: #856B1D"></view>
            <text>心律不齐</text>
          </view>
          <text class="item-result">51</text>
          <text class="item-risk" style="color: #FB3A3A">轻度</text>
          <text class="item-range">0--49</text>
        </view>
        <view class="detail-item">
          <view class="item-name">
            <view class="item-dot" style="background: #856B1D"></view>
            <text>心肌缺血</text>
          </view>
          <text class="item-result">60</text>
          <text class="item-risk" style="color: #FB3A3A">中度</text>
          <text class="item-range">0--29</text>
        </view>
        <view class="detail-item">
          <view class="item-name">
            <view class="item-dot" style="background: #856B1D"></view>
            <text>心衰</text>
          </view>
          <text class="item-result">8</text>
          <text class="item-risk" style="color: #255FBE">正常</text>
          <text class="item-range">0--29</text>
        </view>
      </view>
      <view class="cardiovascular-analysis">
        <text class="analysis-title">心血管分析</text>
        <text class="analysis-desc">血液粘稠度正常：血液流动性良好，能为身体各组织器官正常运输氧气和营养物质，能维持身体正常生理功能。</text>
      </view>
    </view>

    <!-- 血压卡片 -->
    <view class="blood-pressure-card">
      <view class="card-header">
        <!-- 血压图标 -->
        <image class="card-icon" src="/static/icons/blood-pressure.png"></image>
        <text class="card-title">血压</text>
      </view>
      <view class="blood-pressure-chart">
        <view class="chart-y-axis">
          <text class="axis-label">200</text>
          <text class="axis-label">160</text>
          <text class="axis-label">120</text>
          <text class="axis-label">80</text>
          <text class="axis-label">20</text>
          <text class="axis-label">0</text>
        </view>
        <view class="chart-content">
          <!-- TODO: 添加血压图表 -->
        </view>
      </view>
      <view class="chart-x-axis">
        <text class="axis-label">00:00</text>
        <text class="axis-label">06:00</text>
        <text class="axis-label">12:00</text>
        <text class="axis-label">18:00</text>
        <text class="axis-label">24:00</text>
      </view>
      <view class="blood-pressure-stats">
        <view class="stat-item">
          <text class="stat-name">最高血压</text>
          <text class="stat-unit">mmHg</text>
          <text class="stat-value">110</text>
        </view>
        <view class="stat-item">
          <text class="stat-name">最低血压</text>
          <text class="stat-unit">mmHg</text>
          <text class="stat-value">71</text>
        </view>
      </view>
      <view class="blood-pressure-distribution">
        <view class="distribution-item">
          <view class="item-dot" style="background: #70B03D"></view>
          <text class="item-name">正常</text>
          <text class="item-percent">100%</text>
        </view>
        <view class="distribution-item">
          <view class="item-dot" style="background: #FFDF0F"></view>
          <text class="item-name">正常高值</text>
          <text class="item-percent">0%</text>
        </view>
        <view class="distribution-item">
          <view class="item-dot" style="background: #FF3333"></view>
          <text class="item-name">低血压</text>
          <text class="item-percent">0%</text>
        </view>
        <view class="distribution-item">
          <view class="item-dot" style="background: #F26C0C"></view>
          <text class="item-name">高血压</text>
          <text class="item-percent">0%</text>
        </view>
      </view>
      <view class="blood-pressure-analysis">
        <text class="analysis-title">血压分析</text>
        <text class="analysis-desc">收缩压正常：收缩压正常</text>
      </view>
    </view>

    <!-- 疲劳卡片 -->
    <view class="fatigue-card">
      <view class="card-header">
        <!-- 疲劳图标 -->
        <image class="card-icon" src="/static/icons/fatigue.png"></image>
        <text class="card-title">疲劳</text>
      </view>
      <view class="fatigue-chart">
        <view class="chart-y-axis">
          <text class="axis-label">100</text>
          <text class="axis-label">80</text>
          <text class="axis-label">60</text>
          <text class="axis-label">40</text>
          <text class="axis-label">20</text>
          <text class="axis-label">0</text>
        </view>
        <view class="chart-content">
          <!-- TODO: 添加疲劳图表 -->
        </view>
      </view>
      <view class="chart-x-axis">
        <text class="axis-label">00:00</text>
        <text class="axis-label">06:00</text>
        <text class="axis-label">12:00</text>
        <text class="axis-label">18:00</text>
        <text class="axis-label">24:00</text>
      </view>
      <view class="fatigue-stats">
        <view class="stat-item">
          <text class="stat-value">61</text>
          <text class="stat-name">平均值</text>
        </view>
        <view class="stat-item">
          <text class="stat-value">72</text>
          <text class="stat-name">最大值</text>
        </view>
        <view class="stat-item">
          <text class="stat-value">50</text>
          <text class="stat-name">最小值</text>
        </view>
      </view>
      <view class="fatigue-distribution">
        <view class="distribution-item">
          <view class="item-dot" style="background: #70B03D"></view>
          <text class="item-name">正常（0--29）</text>
          <text class="item-percent">0%</text>
        </view>
        <view class="distribution-item">
          <view class="item-dot" style="background: #FFDF0F"></view>
          <text class="item-name">轻度（30--59）</text>
          <text class="item-percent">38%</text>
        </view>
        <view class="distribution-item">
          <view class="item-dot" style="background: #FF3333"></view>
          <text class="item-name">中度（60--79)</text>
          <text class="item-percent">62%</text>
        </view>
        <view class="distribution-item">
          <view class="item-dot" style="background: #F26C0C"></view>
          <text class="item-name">重度（80--100)</text>
          <text class="item-percent">0%</text>
        </view>
      </view>
      <view class="fatigue-analysis">
        <text class="analysis-title">疲劳分析</text>
        <text class="analysis-desc">疲劳分析</text>
      </view>
    </view>

    <!-- 其他健康指标卡片 -->
    <view class="other-cards">
      <!-- 心率卡片 -->
      <view class="health-card">
        <view class="card-header">
          <!-- 心率图标 -->
          <image class="card-icon" src="/static/icons/heart-rate.png"></image>
          <text class="card-title">心率</text>
        </view>
        <view class="health-chart">
          <view class="chart-y-axis">
            <text class="axis-label">150</text>
            <text class="axis-label">120</text>
            <text class="axis-label">90</text>
            <text class="axis-label">60</text>
            <text class="axis-label">30</text>
            <text class="axis-label">0</text>
          </view>
          <view class="chart-content">
            <!-- TODO: 添加心率图表 -->
          </view>
        </view>
        <view class="chart-x-axis">
          <text class="axis-label">00:00</text>
          <text class="axis-label">06:00</text>
          <text class="axis-label">12:00</text>
          <text class="axis-label">18:00</text>
          <text class="axis-label">24:00</text>
        </view>
        <view class="health-stats">
          <view class="stat-item">
            <text class="stat-value">78</text>
            <text class="stat-name">平均值</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">85</text>
            <text class="stat-name">最大值</text>
          </view>
          <view class="stat-item">
            <text class="stat-value">65</text>
            <text class="stat-name">最小值</text>
          </view>
        </view>
        <view class="health-analysis">
          <text class="analysis-title">心率分析</text>
          <text class="analysis-desc">心率分析</text>
        </view>
      </view>

      <!-- 血氧卡片 -->
      <view class="health-card">
        <view class="card-header">
          <!-- 血氧图标 -->
          <image class="card-icon" src="/static/icons/blood-oxygen.png"></image>
          <text class="card-title">血氧</text>
        </view>
        <view class="health-chart">
          <view class="chart-y-axis">
            <text class="axis-label">100</text>
            <text class="axis-label">90</text>
            <text class="axis-label">80</text>
            <text class="axis-label">70</text>
            <text class="axis-label">60</text>
            <text class="axis-label">0</text>
          </view>
          <view class="chart-content">
            <!-- TODO: 添加血氧图表 -->
          </view>
        </view>
        <view class="chart-x-axis">
          <text class="axis-label">00:00</text>
          <text class="axis-label">06:00</text>
          <text class="axis-label">12:00</text>
          <text class="axis-label">18:00</text>
          <text class="axis-label">24:00</text>
        </view>
        <view class="health-analysis">
          <text class="analysis-title">血氧分析</text>
          <text class="analysis-desc">血氧分析</text>
        </view>
      </view>

      <!-- 抑郁卡片 -->
      <view class="health-card">
        <view class="card-header">
          <!-- 抑郁图标 -->
          <image class="card-icon" src="/static/icons/depression.png"></image>
          <text class="card-title">抑郁</text>
        </view>
        <view class="health-chart">
          <view class="chart-y-axis">
            <text class="axis-label">100</text>
            <text class="axis-label">80</text>
            <text class="axis-label">60</text>
            <text class="axis-label">40</text>
            <text class="axis-label">20</text>
            <text class="axis-label">0</text>
          </view>
          <view class="chart-content">
            <!-- TODO: 添加抑郁图表 -->
          </view>
        </view>
        <view class="chart-x-axis">
          <text class="axis-label">00:00</text>
          <text class="axis-label">06:00</text>
          <text class="axis-label">12:00</text>
          <text class="axis-label">18:00</text>
          <text class="axis-label">24:00</text>
        </view>
        <view class="health-analysis">
          <text class="analysis-title">抑郁分析</text>
          <text class="analysis-desc">抑郁分析</text>
        </view>
      </view>

      <!-- 压力卡片 -->
      <view class="health-card">
        <view class="card-header">
          <!-- 压力图标 -->
          <image class="card-icon" src="/static/icons/stress.png"></image>
          <text class="card-title">压力</text>
        </view>
        <view class="health-chart">
          <view class="chart-y-axis">
            <text class="axis-label">100</text>
            <text class="axis-label">80</text>
            <text class="axis-label">60</text>
            <text class="axis-label">40</text>
            <text class="axis-label">20</text>
            <text class="axis-label">0</text>
          </view>
          <view class="chart-content">
            <!-- TODO: 添加压力图表 -->
          </view>
        </view>
        <view class="chart-x-axis">
          <text class="axis-label">00:00</text>
          <text class="axis-label">06:00</text>
          <text class="axis-label">12:00</text>
          <text class="axis-label">18:00</text>
          <text class="axis-label">24:00</text>
        </view>
        <view class="health-analysis">
          <text class="analysis-title">压力分析</text>
          <text class="analysis-desc">压力分析</text>
        </view>
      </view>

      <!-- 焦虑卡片 -->
      <view class="health-card">
        <view class="card-header">
          <!-- 焦虑图标 -->
          <image class="card-icon" src="/static/icons/anxiety.png"></image>
          <text class="card-title">焦虑</text>
        </view>
        <view class="health-chart">
          <view class="chart-y-axis">
            <text class="axis-label">100</text>
            <text class="axis-label">80</text>
            <text class="axis-label">60</text>
            <text class="axis-label">40</text>
            <text class="axis-label">20</text>
            <text class="axis-label">0</text>
          </view>
          <view class="chart-content">
            <!-- TODO: 添加焦虑图表 -->
          </view>
        </view>
        <view class="chart-x-axis">
          <text class="axis-label">00:00</text>
          <text class="axis-label">06:00</text>
          <text class="axis-label">12:00</text>
          <text class="axis-label">18:00</text>
          <text class="axis-label">24:00</text>
        </view>
        <view class="health-analysis">
          <text class="analysis-title">焦虑分析</text>
          <text class="analysis-desc">焦虑分析</text>
        </view>
      </view>

      <!-- 步数卡片 -->
      <view class="health-card">
        <view class="card-header">
          <!-- 步数图标 -->
          <image class="card-icon" src="/static/icons/steps.png"></image>
          <text class="card-title">步数</text>
        </view>
        <view class="health-chart">
          <view class="chart-y-axis">
            <text class="axis-label">10000</text>
            <text class="axis-label">8000</text>
            <text class="axis-label">6000</text>
            <text class="axis-label">4000</text>
            <text class="axis-label">2000</text>
            <text class="axis-label">0</text>
          </view>
          <view class="chart-content">
            <!-- TODO: 添加步数图表 -->
          </view>
        </view>
        <view class="chart-x-axis">
          <text class="axis-label">00:00</text>
          <text class="axis-label">06:00</text>
          <text class="axis-label">12:00</text>
          <text class="axis-label">18:00</text>
          <text class="axis-label">24:00</text>
        </view>
        <view class="health-analysis">
          <text class="analysis-title">步数分析</text>
          <text class="analysis-desc">步数分析</text>
        </view>
      </view>

      <!-- 体温分布卡片 -->
      <view class="health-card">
        <view class="card-header">
          <!-- 体温分布图标 -->
          <image class="card-icon" src="/static/icons/temperature.png"></image>
          <text class="card-title">体温分布</text>
        </view>
        <view class="health-chart">
          <view class="chart-y-axis">
            <text class="axis-label">42</text>
            <text class="axis-label">39</text>
            <text class="axis-label">36</text>
            <text class="axis-label">33</text>
            <text class="axis-label">30</text>
            <text class="axis-label">0</text>
          </view>
          <view class="chart-content">
            <!-- TODO: 添加体温分布图表 -->
          </view>
        </view>
        <view class="chart-x-axis">
          <text class="axis-label">00:00</text>
          <text class="axis-label">06:00</text>
          <text class="axis-label">12:00</text>
          <text class="axis-label">18:00</text>
          <text class="axis-label">24:00</text>
        </view>
        <view class="health-analysis">
          <text class="analysis-title">体温分布分析</text>
          <text class="analysis-desc">体温分布分析</text>
        </view>
      </view>
    </view>

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
export default {
  data() {
    return {
      weekDays: [
        { name: '周日', date: '26', selected: false },
        { name: '周一', date: '27', selected: false },
        { name: '周二', date: '28', selected: true },
        { name: '周三', date: '29', selected: false },
        { name: '周四', date: '30', selected: false },
        { name: '周五', date: '31', selected: false },
        { name: '周六', date: '1', selected: false }
      ],
      healthData: {
        bodyPower: 48,
        healthAdvice: '次健康\n您现在处于次健康状态\n请自观是否有长期持续头晕现象、身体僵硬等问题，请自查是否长期熬夜，晚上有夜宵习惯，喜欢烧烤、油炸类、腌制类食物，建议通过专业人士进行食疗。'
      },
      emotionGrid: [
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14'],
        ['#70B03D', '#FFDF0F', '#34EDDD', '#7351D5', '#FF3333', '#F26C0C', '#722A14']
      ]
    }
  },
  methods: {
    selectDate(index) {
      // 重置所有日期的选中状态
      this.weekDays.forEach(day => {
        day.selected = false;
      });
      // 设置当前选中日期
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
.power-icon,
.card-icon,
.tab-icon {
  width: 48rpx;
  height: 48rpx;
}

.power-icon,
.card-icon {
  background-color: rgba(255, 218, 60, 0.3);
  border-radius: 8rpx;
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
  font-size: 24rpx;
  color: #A4A4A4;
  margin-bottom: 8rpx;
}

.calendar-date {
  font-size: 24rpx;
  color: #A4A4A4;
  margin-bottom: 8rpx;
}

.calendar-indicator {
  width: 48rpx;
  height: 4rpx;
  background-color: transparent;
  border-radius: 2rpx;
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
  background-color: #1F1F1E;
  border-radius: 20rpx;
  padding: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.quick-text {
  font-size: 28rpx;
  color: #FBFBFB;
}

/* 身体电量卡片 */
.body-power-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
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
  padding: 32rpx;
  background-color: #2F2E2D;
  border-radius: 40rpx;
  border: 1rpx solid #3C3C3C;
}

.power-text {
  font-size: 24rpx;
  line-height: 1.6;
  color: #A4A4A4;
}

/* 卡片通用样式 */
.card-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 30rpx;
}

.card-title {
  font-size: 32rpx;
  color: #FFDA3C;
  font-weight: bold;
}

/* 当日情绪卡片 */
.emotion-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.emotion-grid {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  height: 120rpx;
  justify-content: space-between;
  margin-bottom: 30rpx;
  background-color: #0E1213;
  border-radius: 20rpx;
  padding: 8rpx;
  border: 1rpx solid #5D5D5D;
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

.emotion-details {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.emotion-state,
.emotion-analysis,
.emotion-therapy {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

.state-title,
.analysis-title,
.therapy-title {
  font-size: 28rpx;
  color: #FBFBFB;
  font-weight: bold;
  margin-bottom: 10rpx;
}

.state-desc,
.analysis-desc,
.therapy-desc {
  font-size: 24rpx;
  line-height: 1.6;
  color: #A4A4A4;
}

.emotion-list {
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.emotion-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.emotion-color {
  width: 24rpx;
  height: 24rpx;
  border-radius: 50%;
}

.emotion-name,
.emotion-percent {
  font-size: 24rpx;
  color: #A4A4A4;
}

/* 荷尔蒙卡片 */
.hormone-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.hormone-chart {
  display: flex;
  flex-direction: row;
  height: 200rpx;
  margin-bottom: 20rpx;
}

.chart-y-axis {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  width: 60rpx;
  padding-right: 10rpx;
}

.chart-content {
  flex: 1;
  background-color: #0E1213;
  border-radius: 20rpx;
  border: 1rpx solid #5D5D5D;
}

.axis-label {
  font-size: 20rpx;
  color: #A4A4A4;
}

.chart-x-axis {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-bottom: 30rpx;
}

.hormone-analysis {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

/* 睡眠卡片 */
.sleep-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.sleep-chart {
  height: 120rpx;
  background-color: #0E1213;
  border-radius: 20rpx;
  border: 1rpx solid #5D5D5D;
  margin-bottom: 30rpx;
}

.sleep-stats {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.stat-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  width: calc(50% - 10rpx);
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

.stat-icon {
  width: 32rpx;
  height: 32rpx;
  border-radius: 50%;
  margin-right: 16rpx;
}

.stat-info {
  display: flex;
  flex-direction: column;
}

.stat-name {
  font-size: 24rpx;
  color: #A4A4A4;
}

.stat-value {
  font-size: 28rpx;
  color: #FBFBFB;
  font-weight: bold;
}

.sleep-analysis {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

/* 心血管卡片 */
.cardiovascular-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.cardiovascular-chart {
  display: flex;
  flex-direction: row;
  height: 200rpx;
  margin-bottom: 20rpx;
}

.cardiovascular-details {
  margin-bottom: 30rpx;
}

.detail-header {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 20rpx;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  border: 1rpx solid #3C3C3C;
  margin-bottom: 10rpx;
}

.detail-header > text {
  font-size: 24rpx;
  color: #A4A4A4;
  flex: 1;
  text-align: center;
}

.detail-item {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 20rpx;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  border: 1rpx solid #3C3C3C;
  margin-bottom: 10rpx;
}

.item-name {
  display: flex;
  flex-direction: row;
  align-items: center;
  flex: 1;
}

.item-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  margin-right: 10rpx;
}

.item-name > text,
.item-result,
.item-risk,
.item-range {
  font-size: 24rpx;
  color: #A4A4A4;
  flex: 1;
  text-align: center;
}

.cardiovascular-analysis {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

/* 血压卡片 */
.blood-pressure-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.blood-pressure-chart {
  display: flex;
  flex-direction: row;
  height: 200rpx;
  margin-bottom: 20rpx;
}

.blood-pressure-stats {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-bottom: 30rpx;
}

.blood-pressure-stats .stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
  width: calc(50% - 10rpx);
}

.stat-name {
  font-size: 24rpx;
  color: #A4A4A4;
  margin-bottom: 10rpx;
}

.stat-unit {
  font-size: 20rpx;
  color: #A4A4A4;
  margin-bottom: 10rpx;
}

.stat-value {
  font-size: 32rpx;
  color: #FFDA3C;
  font-weight: bold;
}

.blood-pressure-distribution {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.distribution-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  width: calc(50% - 10rpx);
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

.item-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  margin-right: 10rpx;
}

.item-name,
.item-percent {
  font-size: 24rpx;
  color: #A4A4A4;
  flex: 1;
}

.blood-pressure-analysis {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

/* 疲劳卡片 */
.fatigue-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.fatigue-chart {
  display: flex;
  flex-direction: row;
  height: 200rpx;
  margin-bottom: 20rpx;
}

.fatigue-stats {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-bottom: 30rpx;
}

.fatigue-stats .stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
  width: calc(33.33% - 14rpx);
}

.fatigue-distribution {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  gap: 20rpx;
  margin-bottom: 30rpx;
}

.fatigue-distribution .distribution-item {
  width: calc(50% - 10rpx);
}

.fatigue-analysis {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

/* 其他健康指标卡片 */
.other-cards {
  margin: 0 30rpx;
}

.health-card {
  background-color: #1F1F1E;
  border-radius: 32rpx;
  padding: 36rpx;
  margin-bottom: 30rpx;
}

.health-chart {
  display: flex;
  flex-direction: row;
  height: 200rpx;
  margin-bottom: 20rpx;
}

.health-stats {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  margin-bottom: 30rpx;
}

.health-stats .stat-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
  width: calc(33.33% - 14rpx);
}

.health-analysis {
  background-color: #2F2E2D;
  border-radius: 20rpx;
  padding: 20rpx;
  border: 1rpx solid #3C3C3C;
}

/* 底部安全区域 */
.bottom-safe-area {
  height: 200rpx;
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
</file_content>