我的学习分享
---
###### >>>2022.03.20<<<

**data.table** (R package) —— 数据框（表格）处理工具、data.frame增强包

相关学习链接:

​	http://brooksandrew.github.io/simpleblog/articles/advanced-data-table/#fast-looping-with-set

​	https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf


---

###### >>> 2021 关于R的基础使用和画图 <<<

1. [R和Rsutdio下载安装](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/intro.html#intro-install)

2. [Rstudio使用](https://github.com/rstudio/cheatsheets/blob/main/rstudio-ide.pdf)

<img src="https://s2.loli.net/2022/03/28/2r4jSP3RZWbwf8B.png" alt="image-20220328165123920" style="zoom: 67%;" />

> Rstudio有4个窗口，第一个窗口可以编辑R Script(点击File -> New File -> R Script)，点击Run依次运行每行代码。
>
> 运行的命令会显示再下方的代码区，也可以直接在下方的代码区输入命令。
>
> 右上角会显示运行中的变量，点击变量可以查看具体内容。
>
> 右下方会显示运行中画的图（`?gglpot()` 函数的帮助文档也会显示在右下方）。

- 修改Rstudio的设置 Tools -> Global Options

<img src="https://s2.loli.net/2022/03/28/MqniS6T85H39oIY.png" alt="image-20220328165348235" style="zoom:33%;" /><img src="https://s2.loli.net/2022/03/28/21Q9Jw6eDMabEvZ.png" alt="image-20220328165447968" style="zoom:33%;" />

> 自定义工作文件夹                                                             修改脚本编码格式为UTF-8，防止中文乱码 



3. 安装R包：

>  安装R包，使用`install.packages()`函数

```R
# 设置镜像（或通过Tools -> Packages -> Primary CRAN repository修改）
options(repos=c(CRAN="http://mirror.tuna.tsinghua.edu.cn/CRAN/")) #国内清华镜像
# 安装sos包
install.packages("sos")
install.packages("sos", lib="D:/R/R-3.3.1/library") #指定安装目录, lib=''
# 加载sos包
library('sos') #或 request('sos')
# 卸载sos包
remove.packages('sos')
```

> 有些包需要从github或Bioconductor上安装，网上也有详细教程

```R
# use devtools to download R packages from github
library(devtools)
install_github('hadley/dplyr')
# download packages from Bioconductor
if (!requireNamespace("BiocManager",quietly = TRUE))
    insatll.packages("BiocManager")
BiocManager::install("RDAVIDWebService")
```



> 集群上可以设置R lib的环境变量。此时，R会先调用设定的lib里的包，再调用R安装目录下的lib。
>
> `export R_LIBS_USER=/hwfssz1/ST_AGRIC/USER/fangdongming/project/yangshuai/software/bin/R/R-4.0.2/library`

 

4. ggplot2使用

```R
data(mpg) #载入数据
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
```

<img src="https://ggplot2-book.org/getting-started_files/figure-html/qscatter-1.png" alt="img" style="zoom: 33%;" />

> ggplot2的**基本思想**就是**将数据ggplot(data=mpg)通过映射函数aes()映射到不同的几何对象(画图函数) geom_point()上**。
>
> 每一个几何对象生成一个图层，因此可以通过`+`来添加几何对象。各几何对象相互独立。

 ```R
 #ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + geom_smooth()
 ggplot(data = mpg) +
 	geom_point(mapping = aes(x = displ, y = hwy)) +
 	geom_smooth(mapping = aes(x = displ, y = hwy))
 ```

<img src="https://ggplot2-book.org/getting-started_files/figure-html/qplot-smooth-1.png" alt="img" style="zoom:33%;" />

> 每个几何对象又有多个**参数**，例如将class映射到点的颜色参数上。

```R
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
	geom_point(mapping = aes(color = class)) +
	geom_smooth(se = FALSE)
```

<img src="https://d33wubrfki0l68.cloudfront.net/dfd1173fb8e51462bee6ae124e20d2fd909441f1/d0eb5/communicate-plots_files/figure-html/unnamed-chunk-2-1.png" alt="img" style="zoom:33%;" />

> ggplot包含各种绘图函数和统计函数，用法都可以在网上搜到。

<img src="https://s2.loli.net/2022/03/28/rmUVCvFEaIjTstB.png" alt="image-20220328170929303" style="zoom: 67%;" />

相关学习资料：

- 《R for Data Science》

- [ggplot2教程](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/ggplot2.html)

- [ggtree教程](https://yulab-smu.top/treedata-book/index.html)



 
