# MoonBallot

MoonBallot 是一个使用 MoonBit 编写的离线排名选票计票库，专注于**确定性、可复算和可验证**的投票方法实验。

它不收集选民身份信息，不连接网络，也不提供公共选举基础设施。输入是经过校验的候选人和加权严格排名选票，输出可以在不同目标上稳定复现。

## 功能

- 有界候选人、加权选票和严格排名模型
- 版本化文本 profile 的解析与规范化导出
- Plurality（相对多数）、固定 N 的 Borda 计分
- Pairwise 偏好矩阵、Condorcet winner 和 Copeland 计分
- 单席位 IRV（即时决选制）
- 耗尽票统计、确定性淘汰和平票安全停止
- IRV 逐轮 transcript 导出与结构校验

## 三个可复现的使用场景

### 1. 社区活动：运行 IRV 并查看逐轮淘汰

组织者把不含身份信息的加权排名选票放入 profile，解析后运行 IRV，得到每轮活跃候选人、票数、耗尽票、淘汰者和最终胜者。

```moonbit
let election = @moonballot.parse_profile("moonballot 1\ncandidates: Tea, Coffee, Juice\n4: Tea > Coffee > Juice\n3: Coffee > Juice\n2: Juice > Tea\n").unwrap()
let result = election.irv()
inspect(result.winner(), content="Some(\"Tea\")")
```

### 2. 课堂教学：比较不同计票规则

教师使用同一份排名选票计算 Plurality、Borda、Pairwise 和 Condorcet 结果，直观看到不同规则可能产生不同结论。

```moonbit
let election = @moonballot.parse_profile("moonballot 1\ncandidates: A, B, C\n3: A > B > C\n2: B > C > A\n2: C > B > A\n").unwrap()
let first_choice = election.plurality_winners()
let borda = election.borda_winners(2)
let condorcet = election.condorcet_winner()
inspect(first_choice)
inspect(borda)
inspect(condorcet)
```

### 3. CI 审计：导出并校验 IRV transcript

测试工具保存 IRV 的逐轮文本记录，之后用同一份已验证的 Election 检查记录结构；候选人集合、票数或权重被篡改时，校验会返回错误，而不是静默接受不一致结果。

```moonbit
let election = @moonballot.parse_profile("moonballot 1\ncandidates: A, B\n3: A > B\n2: B > A\n").unwrap()
let result = election.irv()
let transcript = result.to_text()
inspect(transcript)
assert_eq(result.verify(election), Ok(()))
```

## 输入格式

每个 profile 由版本行、候选人行和加权排名行组成；可使用 # 添加注释，也可以用空排名表示该票没有继续偏好：

```text
moonballot 1
candidates: Alice, Bob, Casey
4: Alice > Bob > Casey
3: Bob > Casey > Alice
2: Casey > Alice > Bob
1:
```

## 使用边界

MoonBallot 面向离线社区投票实验、教学和算法比较，不是法律认证的选举系统。当前不包含选民注册、身份认证、密码学、公共选举运营、多席位 STV、网络服务、分布式 leader election 或二进制协议。

## 验证

```text
moon fmt --check
moon check --target wasm-gc --deny-warn
moon check --target wasm --deny-warn
moon check --target js --deny-warn
moon check --target native --deny-warn
moon test --target wasm-gc --deny-warn
```

## 安装

MoonCakes 包：`hutingyu-nuist/moonballot`

```text
moon add hutingyu-nuist/moonballot
```

## 许可证

MIT License，详见 `LICENSE`。
