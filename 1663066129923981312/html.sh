#!/bin/bash
# 脚本功能：提取所有 JSON 文件中的 id、profile_image_url 和 screen_name，
# 生成 HTML 页面，每个图像点击后跳转到指定链接，并在图片上方显示红色小字的 screen_name，
# 页面中 Last update 后面显示当前时间（格式：YYYY-MM-DD HH:MM:SS 时区）。

# 提取所有 JSON 文件中的 id, profile_image_url 和 screen_name，
# 使用制表符作为分隔符，避免 screen_name 中出现空格导致拆分问题
entries=$(jq -r '"\(.id)\t\(.profile_image_url)\t\(.screen_name)"' *.json 2>/dev/null | grep -E 'http[s]?://' | sort -u)

# 获取当前日期和时区
update_time="$(date +"%Y-%m-%d %H:%M:%S") $(date +%Z)"

# 生成 HTML 文件
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>视奸你们！</title>
    <link rel="stylesheet" href="gallery/source/bootstrap.min.css">
    <link href="gallery/source/css" rel="stylesheet">
    <link rel="stylesheet" href="gallery/source/baguetteBox.min.css">
    <link rel="stylesheet" href="gallery/source/gallery-grid.css">
    <style>
        /* 将图像缩小一半 */
        .gallery-img {
            width: 50%;
            height: auto;
            display: block;
            margin: 0 auto;
        }
        /* screen_name 红色小字，居中放置在图像上方 */
        .screen-name {
            color: red;
            font-size: 12px;
            text-align: center;
            margin-bottom: 5px;
        }
        .image-container {
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container gallery-container">
    <h1>Akira的推友账号数据库</h1>
    <p class="page-description text-center">Last update: ${update_time}</p>
    <p class="page-description text-center" style="width: 100%; text-align: center; font-size: 14px; color: white;">
        <a href="https://cloud.zi1cgw.top/s/sqkr29G6MXcDAyP" class="page-link" target="_blank">GitHub仓库</a>
    </p>
    <div class="tz-gallery">
        <div class="row">
EOF

# 逐行处理提取结果（使用制表符分隔）
while IFS=$'\t' read -r id url screen_name; do
    cat <<EOF >> index.html
            <div class="col-sm-6 col-md-4 image-container">
                <div class="screen-name">${screen_name}</div>
                <a class="lightbox" href="https://fught19707551.serv00.net/?path=Ak1raQ_love/${id}.json">
                    <img src="${url}" alt="profile image" class="gallery-img">
                </a>
            </div>
EOF
done <<< "$entries"

cat <<'EOF' >> index.html
        </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/baguettebox.js/1.8.1/baguetteBox.min.js"></script>
<script>
    baguetteBox.run('.tz-gallery');
</script>
</body>
</html>
EOF

echo "HTML 生成完成: index.html"

