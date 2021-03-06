# 最適化
* 確率論的最適化
* 多くの異なる解に対してスコアリングを行い、それぞれの解の質を決める

## グループ旅行
* 解の表現にはシンプルなものを用いる
    * 最適化関数の一般性が高い

### コスト関数
* スケジュールの多様な属性に重み付けする
* コストを生ずる変数を選び、ひとつの数字にまとめる関数を作る
* この関数を基に、正しい数字の組み合わせを選んでコストを最小化する
    * 全通り試すのは非現実的

### ランダムサーチ
* 無作為抽出
* 内部でコスト関数を呼び出す
    * 他の手法でも同じ
* 抽出数をいじる

### ヒルクライム
* 無作為解から出発し、近傍解の中からより優れたものを探す
    * コストグラフの丘下り
    * スケジュールを前後にずらす
* **すべての**近傍解のなかで最小を探す
* 局所最小
    * 大域最小ではない

### 模擬アニーリング
* 焼きなまし
* 高いエネルギーを持つ原子がゆっくり低いエネルギー状態に落ち着くことで、全体の配列のエネルギー状態が小さくなる
* 無作為解から出発し、次第に小さい解を探す
    * 温度を表す変数を使う
* 一定の確率で、コストが大きくなる新しい解も採用する
    * 局所最小の回避
    * `p = exp(-(high - low) / temperature)`
        * 1 -> 0
        * 温度が下がるにつれ、悪い解の採用確率は低くなる

### 遺伝アルゴリズム
* 無作為解の集合である個体群を生成する
* 個体群の全メンバーに対してコスト計算
* エリート抽出や突然変異、交叉を経て新しい個体群（世代）を生成
* 突然変異
    * 既存の解に小さく単純な変更をランダムに加える
* 交叉
    * 優れた２つの解を何らかの方法で組み合わせる
        * 前半後半
* 決まった世代数、あるいは一定の世代数改善が見られなくなるまで続ける


## 学寮の最適化
* 割り当て問題
* コストをできるだけ0に近づける
    * コスト関数の作成時に完全解を決めておく

## レイアウト問題
* 見やすいネットワーク図を作る
* mass-and-spring
    * 斥力を発するノード同士が互いに離れようとする
    * 接続のないノードが遠くに、あるノードが適当な距離に配置される
    * 線の交差は妨げない
* 交差した線の数を数えるコスト関数
    * 全ノードの座標をリストに突っ込む
* 近すぎるノード間に関してはペナルティを加えたりする
