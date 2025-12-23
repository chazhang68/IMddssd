<template>
  <view class="blood-pressure-card">
    <view class="card-header">
      <image class="card-icon" src="/static/icons/blood-pressure@2x.png"></image>
      <text class="card-title">血压</text>
    </view>
    
    <!-- 图表区域 - 始终显示 -->
    <view class="chart-container">
      <qiun-data-charts 
        type="line"
        :opts="chartOpts"
        :chartData="chartDataDisplay"
        :canvas2d="true"
        canvasId="bpChart"
        background="none"
      />
    </view>
    
    <!-- 统计数据 -->
    <view class="blood-pressure-stats">
      <view class="stat-item" v-for="(item, index) in statsDisplay" :key="index">
        <view style="display: flex;flex-direction: column">
          <text class="stat-name">{{ item.name }}</text>
          <text class="stat-unit">{{ item.unit }}</text>
        </view>
        <view class="stat-value-row">
          <text class="stat-value">{{ item.value }}</text>
        </view>
      </view>
    </view>
    
    <!-- 分布图 -->
    <view class="distribution-container">
      <view class="ring-chart">
        <qiun-data-charts 
          type="ring"
          :opts="ringOpts"
          :chartData="ringDataDisplay"
          :canvas2d="true"
          canvasId="bpRing"
          background="none"
        />
      </view>
      <view class="legend-list">
        <view class="legend-item" v-for="(item, index) in distributionDisplay" :key="index">
          <view class="legend-dot" :style="{ background: item.color }"></view>
          <text class="legend-name">{{ item.name }}</text>
          <text class="legend-percent">{{ item.percent }}</text>
        </view>
      </view>
    </view>
    
    <!-- 分析区域 -->
    <view class="blood-pressure-analysis">
      <template v-if="hasData && isAnalysisObject">
        <view class="analysis-section">
          <text class="analysis-title">收缩压</text>
          <text class="analysis-text" v-if="analysis.systolic.conclusion">结论：{{ analysis.systolic.conclusion }}</text>
          <text class="analysis-text" v-if="analysis.systolic.description">描述：{{ analysis.systolic.description }}</text>
          <text class="analysis-text" v-if="analysis.systolic.suggestion">建议：{{ analysis.systolic.suggestion }}</text>
        </view>
        <view class="analysis-section mt-20">
          <text class="analysis-title">舒张压</text>
          <text class="analysis-text" v-if="analysis.diastolic.conclusion">结论：{{ analysis.diastolic.conclusion }}</text>
          <text class="analysis-text" v-if="analysis.diastolic.description">描述：{{ analysis.diastolic.description }}</text>
          <text class="analysis-text" v-if="analysis.diastolic.suggestion">建议：{{ analysis.diastolic.suggestion }}</text>
        </view>
      </template>
      <template v-else-if="hasData && !isAnalysisObject">
        <text class="analysis-title">血压分析</text>
        <text class="analysis-desc">{{ analysis }}</text>
      </template>
      <template v-else>
        <text class="analysis-title">血压分析</text>
      </template>
    </view>
  </view>
</template>

<script>
export default {
  name: 'BloodPressureCard',
  props: {
    stats: {
      type: Array,
      default: () => []
    },
    distribution: {
      type: Array,
      default: () => []
    },
    analysis: {
      type: [String, Object],
      default: ''
    },
    chartData: {
      type: Object,
      default: () => ({ categories: [], series: [] })
    },
    hasData: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      chartOpts: {
        color: ["#FF5D8D", "#5DD5C8"],
        padding: [15, 10, 0, 15],
        enableScroll: false,
        legend: { show: false },
        xAxis: {
          disableGrid: true,
          fontColor: "#A4A4A4",
          fontSize: 10
        },
        yAxis: {
          gridType: "dash",
          gridColor: "#333333",
          dashLength: 4,
          splitNumber: 5,
          min: 0,
          max: 200,
          data: [
            { min: 0, max: 200 }
          ],
          fontColor: "#A4A4A4",
          fontSize: 10
        },
        extra: {
          line: {
            type: "curve",
            width: 2,
            activeType: "hollow"
          }
        }
      },
      ringOpts: {
        timing: "easeOut",
        duration: 1000,
        rotate: false,
        rotateLock: false,
        color: ["#255FBE", "#333333", "#FB3A3A", "#F26C0C"],
        padding: [5, 5, 5, 5],
        fontSize: 13,
        fontColor: "#666666",
        dataLabel: false,
        legend: { show: false },
        title: { show: false },
        subtitle: { show: false },
        extra: {
          ring: {
            ringWidth: 15,
            activeOpacity: 0.5,
            activeRadius: 10,
            offsetAngle: 0,
            labelWidth: 15,
            border: false,
            borderWidth: 3,
            borderColor: "#FFFFFF",
            linearType: "custom"
          }
        }
      }
    }
  },
  computed: {
    isAnalysisObject() {
      return typeof this.analysis === 'object' && this.analysis !== null;
    },
    statsDisplay() {
      if (this.hasData) {
        return this.stats;
      }
      return [
        { name: '最高血压', unit: 'mmHg', value: '00' },
        { name: '最低血压', unit: 'mmHg', value: '00' }
      ];
    },
    distributionDisplay() {
      if (this.hasData) {
        return this.distribution;
      }
      return [
        { name: '正常', percent: '0%', color: '#255FBE' },
        { name: '正常高值', percent: '0%', color: '#5DD5C8' },
        { name: '低血压', percent: '0%', color: '#FB3A3A' },
        { name: '高血压', percent: '0%', color: '#F26C0C' }
      ];
    },
    chartDataDisplay() {
      if (this.hasData && this.chartData && this.chartData.series && this.chartData.series.length > 0) {
        return this.chartData;
      }
      // 空数据状态的图表
      return {
        categories: ["00:00", "06:00", "12:00", "18:00", "24:00"],
        series: []
      };
    },
    ringDataDisplay() {
      if (this.hasData) {
        // 根据 distribution 生成 ring chart data
        // 假设 distribution 格式: { name, percent: '100%', color }
        const seriesData = this.distribution.map(item => ({
          name: item.name,
          value: parseInt(item.percent) || 0,
          color: item.color
        }));
        
        return {
          series: [{
            data: seriesData
          }]
        };
      }
      
      // 空环形图 (显示灰色环)
      return {
        series: [{
          data: [{ name: "无数据", value: 100, color: "#2F2E2D" }]
        }]
      };
    }
  }
}
</script>

<style scoped>
.blood-pressure-card {
  background-color: #1F1F1E;
  border-radius: 68rpx;
  padding: 36rpx;
  margin: 0 30rpx 30rpx;
}

.card-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 38rpx;
}

.card-icon {
  width: 48rpx;
  height: 48rpx;
}

.card-title {
  font-weight: 500;
  font-size: 32rpx;
  color: #FFDA3C;
}

.chart-container {
  height: 350rpx;
  width: 100%;
  margin-bottom: 26rpx;
}

.blood-pressure-stats {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: 18rpx;
  margin-bottom: 16rpx;
}

.stat-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-radius: 40rpx;
  padding: 26rpx;
  border: 2rpx solid #A4A4A4;
}

.stat-name {
  font-weight: bold;
  font-size: 14px;
  color: #FBFBFB;
}

.stat-value-row {
  display: flex;
  flex-direction: row;
  align-items: baseline;
  justify-content: flex-end;
}

.stat-unit {
  font-weight: 400;
  font-size: 12px;
  color: #A4A4A4;
}

.stat-value {
  font-weight: bold;
  font-size: 20px;
  color: #FFDA3C;
}

.distribution-container {
  display: flex;
  flex-direction: row;
  background-color: #2F2E2D;
  border-radius: 24rpx;
  padding: 30rpx;
  margin-bottom: 16rpx;
  align-items: center;
}

.ring-chart {
  width: 200rpx;
  height: 200rpx;
}

.legend-list {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.legend-item {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.legend-dot {
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  margin-right: 16rpx;
}

.legend-name {
  flex: 1;
  font-size: 24rpx;
  color: #A4A4A4;
}

.legend-percent {
  font-size: 24rpx;
  color: #FBFBFB;
}

.blood-pressure-analysis {
  background-color: #2F2E2D;
  border-radius: 40rpx;
  padding: 24rpx;
  border: 2rpx solid #3C3C3C;
}

.analysis-section {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.mt-20 {
  margin-top: 20rpx;
}

.analysis-title {
  font-size: 12px;
  color: #A4A4A4;
}

.analysis-desc, .analysis-text {
  font-size: 24rpx;
  line-height: 1.6;
  color: #A4A4A4;
}
</style>