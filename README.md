# Traveller
Web Service and SOA课程项目，前端代码

## 项目介绍

### 简介

“Traveller” app is based on B/S structure. It is an iOS app with a Java back-end. Its main objective is to improve people’s living standards by providing travel information for customers. The main functionality of traveller is to help users manage their travel plan, search for information of interesting scenery spots, and share wonderful places of interest with other users.

### 项目架构图

![图](http://cl.ly/3g1p2x0c2Z2X/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202016-06-27%20%E4%B8%8B%E5%8D%889.04.10.png)

## 配置方法

1. 安装pod依赖包（如果没有安装Cocoapod，请先安装Cocoapod）
			
	```
	$ cd Traveller-iOS/Traveller
	$ pod install
	```
2. 安装好后用Xcode打开Traveller.xcworkspace
3. 进入```LogicalLayer -> DataModel -> DataModel.swift```中更改```baseURL```为localhost或运行了Traveller-Server的机器的IP地址
4. 运行
	
**注意：**需要使用Xcode7.3以上的版本。

## 链接

1. 演示视频：

	[http://v.qq.com/page/u/u/h/u0308of23uh.html](http://v.qq.com/page/u/u/h/u0308of23uh.html)
	
2. 后端代码：

	[https://github.com/AndyHT/Traveller_Server](https://github.com/AndyHT/Traveller_Server) （暂未开源）
	
3. 接口文档：（本库Wiki中）
	[https://github.com/MandyXue/Traveller/wiki/%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3](https://github.com/MandyXue/Traveller/wiki/%E6%8E%A5%E5%8F%A3%E6%96%87%E6%A1%A3)

4. 数据库设计文档：（本库Wiki中）
	[https://github.com/MandyXue/Traveller/wiki/%E6%95%B0%E6%8D%AE%E5%BA%93%E8%AE%BE%E8%AE%A1](https://github.com/MandyXue/Traveller/wiki/%E6%95%B0%E6%8D%AE%E5%BA%93%E8%AE%BE%E8%AE%A1)
	
	
====
Copyright &copy; Traveller, Tongji SSE