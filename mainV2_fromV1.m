clc
clear
% 白红分类识别 读入所有图片进行综合分析
%% 步骤 2 - 加载文件夹内的图像
% 加载图像。
imgDir = fullfile(pwd, '图片包2');%读取白色所在文件夹
imgW = imageDatastore(imgDir);%imageDatastore加载图像

% 读取一张图片
IW = readimage(imgW,1);%读取一张图片

figure(3)
imshow(IW)
title('显示一张图片')

%% 步骤 2：将图像从 RGB 颜色空间转换为 L*a*b* 颜色空间
%  L*a*b* 颜色空间是从 CIE XYZ 三色值派生的。
% L*a*b* 空间包含光度层 'L*'、色度层 'a*'（表示颜色落在沿红-绿轴的位置）和色度层 'b*'（表示颜色落在沿蓝-黄轴的位置）。
% 所有颜色信息都在 'a*' 和 'b*' 层。您可以使用欧几里德距离度量来测量两种颜色之间的差异。

A=IW;%这里更改IW和IR，更改处理的对象
lab_he = rgb2lab(A);% 图像从 RGB 颜色空间转换为 L*a*b* 颜色空间
nColors=4;%颜色类别有4种
% 这些值用作“a*b*”空间中的颜色标记。
color_markers=[...
    2    -5;% 背景
    90   20 ;% 红色
    -50  20;% 黄色
    0  0];% 白色|

%% 步骤 3：使用最近邻规则对每个像素进行分类
% 每个颜色标记现在都有一个 'a*' 和一个 'b*' 值。
% 通过计算该像素与每个颜色标记之间的欧几里德距离来对图像中的每个像素进行分类。
% 最小距离会告诉您该像素与该颜色标记最匹配。例如，如果像素与红色标记之间的距离最小，则该像素将被标记为红色像素。

color_labels = 0:nColors-1;

%  初始化要在最近邻分类中使用的矩阵。
a = lab_he(:,:,2);
b = lab_he(:,:,3);
a = double(a);
b = double(b);
distance = zeros([size(a), nColors]);

% 执行分类
for count = 1:nColors
  distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
                      (b - color_markers(count,2)).^2 ).^0.5;
end

[~,label] = min(distance,[],3);
label = color_labels(label);
clear distance;

%% 步骤 4：显示最近邻分类的结果
% 标签矩阵包含织物图像中每个像素的颜色标签。使用标签矩阵按颜色分隔原始织物图像中的对象。

rgb_label = repmat(label,[1 1 3]);
segmented_images = zeros([size(A), nColors],'uint8');

for count = 1:nColors
  color = A;
  color(rgb_label ~= color_labels(count)) = 0;
  segmented_images(:,:,:,count) = color;
end 

%  将4种分段颜色显示为蒙太奇。还显示图像中未分类为颜色的背景像素。
%  第二张图就是红色区域的提取，如果是有红色区域的话，就会被分割出来，如果没有的话，就不会被分割出来
figure(21)
montage({segmented_images(:,:,:,1),segmented_images(:,:,:,2) ...
    segmented_images(:,:,:,3),segmented_images(:,:,:,4)},'Size',[2 2]);
title("Montage of Background,Red, Yellow and White")

%% 步骤 5：提取出来第二张图，也就包含红色区域的图层,然后统计红色的面积来以此判断是红色还是白色的蛋
IR=segmented_images(:,:,:,2);
figure(22)
imshow(IR)
title('分割出来的红色目标区域')

% 灰度处理,为了统计像素面积
Igray=rgb2gray(IR);

% 统计红色区域的面积

Rnum=sum(sum(Igray~=0));

EggColor='';

if Rnum>1000
    EggColor='红蛋'
else
    EggColor='白蛋'
end



