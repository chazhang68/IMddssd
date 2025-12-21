<template>
  <view class="detail-page">
    <view class="header-section">
      <view class="status-bar"></view>
      <view class="nav-bar">
        <view class="nav-left" @click="handleBack">
          <image class="nav-icon" src="/static/images/blood-pressure/right@2x.png" style="transform: rotate(180deg);" mode="aspectFit" />
        </view>
        <text class="nav-title">{{ pageData.title }}</text>
        <view class="nav-right"></view>
      </view>
    </view>
    
    <view class="content">
      <!-- 顶部数据卡片 -->
      <view class="data-card">
        <!-- 零星睡眠的特殊布局 -->
        <template v-if="type === 'sporadic'">
          <view class="card-row">
            <text class="card-label">零星睡眠</text>
            <text class="card-value">{{ cardData.time }}</text>
            <text class="card-status-text">{{ cardData.duration }}</text>
          </view>
        </template>
        
        <!-- 其他类型的通用布局 -->
        <template v-else>
          <view class="card-row">
            <view class="card-main-info">
              <text class="card-label">{{ pageData.cardTitle }}: {{ cardData.value }}</text>
              <text class="card-ref">{{ cardData.ref }}</text>
            </view>
            <text class="card-status-tag" :class="cardData.statusType">{{ cardData.status }}</text>
          </view>
        </template>
      </view>
      
      <!-- 内容文章区域 -->
      <view class="article-section">
        <view class="article-block" v-for="(section, index) in pageData.sections" :key="index">
          <text class="block-title">{{ section.title }}</text>
          <text class="block-content">{{ section.content }}</text>
        </view>
        
        <view class="references-block" v-if="pageData.references && pageData.references.length > 0">
          <text class="ref-header">参考文献</text>
          <text class="ref-item" v-for="(ref, idx) in pageData.references" :key="idx">{{ ref }}</text>
        </view>
      </view>
      
    </view>
  </view>
</template>

<script>
export default {
  data() {
    return {
      type: '',
      cardData: {},
      pageData: {
        title: '',
        cardTitle: '',
        sections: [],
        references: []
      },
      // 静态数据源
      dataSource: {
        duration: {
          title: '睡眠时长',
          cardTitle: '睡眠时长',
          sections: [
            {
              title: '1.睡眠时长标准',
              content: '每天保证充足的睡眠对于维持身心健康非常有益，美国国家睡眠基金会建议成年人可能合适的睡眠时长为6-10小时。研究证实，人群中存在“习惯性长睡者”（≥10小时/天）和“习惯性短睡者”（≤6小时/天），因此睡眠时间不是评价睡眠质量的唯一标准。如果睡眠时间低于推荐标准，也不必过分担忧，只要睡醒后觉得神清气爽，就不算失眠。另外，延长睡眠时间并不一定能弥补睡眠不足，长时间赖在床上，反而不利于得到高质量的睡眠。'
            },
            {
              title: '2.睡眠结构',
              content: '睡眠划分为快速眼动(RapidEyeMovement, REM)睡眠和非快速眼动(Non-REM,NREM)睡眠，其中NREM睡眠又包括了浅睡眠和深睡眠。在睡眠过程中，REM睡眠与NREM睡眠交替出现，交替一次称为一个睡眠周期。正常人整晚的睡眠一般包含4-6个睡眠周期，一个周期约为90-100分钟，每一个周期都不是前一个周期的简单重复。一般在靠后的睡眠周期中，REM睡眠时间增加NREM睡眠时间减少。典型的睡眠节律是按照以下顺序进行状态转换：清醒→浅睡→深睡→浅睡→快速眼动。但是，在实际睡眠过程中，不一定会经历所有的睡眠状态，睡眠状态之间的转换也不一定是完全规律的。例如，人可以直接从浅睡、深睡和REM中的任何一个状态转为清醒状态。'
            }
          ],
          references: [
            '[1] Prevalent Hypertension and Stroke in the Sleep Heart Health Study: Association with an EcG-derived Spectrographic Marker of Cardiopulmonary Coupling. Sleep, 2009, 32(7): 897-904.',
            '\n\n[2] 《睡眠医学理论与实践》，人民卫生出版社, 2010年8月第4版。'
          ]
        },
        deep: {
          title: '深睡比例',
          cardTitle: '深睡比例',
          sections: [
            {
              title: '1.什么是深睡眠？',
              content: '在深睡眠阶段，脑电波频率明显变慢，呼吸频率和血压他也明显降低，因此深睡眠也称为慢波睡眠。人在深睡眠阶段的睡眠程度最深，唤醒阈最高。如果在深睡眠阶段被唤醒，可能出现头晕、心、心情烦燥等症状。研究发现，在深睡眠阶段，大脑可以得到充分休息，消除疲劳的效果也最好。深睡眠对稳定情绪、平衡心态、恢复精力极为重要，一般来说，深睡眠时间越长，睡眠质量就越好。'
            },
            {
              title: '2.如何拥有充足的睡眠？',
              content: '根据美国医师协会(ACP)发布的成人慢性失眠障碍管理指南，推荐认知和行为治疗作为失眠的初始治疗。临床实践表明，慢性失眠者通常有一些不良睡眠习惯。如果您想提升睡眠质量，缓解浅睡过多、深睡不足的情况，可参考如下睡眠改善建议：\n\n(1) 心理因素：过度兴奋、焦虑、精神紧张、抑郁等情绪都可能导致浅睡增加、深睡不足，一般随着这些情绪反应的缓解，睡眠质量可以得到改善。\n\n(2) 生理因素：过度疲劳、各种疾病引起的身体不适(如疼痛、瘙痒、咳嗽等)均可能导致浅睡过多、深睡不足。\n\n(3) 环境因素：光线、噪音、温湿度等因素都会干扰足的情况。\n\n(4) 生活节律：倒班、时差、作息不规律等因素都会使体内的生物钟紊乱，导致浅睡过多、深睡不足。定时休息，准时上床睡觉，准时起床迎接阳光，让生物钟正常运行，可以改善睡眠质量。\n\n(5) 饮食：咖啡因、尼古丁、酒精和刺激性的食物，都对深睡眠有干扰作用，导致浅睡眠过多。远离烟酒，午后不喝咖啡、浓茶，晚餐避免大吃大喝。\n\n(6) 运动：适当运动，使躯体疲劳感增加时，人体就需要增加深睡时间消除疲劳，浅睡眠比例会随之降低。不过，临睡前应避免剧烈运动，否则处于兴奋状态的肢体及高体温可能让您入睡困难。'
            }
          ],
          references: [
            '[1] Management of Chronic Insomnia Disorder in Adults: A Clinical Practice Guideline From the American College of Physicians. Www.annals.org May 2016.',
            '\n[2] Sleep State Instabilities in Major Depressive Disorder: Detection and Quantification with Electrocardiogram-based Cardiopulmonary Coupling Analysis Psychophysiology, 2011, 48(2): 285-291.',
            '\n[3] 《睡眠障碍诊疗手册》，人民卫生出版社, 2012年9月第1版。'
          ]
        },
        light: {
          title: '浅睡比例',
          cardTitle: '浅睡比例',
          sections: [
            {
              title: '1.什么是浅睡眠？',
              content: '在浅睡眠阶段，脑电活动减慢，心率和呼吸速度放慢，人进入了睡眠但是很容易被唤醒。从睡眠中醒过来是一种保护机制，也是健康和生存的必须，因此浅睡也是一种正常的生理需要。但是，如果浅睡眠在总睡眠时间中所占的比例过高，睡眠质量就会变差，容易出现睡不醒、不能解乏的感觉。'
            },
            {
              title: '2.如何改善浅睡过多的情况？',
              content: '根据美国医师协会(ACP)发布的成人慢性失眠障碍管理指南，推荐认知和行为治疗作为失眠的初始治疗。临床实践表明，慢性失眠者通常有一些不良睡眠习惯。如果您想提升睡眠质量，缓解浅睡过多、深睡不足的情况，可参考如下睡眠改善建议：\n\n(1) 心理因素：过度兴奋、焦虑、精神紧张、抑郁等情绪都可能导致浅睡增加、深睡不足，一般随着这些情绪反应的缓解，睡眠质量可以得到改善。\n\n(2) 生理因素：过度疲劳、各种疾病引起的身体不适(如疼痛、瘙痒、咳嗽等)均可能导致浅睡过多、深睡不足。\n\n(3) 环境因素：光线、噪音、温湿度等因素都会干扰足的情况。\n\n(4) 生活节律：倒班、时差、作息不规律等因素都会使体内的生物钟紊乱，导致浅睡过多、深睡不足。定时休息，准时上床睡觉，准时起床迎接阳光，让生物钟正常运行，可以改善睡眠质量。\n\n(5) 饮食：咖啡因、尼古丁、酒精和刺激性的食物，都对深睡眠有干扰作用，导致浅睡眠过多。远离烟酒，午后不喝咖啡、浓茶，晚餐避免大吃大喝。\n\n(6) 运动：适当运动，使躯体疲劳感增加时，人体就需要增加深睡时间消除疲劳，浅睡眠比例会随之降低。不过，临睡前应避免剧烈运动，否则处于兴奋状态的肢体及高体温可能让您入睡困难。'
            }
          ],
          references: [
            '[1] Management of Chronic Insomnia Disorder in Adults: A Clinical Practice Guideline From the American College of Physicians. Www.annals.org May 2016.',
            '\n[2] Sleep State Instabilities in Major Depressive Disorder: Detection and Quantification with Electrocardiogram-based Cardiopulmonary Coupling Analysis Psychophysiology, 2011, 48(2): 285-291.',
            '\n[3] 《睡眠障碍诊疗手册》，人民卫生出版社, 2012年9月第1版。'
          ]
        },
        rem: {
          title: '快速眼动比例',
          cardTitle: '快速眼动比例',
          sections: [
            {
              title: '1.什么是快速眼动睡眠？',
              content: '在快速眼动(RapidEyeMovement, REM)睡眠阶段，人的眼球在眼皮下快速地来回移动，在该阶段被唤醒者绝大多数报告正在做梦。快速眼动睡眠的唤醒阈高于浅睡眠，低于深睡眠，在此阶段肌肉一般股处于松弛状态。这是一种安全保护机制，避免我们在梦中做出动作，这也解释了为什么经常梦到跑不起来或叫不出来。'
            },
            {
              title: '2.如何拥有正常的快速眼动睡眠？',
              content: '维持正常的快速眼动睡眠时间对于精神健康非常重要，有助于提升创造力、舒缓压力。研究表明，剥夺了受试者的快速眼动睡眠后，受试者会烦躁、紧张和容易疲惫。睡梦主要发生在快速眼动睡眠阶段，快速眼动睡眠比例偏高可能表现为多梦。许多人把多梦误认为是睡眠质量不好的原因，实际上是因为睡的不深，导致教醒来容易记住梦境。当快速眼动睡眠不足时，我们的身体会自动通过延长之后几入晚上的快速眼动睡眠时间来弥补，无需过度担心。如果长期快速眼动比例过高或过低，并伴有易感、焦虑等症状，建议寻求专业医生的指导。如果您想拥有正常的快速眼动睡眠，可参考如下睡眠改善建议：\n\n(1) 生活规律：一般来说，越到后半夜的睡眠周期中，快速眼动睡眠时间越长，如果您觉得自一多梦，建议您调整作息时间，早睡早起。\n\n(2) 心理因素：避免过度焦虑和疲劳，及时舒缓工作生活中的压力，有助于维持正常的快速眼动睡眠时间比例。\n\n(3) 饮食：咖啡因、酒精、尼古丁或药物可能对快速眼动产生影响。'
            }
          ],
          references: []
        },
        sporadic: {
          title: '零星睡眠',
          cardTitle: '零星睡眠',
          sections: [
            {
              title: '1.零星小睡时长标准？',
              content: '夜间睡眠时间不足或睡眠质量不高，可以在日间通过适当的小睡来补充精力。一般来说，在中午1点之前小睡15-30分钟，可以让您重新精力充沛，提升下午的清醒程度和工作效率。但是，日间小睡时间不宜超过40分钟，否则可能让您进入深睡阶段，体温下降，醒来后感非常困倦、或出现头晕、感心等不良症状。同时，如果日天进入了深睡，会降低夜晚的睡意，导致夜间难以入睡。'
            },
            {
              title: '2.什么时候适合日间小睡？',
              content: '生物钟里最重要的部分就是体温节律，当体温升高时，人会感觉更清醒；当体温下降时，人会感觉到身体疲乏，睡意来袭。体温在一天之中呈周期性的波动，在早晨开始上升，午间有时会进行下调，然后继续上升，直到夜晚来临。因此，在中午体温回落时(一般股在中午1点之前)小睡，效果是最好的。日间小睡时间过晚，会对体温节律产生干扰，影响夜间睡眠质量。\n\n*未超过3小时的单次睡眠均统计在零星小睡中。'
            }
          ],
          references: [
            '[1] The Circadian Rhythm of Body Temperature. Frontiers in Bioscience, 2010 (15): 564-594.',
            '\n[2] 《睡眠障碍诊疗手册》，人民卫生出版社, 2012年9月第1版。'
          ]
        }
      }
    }
  },
  onLoad(options) {
    if (options && options.type) {
        this.type = options.type
        this.updatePageInfo(options)
    }
  },
  methods: {
    handleBack() {
      const uniApi = (globalThis).uni
      if (uniApi?.navigateBack) {
        uniApi.navigateBack()
        return
      }
      if (typeof history !== 'undefined' && history.length > 1) {
        history.back()
      }
    },
    updatePageInfo(options) {
      // 1. 获取页面静态内容配置
      const pageConfig = this.dataSource[this.type]
      if (pageConfig) {
        this.pageData = pageConfig
      }

      // 2. 设置顶部卡片数据
      // 这里模拟不同类型的数据，实际项目中可能从上一页传递或API获取
      if (this.type === 'duration') {
        this.cardData = {
          value: '5时35分',
          ref: '参考值: 6-10时',
          status: '偏低',
          statusType: 'low'
        }
      } else if (this.type === 'deep') {
        this.cardData = {
          value: '42%',
          ref: '参考值: 20%-60%',
          status: '正常',
          statusType: 'normal'
        }
      } else if (this.type === 'light') {
        this.cardData = {
          value: '43%',
          ref: '参考值: <55%',
          status: '正常',
          statusType: 'normal'
        }
      } else if (this.type === 'rem') {
        this.cardData = {
          value: '15%',
          ref: '参考值: 10%-30%',
          status: '正常',
          statusType: 'normal'
        }
      } else if (this.type === 'sporadic') {
        // 零星睡眠的数据从参数获取，或者使用默认值
        this.cardData = {
          time: options.time || '12:32-12:42',
          duration: options.duration || '0时10分'
        }
      } else if (this.type === 'awake') {
        this.cardData = {
           value: '5',
           ref: '参考值: 0-2次',
           status: '偏高',
           statusType: 'high'
        }
        // 清醒次数的内容暂时复用 duration 或者给一个默认的
        if (!pageConfig) {
             this.pageData = {
                 title: '清醒次数',
                 cardTitle: '清醒次数',
                 sections: [{title:'关于清醒次数', content:'清醒次数反映了睡眠的连续性...'}],
                 references: []
             }
        }
      }
    }
  }
}
</script>

<style scoped>
.detail-page {
  min-height: 100vh;
  background-color: #0e1213;
  display: flex;
  flex-direction: column;
}

.header-section {
  background-color: #ffda3c;
  padding-bottom: 10px;
}

.status-bar {
  height: var(--status-bar-height, 44px);
}

.nav-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  height: 44px;
  padding: 0 16px;
}

.nav-left {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.nav-icon {
  width: 24px;
  height: 24px;
}

.nav-title {
  font-size: 18px;
  font-weight: 600;
  color: #000000;
}

.nav-right {
  width: 40px;
}

.content {
  flex: 1;
  padding: 16px;
}

/* 顶部数据卡片 */
.data-card {
  border-radius: 38rpx; /* 加大圆角 */
  padding: 30rpx 38rpx;
  margin-bottom: 15rpx;
  border: 2rpx solid #A4A4A4;
}

.card-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.card-main-info {
  display: flex;
  flex-direction: column;
}

.card-label {
  font-weight: 500;
  font-size: 27rpx;
  color: #FBFBFB;
  line-height: 27rpx;
  margin-bottom: 6rpx;
}

.card-ref {
  font-weight: 400;
  font-size: 23rpx;
  color: #A4A4A4;
  line-height: 23rpx;
}

.card-status-tag {
  font-weight: 500;
  font-size: 27rpx;
  color: #F21717;
  line-height: 27rpx;
}

.card-status-tag.normal {
  color: #4A90E2; /* 蓝色 */
}

.card-status-tag.low, .card-status-tag.high {
  color: #FF5B5B; /* 红色 */
}

/* 零星睡眠的特殊样式 */
.card-value {
  font-size: 18px;
  color: #ffffff;
  font-weight: 500;
}

.card-status-text {
  font-size: 18px;
  color: #ffffff;
  font-weight: 500;
}

/* 文章区域 */
.article-section {
  padding: 0 4px;
}

.article-block {
  margin-bottom: 15rpx;
}

.block-title {
  font-size: 31rpx;
  font-weight: 500;
  color: #FBFBFB;
  margin-bottom: 15rpx;
  display: block;
}

.block-content {
  font-size: 27rpx;
  color: #A4A4A4;
  line-height: 34rpx;
  text-align: justify;
  display: block;
  white-space: pre-wrap; /* 支持换行符 */
}

/* 参考文献 */
.references-block {
  margin-top: 20rpx;
  margin-bottom: 30rpx;
}

.ref-header {
  font-size: 16px;
  font-weight: 600;
  color: #ffffff;
  margin-bottom: 12px;
  display: block;
}

.ref-item {
  font-weight: 400;
  font-size: 27rpx;
  color: #A4A4A4;
  line-height: 34rpx;
  display: block;
  white-space: pre-wrap; /* 支持换行符 */
}


</style>