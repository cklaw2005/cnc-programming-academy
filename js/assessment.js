import { quiz } from './content.js';

export const assessmentPools = {
  beginner: quiz.slice(0, 5),
  intermediate: [quiz[5], quiz[6], quiz[8], quiz[11], quiz[15], quiz[16]],
  advanced: [quiz[7], quiz[9], quiz[10], quiz[12], quiz[13], quiz[14], quiz[17]]
};

const bi = (en, zh) => ({ en, zh });

export const assessmentAssignments = {
  beginner: {
    title: bi('Write a short absolute linear-move fragment','编写简短的绝对直线移动片段'),
    prompt: bi('Write a three-block teaching fragment that selects metric and absolute mode, rapids to X0 Y0, then feeds to X10 Y0 at F100.','编写三段教学片段：选择公制和绝对模式，快速到 X0 Y0，再以 F100 进给到 X10 Y0。'),
    model: 'G21 G90\nG00 X0 Y0\nG01 X10 Y0 F100',
    rubric: bi('Check units, distance mode, rapid positioning, feed motion, and explicit feed. Fragment only; no setup or safety context is supplied.','检查单位、距离模式、快速定位、进给移动和明确进给值。此为片段，不含装夹和安全信息。')
  },
  intermediate: {
    title: bi('Find and correct the modal-cycle error','找出并修正模态循环错误'),
    prompt: bi('The code calls a documented drilling cycle, then positions to another feature. Identify the missing cancellation and write the cancellation code.','程序调用有手册依据的钻孔循环，随后定位到另一个特征。指出缺少的取消指令并写出代码。'),
    model: 'G80',
    rubric: bi('State that modal-cycle behavior is controller-specific and that safe-plane/return behavior must be verified.','说明模态循环行为依控制器而异，并需核实安全平面和返回方式。')
  },
  advanced: {
    title: bi('Plan a controlled machining DOE','规划受控加工 DOE'),
    prompt: bi('Draft a trial plan to study cutting speed and feed against surface roughness and tool life. Include objective, safe factor levels, response measures, run design, measurement check, containment, and approval.','草拟一份试验计划，研究切削速度和进给对表面粗糙度及刀具寿命的影响。包含目标、安全因子水平、响应指标、试验设计、测量检查、隔离措施和批准。'),
    model: 'Objective + controlled factors/levels + measured responses + randomized/blocked run plan + measurement-system check + product containment + authorization + confirmation/standardization decision.',
    rubric: bi('Compare your plan with each listed element; this exercise is self-reviewed and is not a released process plan.','按列出的各项检查计划。本练习供自我评审，不是获准发布的工艺计划。')
  }
};
