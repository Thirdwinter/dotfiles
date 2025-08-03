// getSdfRectangle 函数:
// 计算给定点 `p` 到一个矩形的有符号距离。
// `xy` 是矩形的中心，`b` 是矩形半宽/半高（half-size）。
// 有符号距离场 (SDF) 是一个函数，可以告诉我们一个点在形状内部还是外部，
// 并且距离形状边界有多远。内部为负，外部为正。
float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    // 计算点 `p` 到矩形中心 `xy` 的距离，然后减去矩形的半尺寸 `b`。
    // 这将得到一个向量 `d`，其分量表示点到矩形每个边的距离。
    vec2 d = abs(p - xy) - b;
    // `length(max(d, 0.0))` 计算点到矩形外部最近点的距离。
    // `min(max(d.x, d.y), 0.0)` 计算点在矩形内部时到边界的距离。
    // 两者相加得到最终的有符号距离。
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// 基于 Inigo Quilez 的 2D 距离函数文章：https://iquilezles.org/articles/distfunctions2d/
// 通过消除条件语句和循环来优化，以提高性能和减少分支。

// seg 函数:
// 这是 `getSdfParallelogram` 的辅助函数。
// 它计算点 `p` 到线段 `a` 和 `b` 的距离，并确定点是否在线段的“左侧”或“右侧”以进行符号翻转。
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    // `e` 是线段的方向向量。
    vec2 e = b - a;
    // `w` 是从线段起点 `a` 到点 `p` 的向量。
    vec2 w = p - a;
    // 计算 `w` 在 `e` 上的投影，并将其钳制在 `0.0` 到 `1.0` 之间。
    // 这将找到线段 `a-b` 上距离点 `p` 最近的点 `proj`。
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    // 计算点 `p` 到最近点 `proj` 的距离平方。
    float segd = dot(p - proj, p - proj);
    // 将 `segd` 与之前的最小距离 `d` 进行比较，并更新 `d`。
    d = min(d, segd);

    // 接下来的几行使用 `step` 函数来模拟条件判断，避免 if-else 语句。
    // `c0` 检查点 `p` 是否在 `a` 的上方。
    float c0 = step(0.0, p.y - a.y);
    // `c1` 检查点 `p` 是否在 `b` 的下方。
    float c1 = 1.0 - step(0.0, p.y - b.y);
    // `c2` 检查点 `p` 是否在线段 `a-b` 的左侧。
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    // 如果所有条件都满足，`allCond` 为 `1.0`。
    float allCond = c0 * c1 * c2;
    // 如果所有条件都不满足，`noneCond` 为 `1.0`。
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    // `mix` 函数根据 `allCond + noneCond` 决定 `flip` 是 `1.0` 还是 `-1.0`。
    // 这用于根据点的位置翻转距离的符号，以表示点在形状的内部或外部。
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    // 将 `s` 乘以 `flip` 来更新符号。
    s *= flip;
    // 返回最小距离平方。
    return d;
}

// getSdfParallelogram 函数:
// 计算给定点 `p` 到一个由四个顶点 `v0`、`v1`、`v2`、`v3` 定义的平行四边形
// 的有符号距离。
float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    // `s` 是距离的符号，默认为 `1.0` (正)。
    float s = 1.0;
    // `d` 是点 `p` 到某个顶点的初始距离平方。
    float d = dot(p - v0, p - v0);

    // 依次调用 `seg` 函数计算点 `p` 到平行四边形每条边的距离，并更新符号 `s` 和最小距离 `d`。
    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    // 返回符号 `s` 乘以距离的平方根（即实际距离）。
    return s * sqrt(d);
}

// normalize 函数:
// 将输入向量 `value` 规范化到一个范围，通常是 `-1` 到 `1`。
// `isPosition` 标志用于区分位置向量和大小向量。
vec2 normalize(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

// antialising 函数:
// 计算一个平滑的抗锯齿因子。
// 它使用 `smoothstep` 函数在距离 `distance` 接近 `0` 时生成一个平滑的过渡。
float antialising(float distance) {
    // `normalize(vec2(2., 2.), 0.).x` 用于计算一个很小的阈值，
    // 以便在距离很小时进行平滑处理。
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

// determineStartVertexFactor 函数:
// 确定在绘制平行四边形时，应该从当前光标的哪个顶点开始。
// 这是为了确保轨迹（平行四边形）的形状正确。
float determineStartVertexFactor(vec2 a, vec2 b) {
    // 使用 `step` 函数来检查 `a` 和 `b` 之间的相对位置。
    // 如果 `a` 的 x 坐标小于 `b`，且 `a` 的 y 坐标大于 `b`，则 `condition1` 为 `1.0`。
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    // 如果 `a` 的 x 坐标大于 `b`，且 `a` 的 y 坐标小于 `b`，则 `condition2` 为 `1.0`。
    float condition2 = step(a.x, b.x) * step(b.y, a.y);

    // 如果以上两个条件都没有满足，则返回 `1.0` (默认情况)。
    return 1.0 - max(condition1, condition2);
}

// getRectangleCenter 函数:
// 计算一个由 `vec4` 定义的矩形的中心坐标。
// `rectangle.xy` 是左上角，`rectangle.zw` 是宽和高。
vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

// ease 函数:
// 一个简单的缓动函数，用于控制动画的进度。
// 这里使用 `(1-x)^3` 的三次幂函数，产生一个从快到慢的缓动效果。
float ease(float x) {
    return pow(1.0 - x, 3.0);
}

// saturate 函数:
// 增加颜色的饱和度。
// `color` 是输入的颜色，`factor` 是饱和度因子。
vec4 saturate(vec4 color, float factor) {
    // 计算颜色的亮度 (luminance)。
    float gray = dot(color, vec4(0.299, 0.587, 0.114, 0.));
    // 使用 `mix` 函数在灰色和原始颜色之间进行插值，`factor` 越高，
    // 颜色越接近原始颜色，饱和度越高。
    return mix(vec4(gray), color, factor);
}

// 着色器常量和全局变量
// `TRAIL_COLOR` 是鼠标轨迹的颜色，这里从 `iCurrentCursorColor` 获取。
vec4 TRAIL_COLOR = iCurrentCursorColor;
// `OPACITY` 是透明度常量，但在此代码中被注释掉未使用。
const float OPACITY = 0.6;
// `DURATION` 是轨迹消失的持续时间（秒）。
const float DURATION = 0.3;

// mainImage 函数:
// 这是着色器的主要入口点，为每个像素执行。
// `fragColor` 是输出颜色，`fragCoord` 是像素坐标。
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // 如果不是在 WebGL 环境下，从 `iChannel0` (通常是上一帧的画面) 获取背景颜色。
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    // 规范化 `fragCoord` 到一个 `-1` 到 `1` 的坐标空间。
    vec2 vu = normalize(fragCoord, 1.);
    // 偏移因子，用于调整矩形的中心点。
    vec2 offsetFactor = vec2(-.5, 0.5);

    // 规范化当前光标和前一帧光标的属性。
    // `xy` 是位置，`zw` 是尺寸。
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    // 根据光标移动方向确定平行四边形的起始顶点。
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;

    // 根据光标位置和尺寸，设置平行四边形的四个顶点。
    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + currentCursor.z * invertedVertexFactor, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + currentCursor.z * vertexFactor, previousCursor.y - previousCursor.w);

    // 使用 SDF 函数计算当前像素到光标矩形和轨迹平行四边形的距离。
    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

    // 计算动画的进度，从 `0.0` 到 `1.0`。
    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    // 对进度应用缓动函数。
    float easedProgress = ease(progress);
    // 计算光标中心点之间的距离，作为轨迹的长度。
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float lineLength = distance(centerCC, centerCP);

    // 创建一个名为 `newColor` 的临时颜色变量，并用背景色初始化。
    vec4 newColor = vec4(fragColor);

    // `trail` 颜色等于 `TRAIL_COLOR`。
    vec4 trail = TRAIL_COLOR;
    // 增加轨迹颜色的饱和度。
    trail = saturate(trail, 2.5);
    // 绘制轨迹：使用 `mix` 函数将 `newColor` 与 `trail` 颜色混合，
    // 混合因子由 `antialising(sdfTrail)` 决定。
    newColor = mix(newColor, trail, antialising(sdfTrail));
    // 绘制当前光标：使用 `mix` 函数将 `newColor` 与 `trail` 颜色混合。
    newColor = mix(newColor, trail, antialising(sdfCurrentCursor));
    // 如果点在光标矩形内部，将其颜色恢复为背景色。
    newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));
    // `OPACITY` 行被注释掉，所以不生效。
    // newColor = mix(fragColor, newColor, OPACITY);
    // 最终颜色混合：`fragColor` 与 `newColor` 混合，
    // 混合因子由 `step(sdfCurrentCursor, easedProgress * lineLength)` 决定。
    // 这部分代码控制光标轨迹的渐变和消失效果。
    fragColor = mix(fragColor, newColor, step(sdfCurrentCursor, easedProgress * lineLength));
}
