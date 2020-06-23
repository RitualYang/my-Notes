# react 开发
* 核心
    1. react.js 核心文件
    2. react-dom.js 渲染页面中的DOM 当前文件依赖于react核心文件
    3. babel.js 语言编码转换为浏览器识别的编码
    4. prop-types 验证传递进来的数据是否符合我们的期望类型或要求~~上线模式中请取消~~
    5. pubsub-js 同级组件传值
* 下载
    1. react核心包  	`npm i react --save`
    2. react-dom        `npm i react-dom --save`
    3. babel                 `npm i babel-standalone --save`
    4. prop-types       `npm i prop-types --save`
    5. pubsub-js         `npm i pubsub-js --save`
* 语法介绍
    * jsx（JavaScript xml）：JavaScript的扩展语法
        >执行的效率更快。
        >他是类型安装的，编译的过程中就能及时的发现错误。
        > 在使用jsx的时候编写模板会更加简单和迅速。

## create-react-app 脚手架

* react-router-dom 路由 `npm install --save react-router-dom`
* 拉取脚手架配置: `npm run eject`
* 安装badel-plugin-import   方便antd按需加载   `npm install babel-plugin-import --save-dev` 