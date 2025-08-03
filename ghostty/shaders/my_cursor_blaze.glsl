// ease 函数：用于控制动画的缓动效果。
// 返回 `(1.0 - x)` 的 10 次幂，当 `x` 从 0 变到 1 时，返回值从 1 快速衰减到 0，产生一个非常明显的“快进快出”或“快速减速”的动画效果。
float ease(float x) {
    return pow(1.0 - x, 10.0);
}

// sdBox 函数：计算点 `p` 到一个轴对齐矩形（Axis-Aligned Bounding Box, AABB）的有符号距离。
// `xy` 是矩形中心的坐标，`b` 是矩形半长宽（即宽度和高度的一半）。
// 这是 Inigo Quilez 常用的一种高效 SDF (Signed Distance Field) 实现。
float sdBox(in vec2 p, in vec2 xy, in vec2 b)
{
    // 计算点 `p` 距离矩形中心 `xy` 的绝对距离，然后减去矩形半长宽 `b`。
    // 结果 `d` 的 `x` 和 `y` 分量如果为正，表示 `p` 在矩形对应轴的外部；如果为负，则在内部。
    vec2 d = abs(p - xy) - b;
    // `length(max(d, 0.0))`：计算点 `p` 到矩形外部最近边缘的距离。如果点在矩形内部，`max(d, 0.0)` 会是 `(0, 0)`，长度为 0。
    // `min(max(d.x, d.y), 0.0)`：处理点 `p` 在矩形内部的情况。`max(d.x, d.y)` 会是 `d` 中最大（最不负）的负值（或 0），
    // 再与 `0.0` 取 `min`，确保当点在外部时此项为 0，在内部时返回负的最小距离（代表到最近内部边缘的距离）。
    // 两部分相加，得到有符号距离：点在外部时为正值，在内部时为负值，在边界上为 0。
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// getSdfRectangle 函数：与 sdBox 函数功能完全相同，只是函数名更加明确地指出其用途是获取矩形的 SDF。
float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// seg 函数：计算点 `p` 到线段 `ab` 的距离，并尝试更新一个“内部/外部”符号 `s`。
// 此函数是根据 Inigo Quilez 的 2D 距离函数文章实现的，它在每次调用时都会尝试修正 `s` 的符号。
// 注意：这种通过迭代修正 `s` 的方法对于复杂多边形或特定形状的 SDF 计算可能不够鲁棒，
// 对于**凸多边形**，更常见的 SDF 计算方法是取点到所有边有符号距离的最大值。
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a; // 线段 `ab` 的方向向量
    vec2 w = p - a; // 从线段起点 `a` 到点 `p` 的向量

    // 计算点 `p` 在线段 `ab` 上的投影点。
    // `clamp(dot(w, e) / dot(e, e), 0.0, 1.0)` 将投影限制在线段范围内。
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    // `segd` 是点 `p` 到其在线段上投影点之间的距离的平方。
    float segd = dot(p - proj, p - proj);
    // 更新 `d` 为当前找到的最小距离的平方。
    d = min(d, segd);

    // 以下逻辑用于尝试确定点 `p` 位于线段 `ab` 的哪一侧，并更新符号 `s`。
    // `c0`: 如果 `p` 的 Y 坐标大于或等于 `a` 的 Y 坐标。
    float c0 = step(0.0, p.y - a.y);
    // `c1`: 如果 `p` 的 Y 坐标小于 `b` 的 Y 坐标。
    float c1 = 1.0 - step(0.0, p.y - b.y);
    // `c2`: 通过二维叉积 `e.x * w.y - e.y * w.x` 判断 `p` 位于向量 `e` 的左侧还是右侧。
    // 如果叉积结果为正，表示 `w` 在 `e` 的逆时针方向（通常视为左侧）；负则为顺时针（右侧）。
    // `step(0.0, ...)` 会判断 `p` 是否在 `e` 的“正面”一侧。
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);

    // `allCond`: 当所有三个条件都为真时（例如，点在矩形边界框内部且位于线段的特定一侧）。
    float allCond = c0 * c1 * c2;
    // `noneCond`: 当所有三个条件都为假时。
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    // `flip`: 根据 `allCond` 和 `noneCond` 的状态决定符号是否翻转。
    // `mix(1.0, -1.0, step(0.5, allCond + noneCond))`：如果 `allCond + noneCond` 大于 0.5（表示点在某个明确的“内侧”或“外侧”），则 `flip` 为 -1.0，否则为 1.0。
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    // `s` 乘以 `flip` 来翻转或保持其符号。
    s *= flip;
    return d; // 返回点到线段的最小距离的平方。
}

// getSdfParallelogram 函数：计算点 `p` 到一个由四个顶点 `v0, v1, v2, v3` 定义的四边形（通常用于平行四边形或梯形拖尾）的有符号距离。
// 此实现通过反复调用 `seg` 函数来累积距离和符号。
// 对于精确的 SDF，特别是在点位于形状内部时，这种方法可能不如基于半平面交集的 SDF 方法（即取点到各条边有符号距离的最大值）稳健。
float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0; // 初始符号，假定点在外部或内部，通过 `seg` 修正。
    float d = dot(p - v0, p - v0); // 初始距离平方，设置为点到第一个顶点 `v0` 的距离平方。

    // 依次计算点到四边形每条边的距离，并根据 `seg` 函数的逻辑更新最小距离 `d` 和符号 `s`。
    d = seg(p, v0, v3, s, d); // 点到边 `v0-v3`
    d = seg(p, v1, v0, s, d); // 点到边 `v1-v0`
    d = seg(p, v2, v1, s, d); // 点到边 `v2-v1`
    d = seg(p, v3, v2, s, d); // 点到边 `v3-v2`

    // 返回最终的有符号距离。`s` 决定了点在形状内部（负）还是外部（正），`sqrt(d)` 是实际的距离值。
    return s * sqrt(d);
}

// normalize 函数：将输入 `value`（可以是像素坐标或尺寸）归一化到更适合图形计算的相对空间。
// `value`: 要归一化的二维向量。
// `isPosition`: 一个浮点标志。如果为 `1.0`，表示 `value` 是屏幕像素位置，需要进行中心对齐归一化；
//               如果为 `0.0`，表示 `value` 是尺寸，只需按分辨率比例缩放。
vec2 normalize(vec2 value, float isPosition) {
    // 归一化公式：`(value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y`
    // - `value * 2.0`: 将 `value` 放大两倍。
    // - `(iResolution.xy * isPosition)`: 如果 `isPosition` 为 `1.0` (位置)，则减去 `iResolution.xy`，
    //   这会将 `[0, resolution]` 范围内的像素坐标映射到 `[-resolution, resolution]`。
    //   如果 `isPosition` 为 `0.0` (尺寸)，则减去 `0`，不进行偏移。
    // - `/ iResolution.y`: 最终除以屏幕高度 `iResolution.y`。
    //   这使得 Y 坐标通常归一化到 `[-1, 1]` 或 `[0, 2]` 范围，而 X 坐标则根据屏幕宽高比进行等比例缩放。
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

// blend 函数：一个平滑混合函数，也称为 Quadratic Ease-In-Out 或 Sigmoid 曲线的变体。
// 它提供了一个 S 形的缓动曲线，在 `t` 接近 0 或 1 时变化缓慢，在 `t` 接近 0.5 时变化最快。
float blend(float t)
{
    float sqr = t * t; // `t` 的平方
    // 返回 `sqr / (2.0 * (sqr - t) + 1.0)`。
    // 当 `t` 在 `[0, 1]` 范围时，函数值也在 `[0, 1]` 范围，并提供平滑的过渡。
    return sqr / (2.0 * (sqr - t) + 1.0);
}

// antialising 函数：实现简单的抗锯齿效果。
// `distance`: SDF 返回的距离值。
// `smoothstep(edge0, edge1, x)` 函数会在 `x` 从 `edge0` 变化到 `edge1` 的过程中，平滑地从 0 变化到 1。
// 这里的 `1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance)` 逻辑：
// - `normalize(vec2(2., 2.), 0.).x` 计算出一个很小的归一化宽度，作为抗锯齿的平滑过渡范围 `edge1`。
// - 当 `distance` 接近 0 时（在形状边缘或内部），`smoothstep` 的结果接近 0，`1. - 结果` 接近 1 (完全不透明)。
// - 随着 `distance` 增大（离开形状边缘），`smoothstep` 的结果逐渐增大到 1，`1. - 结果` 逐渐减小到 0 (完全透明)。
// 这样在形状边缘会有一个平滑的过渡带，减少锯齿感。
float antialising(float distance) {
    return 1. - smoothstep(0., normalize(vec2(2., 2.), 0.).x, distance);
}

// determineStartVertexFactor 函数：根据当前光标 `a` 和前一光标 `b` 的相对位置，
// 决定拖尾平行四边形在当前光标处应该从左上角还是右上角开始绘制，以保证拖尾方向正确。
// 返回一个因子（0.0 或 1.0），用于选择顶点的 X 偏移。
float determineStartVertexFactor(vec2 a, vec2 b) {
    // condition1: 如果 `b` 的 X 坐标小于 `a` (即 `b` 在 `a` 的左侧) 并且 `a` 的 Y 坐标大于 `b` (即 `a` 在 `b` 的上方)。
    // 这对应于光标从右下向左上移动的情况。
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    // condition2: 如果 `a` 的 X 坐标小于 `b` (即 `a` 在 `b` 的左侧) 并且 `b` 的 Y 坐标小于 `a` (即 `b` 在 `a` 的下方)。
    // 这对应于光标从左上向右下移动的情况。
    float condition2 = step(a.x, b.x) * step(b.y, a.y);

    // 如果 `condition1` 或 `condition2` 满足，`max` 的结果为 `1.0`。
    // 最终返回 `1.0 - 1.0 = 0.0`。
    // 否则（即两个条件都不满足），`max` 的结果为 `0.0`。
    // 最终返回 `1.0 - 0.0 = 1.0`。
    // 这个因子（0.0 或 1.0）将被用来乘以光标的宽度 `currentCursor.z`，以选择 `v0` 和 `v1` 的 X 坐标。
    return 1.0 - max(condition1, condition2);
}

// getRectangleCenter 函数：计算给定矩形（以 `vec4(x, y, width, height)` 格式表示）的中心坐标。
// `rectangle.x, rectangle.y` 是矩形的左上角坐标。
// `rectangle.z` 是矩形的宽度，`rectangle.w` 是矩形的高度。
vec2 getRectangleCenter(vec4 rectangle) {
    // 中心 X 坐标 = 左上角 X + 宽度 / 2
    // 中心 Y 坐标 = 左上角 Y - 高度 / 2 (因为屏幕坐标系 Y 轴向下，矩形的高度是向下延伸的，所以中心 Y 要减去高度的一半)
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

// vec4 TRAIL_COLOR = vec4(0.706, 0.745, 0.996, 1.0)
vec4 TRAIL_COLOR = iCurrentCursorColor; // 拖尾的主颜色，通常来自输入的当前光标颜色。
vec4 CURRENT_CURSOR_COLOR = TRAIL_COLOR; // 当前光标的颜色（这里与拖尾主色相同）。

const float DURATION = .5; // 动画持续时间（秒）。
// const float OPACITY = .2; // 拖尾的不透明度（此变量在 `mainImage` 函数中未直接使用）。

// mainImage 函数：GLSL Shader 的主入口点，为屏幕上的每一个像素计算其最终颜色。
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // 如果不是在 Web 环境下编译（例如在 Shadertoy），则从 `iChannel0` 获取背景纹理。
    // 这允许拖尾在现有内容之上绘制。
    #if !defined(WEB)
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    #endif

    // Normalization for fragCoord to a space of -1 to 1;
    // 将当前像素的屏幕坐标 `fragCoord` 归一化到一个以 `iResolution.y` 为基准的相对空间。
    // 这样，`vu` 的 Y 坐标通常在 `[-1, 1]` 范围，X 坐标则按宽高比缩放。
    vec2 vu = normalize(fragCoord, 1.);
    // `offsetFactor` 用于在计算 SDF 时对光标的中心进行调整，使其与 SDF 内部的坐标系更好地对齐。
    vec2 offsetFactor = vec2(-.5, 0.5);

    // Normalization for cursor position and size;
    // 归一化当前光标 (`iCurrentCursor`) 和前一光标 (`iPreviousCursor`) 的位置和尺寸。
    // `currentCursor.xy` 和 `previousCursor.xy` 存储归一化后的中心坐标。
    // `currentCursor.zw` 和 `previousCursor.zw` 存储归一化后的宽度和高度。
    vec4 currentCursor = vec4(normalize(iCurrentCursor.xy, 1.), normalize(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(normalize(iPreviousCursor.xy, 1.), normalize(iPreviousCursor.zw, 0.));

    // When drawing a parallelogram between cursors for the trail i need to determine where to start at the top-left or top-right vertex of the cursor
    // 确定绘制拖尾时，从当前光标的哪个顶角（左上或右上）开始绘制，以适应光标的移动方向。
    float vertexFactor = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor; // 另一个顶角的因子。

    // Set every vertex of my parellogram
    // 设置拖尾平行四边形（实际通常是梯形或三角形）的四个顶点。
    // `v0`: 当前光标顶部的第一个顶点（根据 `vertexFactor` 可能是左上或右上）。
    vec2 v0 = vec2(currentCursor.x + currentCursor.z * vertexFactor, currentCursor.y - currentCursor.w);
    // `v1`: 当前光标顶部的第二个顶点。
    // 注意：这里 `v1` 的 Y 坐标是 `currentCursor.y`，这意味着它可能比 `v0` 更低，这会影响拖尾的起始形状。
    vec2 v1 = vec2(currentCursor.x + currentCursor.z * invertedVertexFactor, currentCursor.y);

    // Taper the trail
    // 控制拖尾的锥形（变窄）效果。
    float taper = 0.01; // 定义拖尾结束时的宽度是光标宽度的 `taper` 倍（例如 1%）。
    float center_off = currentCursor.z * 0.5; // 当前光标中心到其边缘的半宽度。
    // `end_off_inv` 和 `end_off` 计算拖尾在 `previousCursor` 处的两个顶点相对于 `previousCursor.x` 的偏移量。
    // `mix` 函数根据 `taper` 值，在光标中心偏移和光标边缘偏移之间进行插值，实现锥形效果。
    float end_off_inv = mix(center_off, currentCursor.z * invertedVertexFactor, taper);
    float end_off = mix(center_off, currentCursor.z * vertexFactor, taper);

    // `v2`: 拖尾在 `previousCursor` 位置的第三个顶点。
    vec2 v2 = vec2(previousCursor.x + end_off_inv, previousCursor.y);

    // `v3`: 拖尾在 `previousCursor` 位置的第四个顶点。
    // NOTE: 切换v3的值,来更改是尖拖尾还是矩形拖尾
    // vec2 v3 = vec2(previousCursor.x + end_off, previousCursor.y - previousCursor.w);
    vec2 v3 = vec2(previousCursor.x + end_off_inv, previousCursor.y);

    vec4 newColor = vec4(fragColor); // 初始化 `newColor` 为当前的背景颜色。

    // 计算动画的当前进度。
    // `clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0)` 将动画时间限制在 `[0, 1]` 范围。
    float progress = blend(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1));
    // 应用 `ease` 函数到 `progress`，使得动画在开始时快，结束时慢。
    float easedProgress = ease(progress);

    // Distance between cursors determine the total length of the parallelogram;
    // 计算当前光标中心 `centerCC` 和前一光标中心 `centerCP` 之间的距离，作为拖尾的基准长度。
    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);
    float lineLength = distance(centerCC, centerCP);
    // 计算当前像素 `vu` 到当前光标中心 `centerCC` 的距离。
    float distanceToEnd = distance(vu.xy, centerCC);
    // 计算一个 `alphaModifier`，用于控制拖尾的透明度，使其在拖尾的末端逐渐变透明。
    // `easedProgress` 参与计算，意味着拖尾的透明度也会随着动画进程而变化。
    float alphaModifier = distanceToEnd / (lineLength * (easedProgress));

    // this change fixed it for me.
    // 确保 `alphaModifier` 不会超过 1.0，防止透明度计算出现异常（例如颜色反转）。
    if (alphaModifier > 1.0) {
        alphaModifier = 1.0;
    }

    // 计算当前像素到光标矩形和拖尾平行四边形（或梯形）的有符号距离。
    float sdfCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);
    float sdfTrail = getSdfParallelogram(vu, v0, v1, v2, v3);

    // `newColor = mix(newColor, TRAIL_COLOR_ACCENT, 1.0 - smoothstep(sdfTrail, -0.01, 0.001));` (此行被注释掉，未生效)
    // 根据 `sdfTrail` 和 `antialising` 函数，将拖尾颜色 `TRAIL_COLOR` 与 `newColor` (当前的背景色) 混合。
    // `antialising(sdfTrail)` 会在拖尾的边缘创建平滑过渡，使边缘抗锯齿。
    newColor = mix(newColor, TRAIL_COLOR, antialising(sdfTrail));

    // 根据 `alphaModifier` 将处理后的 `newColor` 与原始背景色 `fragColor` 再次混合。
    // `1.0 - alphaModifier` 使得 `alphaModifier` 越大（越接近拖尾末端），拖尾的颜色越淡，最终接近背景色。
    newColor = mix(fragColor, newColor, 1.0 - alphaModifier);
    // 最后，将 `newColor` 与原始背景色 `fragColor` 混合，如果当前像素在光标矩形内部 (`sdfCursor <= 0`)，
    // 则 `step(sdfCursor, 0)` 返回 1.0，光标的颜色会被覆盖，否则为 0.0，保持 `newColor`。
    // 这里的 `mix` 顺序看起来是 `fragColor`（背景） 和 `newColor`（拖尾+光标）混合，
    // 如果 `sdfCursor <= 0`，则 `step` 返回 1，结果是 `fragColor`，这可能意味着光标区域不透明，直接显示背景？
    // 通常应该是 `mix(newColor, CURSOR_COLOR, step(sdfCursor, 0))` 来显示光标。
    // 这里的逻辑似乎是：如果点在光标内部，就显示背景色，否则显示拖尾色。这可能是为了在光标自身区域显示原始背景，
    // 只有拖尾区域才显示拖尾颜色。
    fragColor = mix(newColor, fragColor, step(sdfCursor, 0));
}
